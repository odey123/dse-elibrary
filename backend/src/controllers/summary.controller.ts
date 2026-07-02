import { Router, Request, Response } from 'express';
import { createHash, randomUUID } from 'crypto';
import { generateNotebookSummary } from '../services/summary.service';
import { textToSpeech, AVAILABLE_VOICES } from '../services/tts.service';
import { extractTextFromPDF, cleanPDFText } from '../services/pdf.service';
import { db, bucket, FieldValue } from '../services/firebase.service';

const router = Router();

const AUDIO_COLLECTION = 'generated_audio';
const AUDIO_STORAGE_DIR = 'generated_audio';

function computeCacheKey(materialUrl: string, voiceName: string): string {
  return createHash('sha256').update(`${materialUrl}|${voiceName}`).digest('hex');
}

function buildDownloadUrl(bucketName: string, storagePath: string, token: string): string {
  const encoded = encodeURIComponent(storagePath);
  return `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encoded}?alt=media&token=${token}`;
}

/**
 * POST /api/summary/audio
 * Generate (or serve from cache) a NotebookLM-style audio summary.
 *
 * Request body:
 * {
 *   materialUrl: string,
 *   courseName?: string,
 *   voiceName?: string
 * }
 *
 * Response:
 * {
 *   success: boolean,
 *   audioUrl: string,        // Firebase Storage download URL
 *   summaryText: string,
 *   durationEstimate: number,
 *   fromCache: boolean,
 *   playCount: number,
 *   timestamp: string
 * }
 */
router.post('/audio', async (req: Request, res: Response) => {
  try {
    const { materialUrl, courseName, voiceName } = req.body;

    if (!materialUrl || typeof materialUrl !== 'string' || materialUrl.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'materialUrl is required and must be a non-empty string',
      });
    }

    const voice = (voiceName as string) || 'Kore';

    if (!AVAILABLE_VOICES.includes(voice as any)) {
      return res.status(400).json({
        success: false,
        error: `Invalid voice. Available voices: ${AVAILABLE_VOICES.join(', ')}`,
      });
    }

    const url = materialUrl.trim();
    const cacheKey = computeCacheKey(url, voice);

    console.log(`Audio summary requested — cacheKey: ${cacheKey.substring(0, 16)}...`);

    // ── Cache check ──────────────────────────────────────────────────────────
    const cacheRef = db.collection(AUDIO_COLLECTION).doc(cacheKey);
    const cacheDoc = await cacheRef.get();

    if (cacheDoc.exists) {
      const cached = cacheDoc.data()!;
      const newPlayCount = (cached.playCount as number) + 1;

      await cacheRef.update({
        playCount: FieldValue.increment(1),
        lastPlayedAt: FieldValue.serverTimestamp(),
      });

      console.log(`Cache hit — playCount: ${newPlayCount}`);

      return res.json({
        success: true,
        audioUrl: cached.audioUrl as string,
        summaryText: cached.summaryText as string,
        durationEstimate: cached.durationEstimate as number,
        fromCache: true,
        playCount: newPlayCount,
        timestamp: new Date().toISOString(),
      });
    }

    // ── Cache miss: generate ─────────────────────────────────────────────────
    console.log('Cache miss — generating audio summary...');

    console.log('Step 1: Extracting text from PDF...');
    const rawText = await extractTextFromPDF(url);
    const cleanText = cleanPDFText(rawText);

    if (cleanText.length < 50) {
      return res.status(400).json({
        success: false,
        error: 'The PDF contains too little text to generate a meaningful summary',
      });
    }

    console.log(`Extracted ${cleanText.length} characters from PDF`);

    console.log('Step 2: Generating conversational summary...');
    const summaryText = await generateNotebookSummary(cleanText, courseName);
    console.log(`Generated summary: ${summaryText.length} characters`);

    console.log('Step 3: Converting to audio...');
    const audioBuffer = await textToSpeech(summaryText, voice);
    const audioDuration = Math.round((audioBuffer.length - 44) / 48000);
    console.log(`Audio generated: ~${audioDuration}s, ${audioBuffer.length} bytes`);

    // ── Upload to Firebase Storage ───────────────────────────────────────────
    const storagePath = `${AUDIO_STORAGE_DIR}/${cacheKey}.wav`;
    const downloadToken = randomUUID();

    const file = bucket.file(storagePath);
    await file.save(audioBuffer, {
      contentType: 'audio/wav',
      metadata: {
        metadata: { firebaseStorageDownloadTokens: downloadToken },
      },
    });

    const audioUrl = buildDownloadUrl(bucket.name, storagePath, downloadToken);
    console.log(`Uploaded to Storage: ${storagePath}`);

    // ── Write to Firestore cache ─────────────────────────────────────────────
    await cacheRef.set({
      materialUrl: url,
      voiceName: voice,
      audioUrl,
      summaryText,
      durationEstimate: audioDuration,
      playCount: 1,
      createdAt: FieldValue.serverTimestamp(),
      lastPlayedAt: FieldValue.serverTimestamp(),
    });

    console.log('Cached in Firestore');

    return res.json({
      success: true,
      audioUrl,
      summaryText,
      durationEstimate: audioDuration,
      fromCache: false,
      playCount: 1,
      timestamp: new Date().toISOString(),
    });

  } catch (error: any) {
    console.error('Audio summary error:', error);
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to generate audio summary',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * POST /api/summary/text
 * Generate just the text summary (no audio) — faster, lower cost.
 */
router.post('/text', async (req: Request, res: Response) => {
  try {
    const { materialUrl, courseName } = req.body;

    if (!materialUrl || typeof materialUrl !== 'string' || materialUrl.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'materialUrl is required',
      });
    }

    const rawText = await extractTextFromPDF(materialUrl.trim());
    const cleanText = cleanPDFText(rawText);

    if (cleanText.length < 50) {
      return res.status(400).json({
        success: false,
        error: 'The PDF contains too little text to generate a meaningful summary',
      });
    }

    const summaryText = await generateNotebookSummary(cleanText, courseName);

    res.json({
      success: true,
      summaryText,
      timestamp: new Date().toISOString(),
    });

  } catch (error: any) {
    console.error('Text summary error:', error);
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to generate text summary',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * GET /api/summary/voices
 */
router.get('/voices', (_req: Request, res: Response) => {
  res.json({ success: true, voices: AVAILABLE_VOICES });
});

/**
 * GET /api/summary/health
 */
router.get('/health', (_req: Request, res: Response) => {
  res.json({ status: 'ok', service: 'summary', timestamp: new Date().toISOString() });
});

export default router;

import { GoogleGenAI } from '@google/genai';
import dotenv from 'dotenv';

dotenv.config();

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  throw new Error('GEMINI_API_KEY is not set in environment variables');
}

const ai = new GoogleGenAI({ apiKey });

/**
 * Convert text to speech using Gemini's native TTS capability.
 * Uses the gemini-2.5-flash-preview-tts model with responseModalities: ['AUDIO'].
 * 
 * The output is raw 24kHz 16-bit PCM audio, which we wrap in a WAV header
 * before returning.
 * 
 * @param text - The text to convert to speech
 * @param voiceName - The prebuilt voice to use (default: 'Kore')
 * @returns WAV audio as a Buffer
 */
export async function textToSpeech(
  text: string,
  voiceName: string = 'Kore'
): Promise<Buffer> {
  try {
    // Split text into chunks if it's too long (TTS has input limits)
    // Each chunk should be under ~5000 characters for reliable generation
    const maxChunkLength = 4000;
    const chunks = splitTextForTTS(text, maxChunkLength);
    
    console.log(`TTS: Processing ${chunks.length} chunk(s), total ${text.length} chars`);
    
    const audioBuffers: Buffer[] = [];

    for (let i = 0; i < chunks.length; i++) {
      console.log(`TTS: Generating audio for chunk ${i + 1}/${chunks.length}`);
      
      const response = await ai.models.generateContent({
        model: 'gemini-2.5-flash-preview-tts',
        contents: chunks[i],
        config: {
          responseModalities: ['AUDIO'],
          speechConfig: {
            voiceConfig: {
              prebuiltVoiceConfig: {
                voiceName: voiceName,
              },
            },
          },
        },
      });

      // Extract the audio data from the response
      const candidate = response.candidates?.[0];
      if (!candidate?.content?.parts?.[0]?.inlineData?.data) {
        throw new Error(`No audio data returned from TTS for chunk ${i + 1}`);
      }

      const audioBase64 = candidate.content.parts[0].inlineData.data;
      const pcmBuffer = Buffer.from(audioBase64, 'base64');
      audioBuffers.push(pcmBuffer);
    }

    // Combine all PCM buffers
    const combinedPCM = Buffer.concat(audioBuffers);
    
    // Wrap raw PCM in WAV header (24kHz, 16-bit, mono)
    const wavBuffer = addWavHeader(combinedPCM, 24000, 1, 16);

    console.log(`TTS: Generated WAV audio, ${wavBuffer.length} bytes`);

    return wavBuffer;
  } catch (error: any) {
    console.error('Error in text-to-speech:', error);
    throw new Error(`TTS error: ${error.message}`);
  }
}

/**
 * Split text into chunks at sentence boundaries for TTS processing
 */
function splitTextForTTS(text: string, maxLength: number): string[] {
  if (text.length <= maxLength) {
    return [text];
  }

  const chunks: string[] = [];
  let remaining = text;

  while (remaining.length > 0) {
    if (remaining.length <= maxLength) {
      chunks.push(remaining);
      break;
    }

    // Find the last sentence boundary within the limit
    let splitIndex = maxLength;
    const searchArea = remaining.substring(0, maxLength);
    
    // Look for sentence endings (. ! ?)
    const lastPeriod = searchArea.lastIndexOf('. ');
    const lastExclaim = searchArea.lastIndexOf('! ');
    const lastQuestion = searchArea.lastIndexOf('? ');
    
    splitIndex = Math.max(lastPeriod, lastExclaim, lastQuestion);
    
    if (splitIndex <= 0) {
      // No sentence boundary found, split at last space
      splitIndex = searchArea.lastIndexOf(' ');
      if (splitIndex <= 0) {
        splitIndex = maxLength;
      }
    } else {
      splitIndex += 2; // Include the punctuation and space
    }

    chunks.push(remaining.substring(0, splitIndex).trim());
    remaining = remaining.substring(splitIndex).trim();
  }

  return chunks;
}

/**
 * Add WAV header to raw PCM audio data
 * @param pcmData - Raw PCM audio buffer
 * @param sampleRate - Sample rate in Hz (e.g., 24000)
 * @param numChannels - Number of audio channels (1 for mono)
 * @param bitsPerSample - Bits per sample (16)
 * @returns Complete WAV file as Buffer
 */
function addWavHeader(
  pcmData: Buffer,
  sampleRate: number,
  numChannels: number,
  bitsPerSample: number
): Buffer {
  const byteRate = sampleRate * numChannels * (bitsPerSample / 8);
  const blockAlign = numChannels * (bitsPerSample / 8);
  const dataSize = pcmData.length;
  const headerSize = 44;
  const fileSize = headerSize + dataSize - 8;

  const header = Buffer.alloc(headerSize);

  // RIFF header
  header.write('RIFF', 0);
  header.writeUInt32LE(fileSize, 4);
  header.write('WAVE', 8);

  // fmt sub-chunk
  header.write('fmt ', 12);
  header.writeUInt32LE(16, 16); // Sub-chunk size
  header.writeUInt16LE(1, 20);  // Audio format (PCM)
  header.writeUInt16LE(numChannels, 22);
  header.writeUInt32LE(sampleRate, 24);
  header.writeUInt32LE(byteRate, 28);
  header.writeUInt16LE(blockAlign, 32);
  header.writeUInt16LE(bitsPerSample, 34);

  // data sub-chunk
  header.write('data', 36);
  header.writeUInt32LE(dataSize, 40);

  return Buffer.concat([header, pcmData]);
}

/**
 * Available voice options for Gemini TTS
 */
export const AVAILABLE_VOICES = [
  'Kore',      // Clear, professional
  'Puck',      // Warm, friendly
  'Charon',    // Deep, authoritative
  'Fenrir',    // Energetic
  'Aoede',     // Soft, calm
  'Orus',      // Neutral, balanced
] as const;

export type VoiceName = typeof AVAILABLE_VOICES[number];

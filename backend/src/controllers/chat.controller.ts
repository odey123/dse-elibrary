import { Router, Request, Response } from 'express';
import { askQuestion } from '../services/gemini.service';

const router = Router();

/**
 * POST /api/chat/ask
 * Ask a question to the AI with optional course material context
 * 
 * Request body:
 * {
 *   question: string,
 *   materialText?: string,
 *   courseId?: string
 * }
 * 
 * Response:
 * {
 *   success: boolean,
 *   answer: string,
 *   timestamp: string
 * }
 */
router.post('/ask', async (req: Request, res: Response) => {
  try {
    const { question, materialText, courseId } = req.body;

    // Validate question
    if (!question || typeof question !== 'string' || question.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Question is required and must be a non-empty string',
      });
    }

    // Call Gemini service
    const answer = await askQuestion(
      question.trim(),
      materialText ? materialText.trim() : undefined
    );

    // Return successful response
    res.json({
      success: true,
      answer,
      timestamp: new Date().toISOString(),
      metadata: {
        courseId: courseId || null,
        hasContext: !!materialText,
      },
    });

  } catch (error: any) {
    console.error('Chat error:', error);
    
    // Return error response
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to process question',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * GET /api/chat/health
 * Health check for chat service
 */
router.get('/health', (req: Request, res: Response) => {
  res.json({
    status: 'ok',
    service: 'chat',
    timestamp: new Date().toISOString(),
  });
});

export default router;

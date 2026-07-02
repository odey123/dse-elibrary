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
 * POST /api/chat/ask-with-material
 * Ask a question with specific course material context (RAG)
 * 
 * Request body:
 * {
 *   question: string,
 *   materialUrl: string,  // Firebase Storage URL to PDF
 *   courseId?: string
 * }
 * 
 * Response:
 * {
 *   success: boolean,
 *   answer: string,
 *   timestamp: string,
 *   metadata: {
 *     courseId: string,
 *     materialUrl: string,
 *     contextLength: number
 *   }
 * }
 */
router.post('/ask-with-material', async (req: Request, res: Response) => {
  try {
    const { question, materialUrl, courseId } = req.body;

    // Validate inputs
    if (!question || typeof question !== 'string' || question.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Question is required and must be a non-empty string',
      });
    }

    if (!materialUrl || typeof materialUrl !== 'string' || materialUrl.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Material URL is required and must be a non-empty string',
      });
    }

    // Import RAG service dynamically to avoid circular dependency
    const { getContextFromMaterial, buildRAGPrompt } = await import('../services/rag.service');

    // Extract relevant context from the course material
    const context = await getContextFromMaterial(materialUrl.trim(), question.trim());

    // Build RAG-enhanced prompt
    const prompt = buildRAGPrompt(question.trim(), context);

    // Ask Gemini with the enhanced prompt
    const answer = await askQuestion(prompt);

    // Return successful response
    res.json({
      success: true,
      answer,
      timestamp: new Date().toISOString(),
      metadata: {
        courseId: courseId || null,
        materialUrl: materialUrl.trim(),
        contextLength: context.length,
      },
    });

  } catch (error: any) {
    console.error('RAG chat error:', error);
    
    // Return error response
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to process question with material',
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

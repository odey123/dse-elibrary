import { Router, Request, Response } from 'express';
import { generateQuestions, checkAnswerWithHint } from '../services/gemini.service';

const router = Router();

/**
 * POST /api/practice/generate
 * Generate practice questions for a topic
 * 
 * Request body:
 * {
 *   topic: string,
 *   courseId?: string,
 *   difficulty?: 'easy' | 'medium' | 'hard',
 *   numQuestions?: number (default: 5)
 * }
 */
router.post('/generate', async (req: Request, res: Response) => {
  try {
    const { topic, courseId, difficulty = 'medium', numQuestions = 5 } = req.body;

    // Validate topic
    if (!topic || typeof topic !== 'string' || topic.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Topic is required',
      });
    }

    // Validate number of questions
    const count = Math.min(Math.max(parseInt(numQuestions), 1), 10); // Max 10 questions

    // Generate questions
    const questions = await generateQuestions(topic.trim(), difficulty, count);

    res.json({
      success: true,
      questions,
      metadata: {
        topic,
        courseId: courseId || null,
        difficulty,
        count: questions.length,
      },
      timestamp: new Date().toISOString(),
    });

  } catch (error: any) {
    console.error('Question generation error:', error);
    
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to generate questions',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * POST /api/practice/check-answer
 * Check a student's answer and provide hints
 * 
 * Request body:
 * {
 *   question: string,
 *   userAnswer: string,
 *   correctAnswer: string,
 *   hintLevel?: number (0-3, where 0 = no hints yet)
 * }
 */
router.post('/check-answer', async (req: Request, res: Response) => {
  try {
    const { question, userAnswer, correctAnswer, hintLevel = 0 } = req.body;

    // Validate inputs
    if (!question || !userAnswer || !correctAnswer) {
      return res.status(400).json({
        success: false,
        error: 'Question, userAnswer, and correctAnswer are required',
      });
    }

    // Check answer and get hint
    const result = await checkAnswerWithHint(
      question.trim(),
      userAnswer.trim(),
      correctAnswer.trim(),
      parseInt(hintLevel)
    );

    res.json({
      success: true,
      ...result,
      timestamp: new Date().toISOString(),
    });

  } catch (error: any) {
    console.error('Answer checking error:', error);
    
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to check answer',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * GET /api/practice/health
 * Health check for practice service
 */
router.get('/health', (req: Request, res: Response) => {
  res.json({
    status: 'ok',
    service: 'practice',
    timestamp: new Date().toISOString(),
  });
});

export default router;

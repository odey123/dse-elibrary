import { geminiModel, GEMINI_CONFIG } from '../config/gemini.config';

/**
 * Ask a question to Gemini AI with optional context
 * @param question - The user's question
 * @param context - Optional context (course material text)
 * @returns AI-generated answer
 */
export async function askQuestion(
  question: string,
  context?: string
): Promise<string> {
  try {
    // Build the prompt with context if provided
    let prompt = question;
    
    if (context) {
      prompt = `Based on the following course material:\n\n${context}\n\nQuestion: ${question}\n\nPlease provide a clear and helpful answer.`;
    }

    // Generate content
    const result = await geminiModel.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      generationConfig: GEMINI_CONFIG,
    });

    const response = result.response;
    const text = response.text();

    return text;
  } catch (error: any) {
    console.error('Error calling Gemini API:', error);
    throw new Error(`AI service error: ${error.message}`);
  }
}

/**
 * Generate practice questions from a topic
 * @param topic - The topic to generate questions about
 * @param difficulty - Question difficulty level
 * @param count - Number of questions to generate
 * @returns Array of questions with answers
 */
export async function generateQuestions(
  topic: string,
  difficulty: string = 'medium',
  count: number = 5
): Promise<any[]> {
  try {
    const prompt = `Generate ${count} ${difficulty} difficulty practice questions about: ${topic}

For each question, provide:
1. The question text
2. The correct answer
3. A brief explanation

Format the response as a JSON array with this structure:
[
  {
    "question": "question text here",
    "answer": "correct answer here",
    "explanation": "explanation here"
  }
]

Only return valid JSON, no additional text.`;

    const result = await geminiModel.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      generationConfig: {
        ...GEMINI_CONFIG,
        maxOutputTokens: 8192, // Increased for complete responses
      },
    });

    const text = result.response.text();
    
    // Remove markdown code blocks if present
    let cleanText = text.replace(/```json\n?/g, '').replace(/```\n?/g, '');
    
    // Extract JSON from response (sometimes AI adds markdown formatting)
    const jsonMatch = cleanText.match(/\[[\s\S]*\]/);
    if (!jsonMatch) {
      console.error('Failed to extract JSON from response:', text);
      throw new Error('Failed to parse questions from AI response');
    }

    // Clean up any problematic escaped characters
    let jsonString = jsonMatch[0];
    
    // Fix common escape issues
    jsonString = jsonString
      .replace(/\\/g, '\\\\')  // Escape backslashes
      .replace(/\\\\"/g, '\\"')  // Fix double-escaped quotes
      .replace(/\\\\n/g, '\\n'); // Fix double-escaped newlines

    const questions = JSON.parse(jsonString);
    return questions;
  } catch (error: any) {
    console.error('Error generating questions:', error);
    throw new Error(`Question generation error: ${error.message}`);
  }
}

/**
 * Check an answer and provide hints based on hint level
 * @param question - The question being answered
 * @param userAnswer - User's submitted answer
 * @param correctAnswer - The correct answer
 * @param hintLevel - Current hint level (1-4)
 * @returns Feedback with hint if needed
 */
export async function checkAnswerWithHint(
  question: string,
  userAnswer: string,
  correctAnswer: string,
  hintLevel: number = 0
): Promise<{
  correct: boolean;
  feedback: string;
  hint?: string;
  nextHintLevel?: number;
}> {
  try {
    // Check if answer is correct (case-insensitive similarity)
    const isCorrect = userAnswer.toLowerCase().trim() === correctAnswer.toLowerCase().trim();

    if (isCorrect) {
      return {
        correct: true,
        feedback: 'Correct! Well done! 🎉',
      };
    }

    // Generate hint based on level
    let hint = '';
    const nextLevel = Math.min(hintLevel + 1, 4);

    if (hintLevel < 4) {
      const hintPrompts = {
        1: 'Provide a general hint pointing the student in the right direction without giving away the answer.',
        2: 'Provide a more specific hint about the key concept or principle needed to solve this.',
        3: 'Provide a detailed hint including relevant formulas or methods, but not the complete solution.',
        4: 'Provide a step-by-step solution explaining how to arrive at the correct answer.',
      };

      const prompt = `Question: ${question}
Correct Answer: ${correctAnswer}
Student's Answer: ${userAnswer}

The student needs help. ${hintPrompts[nextLevel as keyof typeof hintPrompts]}

Provide only the hint, be encouraging and educational.`;

      const result = await geminiModel.generateContent({
        contents: [{ role: 'user', parts: [{ text: prompt }] }],
        generationConfig: GEMINI_CONFIG,
      });

      hint = result.response.text();
    }

    return {
      correct: false,
      feedback: 'Not quite right. Would you like a hint?',
      hint: hintLevel < 4 ? hint : undefined,
      nextHintLevel: nextLevel <= 4 ? nextLevel : undefined,
    };
  } catch (error: any) {
    console.error('Error checking answer:', error);
    throw new Error(`Answer checking error: ${error.message}`);
  }
}

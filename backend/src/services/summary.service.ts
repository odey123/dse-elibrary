import { geminiModel, GEMINI_CONFIG } from '../config/gemini.config';

/**
 * Generate a NotebookLM-style conversational summary from course material text.
 * This creates an engaging, podcast-like narration that explains key concepts.
 * 
 * @param materialText - Raw text extracted from the PDF material
 * @param courseName - Optional course name for context
 * @returns A conversational summary suitable for audio narration
 */
export async function generateNotebookSummary(
  materialText: string,
  courseName?: string
): Promise<string> {
  try {
    // Trim material if too long (keep under ~30k chars for reliable generation)
    const maxLength = 30000;
    const trimmedText = materialText.length > maxLength
      ? materialText.substring(0, maxLength) + '\n\n[Material truncated for summary...]'
      : materialText;

    const prompt = `You are an expert educational content narrator creating an audio summary for a student. 
Your task is to create a clear, engaging, conversational summary of the following course material.

STYLE GUIDELINES:
- Write as if you're explaining the material to a student in a friendly, conversational podcast style
- Start with a brief introduction: "Let's dive into this material on [topic]..."
- Break down complex concepts into simple, understandable explanations
- Use transitions like "Now, here's the interesting part...", "Moving on to...", "The key takeaway here is..."
- Highlight the most important concepts, definitions, and relationships
- End with a brief recap of the key points
- Keep the summary between 500-1500 words (about 3-8 minutes of audio)
- Do NOT use any markdown formatting, bullet points, numbered lists, or special characters
- Write in pure flowing prose suitable for being read aloud
- Do NOT include any LaTeX, math symbols, or code. Write everything in plain English.
${courseName ? `- This is for the course: ${courseName}` : ''}

COURSE MATERIAL:
${trimmedText}

Generate the audio summary narration now:`;

    const result = await geminiModel.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      generationConfig: {
        ...GEMINI_CONFIG,
        temperature: 0.8, // Slightly more creative for narration
        maxOutputTokens: 8192,
      },
    });

    const text = result.response.text();

    if (!text || text.trim().length === 0) {
      throw new Error('Empty summary response from AI');
    }

    return text.trim();
  } catch (error: any) {
    console.error('Error generating notebook summary:', error);
    throw new Error(`Summary generation error: ${error.message}`);
  }
}

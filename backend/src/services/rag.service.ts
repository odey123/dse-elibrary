import { extractTextFromPDF, cleanPDFText } from './pdf.service';

/**
 * RAG Service - Retrieval Augmented Generation for course materials
 * Extracts text from course PDFs and provides relevant context for AI chat
 */

interface TextChunk {
  text: string;
  index: number;
  relevanceScore?: number;
}

/**
 * Split large text into manageable chunks for processing
 * @param text - Full text to chunk
 * @param maxChunkSize - Maximum characters per chunk
 * @param overlap - Number of characters to overlap between chunks
 * @returns Array of text chunks
 */
export function chunkText(
  text: string,
  maxChunkSize: number = 3000,
  overlap: number = 200
): TextChunk[] {
  const chunks: TextChunk[] = [];
  let startIndex = 0;
  let chunkIndex = 0;

  while (startIndex < text.length) {
    const endIndex = Math.min(startIndex + maxChunkSize, text.length);
    const chunkText = text.slice(startIndex, endIndex);

    chunks.push({
      text: chunkText.trim(),
      index: chunkIndex,
    });

    chunkIndex++;
    startIndex = endIndex - overlap; // Overlap to maintain context
  }

  return chunks;
}

/**
 * Calculate simple relevance score based on keyword matching
 * @param chunk - Text chunk to score
 * @param question - User's question
 * @returns Relevance score (0-1)
 */
function calculateRelevance(chunk: string, question: string): number {
  const chunkLower = chunk.toLowerCase();
  const questionWords = question
    .toLowerCase()
    .split(/\s+/)
    .filter((word) => word.length > 3); // Only use words longer than 3 chars

  let matchCount = 0;
  for (const word of questionWords) {
    if (chunkLower.includes(word)) {
      matchCount++;
    }
  }

  return questionWords.length > 0 ? matchCount / questionWords.length : 0;
}

/**
 * Get the most relevant chunks for a question
 * @param chunks - All text chunks
 * @param question - User's question
 * @param topK - Number of top chunks to return
 * @returns Most relevant chunks sorted by relevance
 */
export function getRelevantChunks(
  chunks: TextChunk[],
  question: string,
  topK: number = 3
): TextChunk[] {
  // Calculate relevance score for each chunk
  const scoredChunks = chunks.map((chunk) => ({
    ...chunk,
    relevanceScore: calculateRelevance(chunk.text, question),
  }));

  // Sort by relevance score (descending)
  scoredChunks.sort((a, b) => (b.relevanceScore || 0) - (a.relevanceScore || 0));

  // Return top K chunks
  return scoredChunks.slice(0, topK);
}

/**
 * Extract and prepare context from a course material URL
 * @param materialUrl - Firebase Storage URL to the PDF
 * @param question - User's question (for relevance filtering)
 * @returns Relevant context text for the AI
 */
export async function getContextFromMaterial(
  materialUrl: string,
  question: string
): Promise<string> {
  try {
    // Extract text from PDF
    const rawText = await extractTextFromPDF(materialUrl);
    const cleanText = cleanPDFText(rawText);

    // If text is short enough, return it all
    if (cleanText.length <= 5000) {
      return cleanText;
    }

    // For longer texts, chunk and get most relevant parts
    const chunks = chunkText(cleanText);
    const relevantChunks = getRelevantChunks(chunks, question, 3);

    // Combine relevant chunks into context
    const context = relevantChunks
      .map((chunk, idx) => `[Section ${idx + 1}]\n${chunk.text}`)
      .join('\n\n');

    return context;
  } catch (error: any) {
    console.error('Error getting context from material:', error);
    throw new Error(`Failed to extract context: ${error.message}`);
  }
}

/**
 * Build a RAG-enhanced prompt for the AI
 * @param question - User's question
 * @param context - Retrieved context from course material
 * @returns Formatted prompt for Gemini
 */
export function buildRAGPrompt(question: string, context: string): string {
  return `You are a helpful AI assistant for students studying Systems Engineering. 
You have been provided with relevant course material to help answer the student's question.

COURSE MATERIAL CONTEXT:
${context}

STUDENT'S QUESTION:
${question}

INSTRUCTIONS:
- Answer the question based PRIMARILY on the provided course material
- If the material doesn't contain the answer, say so clearly
- Be helpful, clear, and educational
- Use examples from the material when relevant
- Do NOT use LaTeX or math markup - write all math in plain readable text

Your answer:`;
}

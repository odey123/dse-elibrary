// eslint-disable-next-line @typescript-eslint/no-var-requires
const pdf = require('pdf-parse');
import axios from 'axios';

/**
 * Extract text content from a PDF file
 * @param pdfUrl - URL to the PDF file (Firebase Storage URL or any accessible URL)
 * @returns Extracted text content from the PDF
 */
export async function extractTextFromPDF(pdfUrl: string): Promise<string> {
  try {
    // Download the PDF file as a buffer
    const response = await axios.get(pdfUrl, {
      responseType: 'arraybuffer',
      timeout: 30000, // 30 second timeout
    });

    const dataBuffer = Buffer.from(response.data);

    // Parse the PDF and extract text
    const data = await pdf(dataBuffer);

    // Return the extracted text
    return data.text;
  } catch (error: any) {
    console.error('Error extracting text from PDF:', error);
    throw new Error(`Failed to extract PDF text: ${error.message}`);
  }
}

/**
 * Clean and prepare PDF text for AI processing
 * @param text - Raw text extracted from PDF
 * @returns Cleaned text suitable for AI context
 */
export function cleanPDFText(text: string): string {
  return text
    .replace(/\s+/g, ' ') // Replace multiple spaces with single space
    .replace(/\n+/g, '\n') // Replace multiple newlines with single newline
    .trim();
}

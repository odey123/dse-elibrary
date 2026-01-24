import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Validate API key
const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  throw new Error('GEMINI_API_KEY is not set in environment variables');
}

// Initialize Gemini API
const genAI = new GoogleGenerativeAI(apiKey);

// Get the Gemini model (using gemini-2.5-flash - latest available model)
export const geminiModel = genAI.getGenerativeModel({
  model: 'gemini-2.5-flash',
});

// Configuration constants
export const GEMINI_CONFIG = {
  temperature: 0.7,
  topK: 40,
  topP: 0.95,
  maxOutputTokens: 8192, // Increased for complete responses
};

export default genAI;

import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';

dotenv.config();

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  console.error('❌ GEMINI_API_KEY not found in .env');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(apiKey);

async function listAvailableModels() {
  try {
    console.log('🔍 Fetching available Gemini models...\n');

    // Use REST API to fetch models
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`
    );

    if (!response.ok) {
      throw new Error(`Failed to fetch models: ${response.status} ${response.statusText}`);
    }

    const data: any = await response.json();
    const models = data.models || [];

    console.log(`✅ Found ${models.length} available models:\n`);

    models.forEach((model: any, index: number) => {
      console.log(`${index + 1}. ${model.name}`);
      console.log(`   Display Name: ${model.displayName || 'N/A'}`);
      console.log(`   Description: ${model.description || 'N/A'}`);
      console.log(`   Supported Methods: ${model.supportedGenerationMethods?.join(', ') || 'N/A'}`);
      console.log('');
    });

    // Find models that support generateContent
    const contentGenModels = models.filter((m: any) =>
      m.supportedGenerationMethods?.includes('generateContent')
    );

    console.log(`\n📝 Models that support 'generateContent' (${contentGenModels.length}):`);
    contentGenModels.forEach((model: any) => {
      console.log(`   - ${model.name}`);
    });

    if (contentGenModels.length > 0) {
      console.log(`\n💡 Recommended: Use this model name in gemini.config.ts:`);
      // Extract just the model name without the "models/" prefix if present
      const modelName = contentGenModels[0].name.replace('models/', '');
      console.log(`   model: '${modelName}'`);
    }

  } catch (error: any) {
    console.error('❌ Error listing models:');
    console.error(error.message);
    process.exit(1);
  }
}

listAvailableModels();

const { GoogleGenerativeAI } = require('@google/generative-ai');
require('dotenv').config();

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  console.error('❌ GEMINI_API_KEY not found in .env');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(apiKey);

async function listAvailableModels() {
  try {
    console.log('🔍 Checking available Gemini models for your API key...\n');
    
    // Try common model names
    const modelsToTry = [
      'gemini-pro',
      'gemini-1.0-pro',
      'gemini-1.5-pro',
      'gemini-1.5-flash',
      'gemini-1.5-flash-latest',
      'gemini-2.0-flash-exp',
      'models/gemini-pro',
      'models/gemini-1.5-flash'
    ];
    
    console.log('Testing common Gemini model names...\n');
    
    for (const modelName of modelsToTry) {
      try {
        const model = genAI.getGenerativeModel({ model: modelName });
        const result = await model.generateContent('Test');
        console.log(`✅ ${modelName} - WORKS!`);
        console.log(`   Response: ${result.response.text().substring(0, 50)}...`);
        console.log(`\n💡 USE THIS MODEL in gemini.config.ts:\n   model: '${modelName}'\n`);
        return; // Found a working model, exit
      } catch (error) {
        console.log(`❌ ${modelName} - Not available`);
      }
    }
    
    console.log('\n⚠️  No working models found. Your API key might:');
    console.log('   1. Need to be regenerated at ai.google.dev');
    console.log('   2. Have restrictions or quota limits');
    console.log('   3. Be for a different API version\n');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

listAvailableModels();

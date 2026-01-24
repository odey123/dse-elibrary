const { GoogleGenerativeAI } = require('@google/generative-ai');
require('dotenv').config();

const apiKey = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(apiKey);

async function testModels() {
  // List of models to try (newer naming convention)
  const modelsToTry = [
    'gemini-1.5-pro-latest',
    'gemini-1.5-flash-latest',
    'gemini-pro',
    'gemini-1.5-pro',
    'gemini-1.5-flash'
  ];

  console.log('🔍 Testing available Gemini models...\n');

  for (const modelName of modelsToTry) {
    try {
      console.log(`Testing: ${modelName}...`);
      const model = genAI.getGenerativeModel({ model: modelName });
      const result = await model.generateContent('Say "success"');
      const text = result.response.text();

      console.log(`✅ ${modelName} WORKS!`);
      console.log(`   Response: ${text}\n`);

      console.log(`💡 Use this model name in your code:`);
      console.log(`   model: '${modelName}'\n`);
      break;
    } catch (error) {
      console.log(`❌ ${modelName} failed: ${error.message}\n`);
    }
  }
}

testModels();

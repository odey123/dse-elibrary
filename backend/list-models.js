const { GoogleGenerativeAI } = require('@google/generative-ai');
require('dotenv').config();

const apiKey = process.env.GEMINI_API_KEY;

async function listModels() {
  console.log('🔍 Listing available models for your API key...\n');

  try {
    // Try to fetch available models using REST API
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`
    );

    if (!response.ok) {
      const errorText = await response.text();
      console.log('❌ Error fetching models:');
      console.log('   Status:', response.status, response.statusText);
      console.log('   Response:', errorText);

      if (response.status === 400) {
        console.log('\n⚠️  API key might be invalid or not enabled for Gemini API');
        console.log('\n📝 Steps to fix:');
        console.log('   1. Go to https://aistudio.google.com/app/apikey');
        console.log('   2. Create a NEW API key (or verify existing one)');
        console.log('   3. Make sure Generative Language API is enabled');
        console.log('   4. Update backend/.env with the new key');
      }
      return;
    }

    const data = await response.json();

    if (data.models && data.models.length > 0) {
      console.log('✅ Available models:\n');
      data.models.forEach(model => {
        console.log(`   - ${model.name}`);
        if (model.supportedGenerationMethods) {
          console.log(`     Methods: ${model.supportedGenerationMethods.join(', ')}`);
        }
      });

      console.log('\n💡 Use the model name after "models/" in your code');
      console.log(`   Example: const model = genAI.getGenerativeModel({ model: '${data.models[0].name.replace('models/', '')}' });`);
    } else {
      console.log('⚠️  No models found');
    }

  } catch (error) {
    console.log('❌ Error:', error.message);
    console.log('\n🔑 Your API key might not have access to Gemini API');
    console.log('\n📝 To fix:');
    console.log('   1. Visit https://aistudio.google.com/app/apikey');
    console.log('   2. Create a new API key');
    console.log('   3. Copy the ENTIRE key');
    console.log('   4. Update backend/.env');
  }
}

listModels();

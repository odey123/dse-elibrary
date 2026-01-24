const { GoogleGenerativeAI } = require('@google/generative-ai');
require('dotenv').config();

console.log('🔍 Gemini API Key Diagnostic\n');

// Check if API key is loaded
const apiKey = process.env.GEMINI_API_KEY;

if (!apiKey) {
  console.error('❌ GEMINI_API_KEY not found in .env file');
  process.exit(1);
}

console.log(`✅ API Key loaded from .env`);
console.log(`   Length: ${apiKey.length} characters`);
console.log(`   Starts with: ${apiKey.substring(0, 10)}...`);
console.log(`   Ends with: ...${apiKey.substring(apiKey.length - 4)}\n`);

// Initialize client
const genAI = new GoogleGenerativeAI(apiKey);
console.log('✅ GoogleGenerativeAI client initialized\n');

// Try the simplest possible request
async function testAPI() {
  console.log('🧪 Testing simplest Gemini API request...\n');
  
  try {
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    console.log('✅ Got model instance for: gemini-1.5-flash');
    
    console.log('📤 Sending test prompt...');
    const result = await model.generateContent('Say hello');
    
    console.log('✅ SUCCESS! API is working!\n');
    console.log('Response:', result.response.text());
    console.log('\n💡 Use this in gemini.config.ts:');
    console.log('   model: \'gemini-1.5-flash\'');
    
  } catch (error) {
    console.log('❌ Error:', error.message);
    
    if (error.message.includes('API_KEY_INVALID')) {
      console.log('\n🔑 Your API key appears to be invalid');
      console.log('   1. Go to https://aistudio.google.com/apikeys');
      console.log('   2. Create a NEW API key');
      console.log('   3. Make sure you copy the ENTIRE key');
      console.log('   4. Update backend/.env file');
    } else if (error.message.includes('404')) {
      console.log('\n📋 Model not found - trying alternate names...\n');
      
      // Try with different SDK versions approach
      const alternates = ['gemini-pro', 'gemini-1.0-pro'];
      for (const modelName of alternates) {
        try {
          console.log(`   Testing: ${modelName}...`);
          const altModel = genAI.getGenerativeModel({ model: modelName });
          const altResult = await altModel.generateContent('test');
          console.log(`   ✅ ${modelName} WORKS!`);
          console.log(`\n💡 Use this in gemini.config.ts:`);
          console.log(`   model: '${modelName}'`);
          return;
        } catch (e) {
          console.log(`   ❌ ${modelName} failed`);
        }
      }
      
      console.log('\n⚠️  Possible issues:');
      console.log('   1. API key might be for wrong Google service');
      console.log('   2. Need to enable Gemini API in Google Cloud Console');
      console.log('   3. Geographic restrictions on your API key');
    }
  }
}

testAPI();

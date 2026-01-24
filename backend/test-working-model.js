const { GoogleGenerativeAI } = require('@google/generative-ai');
require('dotenv').config();

const apiKey = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(apiKey);

async function testModel() {
  console.log('🧪 Testing gemini-2.5-flash...\n');

  try {
    const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });
    const result = await model.generateContent('Say "Hello! Gemini API is working perfectly!"');
    const text = result.response.text();

    console.log('✅ SUCCESS! API is working!\n');
    console.log('Response:', text);
    console.log('\n💡 Recommended model to use in your code:');
    console.log('   model: \'gemini-2.5-flash\'');
    console.log('\n📝 Alternative models you can use:');
    console.log('   - gemini-2.5-pro (more powerful, slower)');
    console.log('   - gemini-flash-latest (auto-updates to latest flash)');
    console.log('   - gemini-pro-latest (auto-updates to latest pro)');

  } catch (error) {
    console.log('❌ Error:', error.message);
  }
}

testModel();

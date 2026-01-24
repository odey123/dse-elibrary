require('dotenv').config();

const apiKey = process.env.GEMINI_API_KEY;

async function testGeminiREST() {
  console.log('🧪 Testing Gemini API via REST (bypassing SDK)\n');
  
  const models = [
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-pro',
    'gemini-1.0-pro'
  ];
  
  for (const model of models) {
    try {
      const url = `https://generativelanguage.googleapis.com/v1/models/${model}:generateContent?key=${apiKey}`;
      
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          contents: [{
            parts: [{
              text: 'Say hello in one word'
            }]
          }]
        })
      });
      
      const data = await response.json();
      
      if (response.ok && data.candidates) {
        const text = data.candidates[0].content.parts[0].text;
        console.log(`✅ ${model} WORKS!`);
        console.log(`   Response: ${text}`);
        console.log(`\n🎉 SUCCESS! Use this model:\n   model: '${model}'\n`);
        return model;
      } else {
        console.log(`❌ ${model} - ${data.error?.message || 'Failed'}`);
      }
    } catch (error) {
      console.log(`❌ ${model} - ${error.message}`);
    }
  }
  
  console.log('\n❌ No models working. This suggests:');
  console.log('   1. API key might need regeneration');
  console.log('   2. Try using the OTHER key from your Google AI Studio');
  console.log('   3. Or create a brand new key\n');
}

testGeminiREST();

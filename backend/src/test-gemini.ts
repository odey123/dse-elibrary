import { askQuestion } from './services/gemini.service';

async function testGemini() {
  try {
    console.log('Testing Gemini API connection...\n');
    
    const response = await askQuestion(
      'What is Systems Engineering?',
    );
    
    console.log('✅ Gemini API is working!');
    console.log('\nResponse:');
    console.log(response);
    console.log('\n✨ Test successful!');
  } catch (error: any) {
    console.error('❌ Gemini API test failed:');
    console.error(error.message);
    process.exit(1);
  }
}

testGemini();

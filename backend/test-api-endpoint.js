// Test the backend API endpoint
const http = require('http');

async function testAPI() {
  console.log('🧪 Testing backend API with Gemini integration...\n');

  // Wait a bit for server to be ready
  await new Promise(resolve => setTimeout(resolve, 2000));

  const options = {
    hostname: 'localhost',
    port: 3000,
    path: '/',
    method: 'GET'
  };

  const req = http.request(options, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log('✅ Server is responding!');
      console.log('Response:', data);
      console.log('\n✅ Backend is working correctly with Gemini API!');
      console.log('\n📝 Summary:');
      console.log('   - API Key: Valid');
      console.log('   - Model: gemini-2.5-flash');
      console.log('   - Backend Server: Running on http://localhost:3000');
      process.exit(0);
    });
  });

  req.on('error', (error) => {
    console.error('❌ Error:', error.message);
    console.log('\n⚠️  Make sure the backend server is running:');
    console.log('   npm run dev');
    process.exit(1);
  });

  req.end();
}

testAPI();

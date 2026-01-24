# DSE E-Library AI Backend

Backend API server for AI-enhanced features in the DSE E-Library system.

## Features
- 🤖 AI Chat Assistant (Gemini API)
- 📝 Practice Question Generator
- 💡 Progressive Hint System (4 levels)

## Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment
Create a `.env` file in the backend folder:
```
GEMINI_API_KEY=your_api_key_here
PORT=3000
NODE_ENV=development
```

**Get your Gemini API key:**
- Go to https://aistudio.google.com
- Click "Get API Key"
- Copy your key and paste it in `.env`

### 3. Test Gemini Connection
```bash
npx ts-node src/test-gemini.ts
```

### 4. Run Development Server
```bash
npm run dev
```

Server will start at `http://localhost:3000`

## API Endpoints

### Health Check
```bash
GET /
GET /api/health
```

### Chat (Coming in Day 4)
```bash
POST /api/chat/ask
```

### Practice Questions (Coming in Day 7-8)
```bash
POST /api/practice/generate
POST /api/practice/check-answer
```

## Development

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Run production build

## Deployment (Vercel)

1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel`
3. Follow prompts
4. Add `GEMINI_API_KEY` to Vercel environment variables

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── gemini.config.ts      # Gemini API setup
│   ├── services/
│   │   └── gemini.service.ts     # AI functions
│   ├── controllers/
│   │   ├── chat.controller.ts    # Chat endpoints (Day 4)
│   │   └── practice.controller.ts # Practice endpoints (Day 7-8)
│   ├── middleware/               # Auth, validation (as needed)
│   ├── app.ts                    # Express server
│   └── test-gemini.ts            # API test script
├── .env                          # Environment variables (DO NOT COMMIT)
├── .gitignore
├── package.json
├── tsconfig.json
└── nodemon.json
```

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **AI**: Google Gemini API
- **Deployment**: Vercel

---

**Next Steps**: Complete Day 3 & 4 to add chat endpoints!

# API Endpoints Documentation

## Base URL
`http://localhost:3000`

---

## Chat Endpoints

### 1. Ask AI a Question
**Endpoint:** `POST /api/chat/ask`

**Description:** Ask the AI a question with optional course material context

**Request Body:**
```json
{
  "question": "What is Systems Engineering?",
  "materialText": "Optional course material text for context...",
  "courseId": "SYS301"
}
```

**Response (Success):**
```json
{
  "success": true,
  "answer": "Systems Engineering is an interdisciplinary field...",
  "timestamp": "2026-01-17T02:20:00.000Z",
  "metadata": {
    "courseId": "SYS301",
    "hasContext": true
  }
}
```

**Response (Error):**
```json
{
  "success": false,
  "error": "Question is required and must be a non-empty string",
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

---

### 2. Chat Service Health
**Endpoint:** `GET /api/chat/health`

**Response:**
```json
{
  "status": "ok",
  "service": "chat",
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

---

## Practice Endpoints

### 3. Generate Practice Questions
**Endpoint:** `POST /api/practice/generate`

**Description:** Generate practice questions for a topic

**Request Body:**
```json
{
  "topic": "Control Systems",
  "courseId": "SYS401",
  "difficulty": "medium",
  "numQuestions": 5
}
```

**Difficulty Options:** `easy`, `medium`, `hard`  
**Num Questions:** 1-10 (default: 5)

**Response:**
```json
{
  "success": true,
  "questions": [
    {
      "question": "What is a feedback loop in control systems?",
      "answer": "A feedback loop is a process where...",
      "explanation": "Feedback loops are essential because..."
    }
  ],
  "metadata": {
    "topic": "Control Systems",
    "courseId": "SYS401",
    "difficulty": "medium",
    "count": 5
  },
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

---

### 4. Check Answer with Hints
**Endpoint:** `POST /api/practice/check-answer`

**Description:** Check a student's answer and provide progressive hints

**Request Body:**
```json
{
  "question": "What is a feedback loop?",
  "userAnswer": "A type of loop",
  "correctAnswer": "A feedback loop is a process where the output is fed back...",
  "hintLevel": 0
}
```

**Hint Levels:**
- `0` - No hints yet (first attempt)
- `1` - General guidance
- `2` - Specific concept hint
- `3` - Formula or approach
- `4` - Step-by-step solution

**Response (Incorrect):**
```json
{
  "success": true,
  "correct": false,
  "feedback": "Not quite right. Would you like a hint?",
  "hint": "Think about how information flows in a control system...",
  "nextHintLevel": 1,
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

**Response (Correct):**
```json
{
  "success": true,
  "correct": true,
  "feedback": "Correct! Well done! 🎉",
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

---

### 5. Practice Service Health
**Endpoint:** `GET /api/practice/health`

**Response:**
```json
{
  "status": "ok",
  "service": "practice",
  "timestamp": "2026-01-17T02:20:00.000Z"
}
```

---

## Testing with cURL

### Test Chat Endpoint
```bash
curl -X POST http://localhost:3000/api/chat/ask \
  -H "Content-Type: application/json" \
  -d "{\"question\": \"What is Systems Engineering?\"}"
```

### Test Practice Generation
```bash
curl -X POST http://localhost:3000/api/practice/generate \
  -H "Content-Type: application/json" \
  -d "{\"topic\": \"Control Systems\", \"difficulty\": \"medium\", \"numQuestions\": 3}"
```

### Test Answer Checking
```bash
curl -X POST http://localhost:3000/api/practice/check-answer \
  -H "Content-Type: application/json" \
  -d "{\"question\": \"What is 2+2?\", \"userAnswer\": \"4\", \"correctAnswer\": \"4\", \"hintLevel\": 0}"
```

---

## Error Codes

| Status | Meaning |
|--------|---------|
| 200 | Success |
| 400 | Bad Request (invalid input) |
| 500 | Internal Server Error (AI service error) |

---

**Server must be running:** `npm run dev`

# Test API Endpoints (PowerShell)

# Test 1: Chat Health Check
Write-Host "`n=== Test 1: Chat Health ===" -ForegroundColor Cyan
Invoke-WebRequest -Uri "http://localhost:3000/api/chat/health" | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

# Test 2: Practice Health Check
Write-Host "`n=== Test 2: Practice Health ===" -ForegroundColor Cyan
Invoke-WebRequest -Uri "http://localhost:3000/api/practice/health" | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

# Test 3: Ask AI a Question
Write-Host "`n=== Test 3: Ask AI ===" -ForegroundColor Cyan
$body = @{
    question = "What is Systems Engineering?"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3000/api/chat/ask" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

# Test 4: Generate Practice Questions
Write-Host "`n=== Test 4: Generate Questions ===" -ForegroundColor Cyan
$body = @{
    topic = "Control Systems"
    difficulty = "easy"
    numQuestions = 2
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3000/api/practice/generate" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

Write-Host "`n✅ All tests complete!`n" -ForegroundColor Green

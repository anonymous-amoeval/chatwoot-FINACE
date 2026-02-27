#!/usr/bin/env pwsh
Write-Host ""
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Starting GPT Finance API Server" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

# Check virtual environment
if (-not (Test-Path -Path "venv")) {
    Write-Host "ERROR venv not found!" -ForegroundColor Red
    Write-Host "Please run: .\setup_dev_env.ps1" -ForegroundColor Yellow
    Exit 1
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

# Check .env file
$envPath = "backendAPI\gp\flaskback\backend_api\.env"
if (-not (Test-Path -Path $envPath)) {
    Write-Host "WARNING .env file not found, creating template..." -ForegroundColor Yellow
    $envDir = Split-Path -Path $envPath -Parent
    if (-not (Test-Path -Path $envDir)) {
        New-Item -ItemType Directory -Path $envDir -Force | Out-Null
    }
    
    $envContent = @"
# OpenAI API Configuration
OPENAI_API_KEY=sk-your-actual-key-here

# Database Configuration
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=gp_data
DB_PASSWORD=jizbpLWSCSB5Jpyr
DB_NAME=gp_data

# Chatwoot Configuration
CHATWOOT_URL=https://chatwootgp-c6fd041db72e.herokuapp.com
CHATWOOT_BOT_TOKEN=BxjuXQJ4PTkPuUsMctrcKTBc
CHATWOOT_API_TOKEN=Yc69AgDCiYwpQr4Zun4tQrDv
CHATWOOT_ACCOUNT_ID=1

# OpenAI Assistant
ASSISTANT_ID=asst_VEDt30cOoG7hHJEDEvAsHHjW
"@
    
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Host "OK .env file created" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT: Edit $envPath" -ForegroundColor Yellow
    Write-Host "   Set OPENAI_API_KEY to your actual API key" -ForegroundColor Yellow
    Write-Host ""
}

# Change to backend directory
cd backendAPI\gp\flaskback

Write-Host ""
Write-Host "====================================================" -ForegroundColor Green
Write-Host "  Starting Flask Development Server..." -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Tips:" -ForegroundColor Cyan
Write-Host "   > API URL: http://localhost:5000" -ForegroundColor Gray
Write-Host "   > Auto-reloading enabled" -ForegroundColor Gray
Write-Host "   > Stop server: Press Ctrl+C" -ForegroundColor Gray
Write-Host ""
Write-Host "Test API (open new PowerShell window):" -ForegroundColor Cyan
Write-Host "   curl http://localhost:5000/getallkycstatus" -ForegroundColor Yellow
Write-Host ""
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""

# Start Flask server
python -m flask --app backend_api.main run --debug

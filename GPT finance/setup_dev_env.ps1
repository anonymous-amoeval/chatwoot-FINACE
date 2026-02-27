#!/usr/bin/env pwsh
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GPT Finance Local Dev Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Python
Write-Host "[1/6] Checking Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "OK Python installed: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR Python not found! Download from https://python.org" -ForegroundColor Red
    Exit 1
}

# Step 2: Create virtual environment
Write-Host ""
Write-Host "[2/6] Creating virtual environment..." -ForegroundColor Yellow
if (Test-Path -Path "venv") {
    Write-Host "INFO venv already exists, skipping..." -ForegroundColor Cyan
} else {
    python -m venv venv
    Write-Host "OK venv created" -ForegroundColor Green
}

# Step 3: Activate virtual environment
Write-Host ""
Write-Host "[3/6] Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"
Write-Host "OK venv activated" -ForegroundColor Green

# Step 4: Upgrade pip
Write-Host ""
Write-Host "[4/6] Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip --quiet
Write-Host "OK pip upgraded" -ForegroundColor Green

# Step 5: Install dependencies
Write-Host ""
Write-Host "[5/6] Installing Python packages..." -ForegroundColor Yellow
$packages = @(
    "flask",
    "flask-cors",
    "pymysql",
    "requests",
    "beautifulsoup4",
    "googlesearch-python",
    "openai",
    "python-dotenv",
    "langchain"
)

foreach ($package in $packages) {
    Write-Host "  > Installing $package..." -ForegroundColor Gray
    pip install $package --quiet
}
Write-Host "OK All packages installed" -ForegroundColor Green

# Step 6: Create .env file
Write-Host ""
Write-Host "[6/6] Creating environment config..." -ForegroundColor Yellow

$envPath = "backendAPI\gp\flaskback\backend_api\.env"
$envDir = Split-Path -Path $envPath -Parent

if (-not (Test-Path -Path $envDir)) {
    New-Item -ItemType Directory -Path $envDir -Force | Out-Null
}

if (-not (Test-Path -Path $envPath)) {
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
    Write-Host "OK .env file created at: $envPath" -ForegroundColor Green
    Write-Host "WARNING Edit .env and add your OpenAI API key!" -ForegroundColor Yellow
} else {
    Write-Host "INFO .env already exists, skipping..." -ForegroundColor Cyan
}

# Done
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Edit .env file and add OpenAI API key:"
Write-Host "   $envPath" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Start MySQL database (Docker recommended):"
Write-Host "   docker run --name gp-mysql -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=gp_data -p 3306:3306 -d mysql:8.0" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Initialize database (first time only):"
Write-Host "   python setup_database.py" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. Start Flask API server:"
Write-Host "   cd backendAPI\gp\flaskback" -ForegroundColor Yellow
Write-Host "   python -m flask --app backend_api.main run --debug" -ForegroundColor Yellow
Write-Host ""
Write-Host "5. Test API in another PowerShell:"
Write-Host "   curl http://localhost:5000/getallkycstatus" -ForegroundColor Yellow
Write-Host ""

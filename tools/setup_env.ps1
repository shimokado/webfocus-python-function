# setup_env.ps1
# WebFOCUS Python Function Development Environment Setup Script

Write-Host "Starting environment setup..." -ForegroundColor Cyan

# 1. Find Python 3.9
$pythonPath = "python"
$version = & $pythonPath --version 2>&1
if ($version -notmatch "Python 3.9") {
    Write-Host "Default 'python' is not 3.9 ($version). Searching for Python 3.9..." -ForegroundColor Yellow
    
    $possiblePaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python39\python.exe",
        "$env:ProgramFiles\Python39\python.exe",
        "C:\Python39\python.exe"
    )
    
    $found = $false
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $pythonPath = $path
            $found = $true
            Write-Host "Found Python 3.9 at: $path" -ForegroundColor Green
            break
        }
    }
    
    if (-not $found) {
        Write-Error "Python 3.9 not found. Please install Python 3.9 first."
        exit 1
    }
}
else {
    Write-Host "Using default 'python' ($version)" -ForegroundColor Green
}

# 2. Create venv
$venvPath = "venv"
if (Test-Path $venvPath) {
    Write-Host "venv already exists at $venvPath" -ForegroundColor Yellow
}
else {
    Write-Host "Creating venv at $venvPath..." -ForegroundColor Cyan
    & $pythonPath -m venv $venvPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create venv."
        exit 1
    }
    Write-Host "venv created successfully." -ForegroundColor Green
}

# 3. Activate venv and install requirements
Write-Host "Installing requirements from requirements.txt..." -ForegroundColor Cyan
$pipPath = "$venvPath\Scripts\pip.exe"

if (-not (Test-Path $pipPath)) {
    Write-Error "pip not found at $pipPath. venv creation might have failed."
    exit 1
}

& $pipPath install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install requirements."
    exit 1
}

Write-Host "Environment setup complete!" -ForegroundColor Green
Write-Host "To activate the environment, run: .\venv\Scripts\Activate.ps1" -ForegroundColor Cyan

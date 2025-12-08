# sync_libraries.ps1
param(
    [string]$WebFOCUSPythonPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python39\python.exe",
    [string]$VenvPythonPath = ".\venv\Scripts\python.exe",
    [string]$RequirementsFile = "requirements.txt"
)

Write-Host "=== WebFOCUS Python Library Sync Tool ===" -ForegroundColor Green
Write-Host "Syncing libraries between development and WebFOCUS environments" -ForegroundColor Gray
Write-Host ""

# Check if requirements.txt exists
if (-not (Test-Path $RequirementsFile)) {
    Write-Error "requirements.txt not found in current directory. Please ensure you're running this from the project root."
    exit 1
}

# Check if WebFOCUS Python exists
if (-not (Test-Path $WebFOCUSPythonPath)) {
    Write-Warning "WebFOCUS Python not found at: $WebFOCUSPythonPath"
    Write-Host "Please specify the correct path using -WebFOCUSPythonPath parameter" -ForegroundColor Yellow
    Write-Host "Example: .\sync_libraries.ps1 -WebFOCUSPythonPath 'C:\ibi\srv90\home\etc\python\python.exe'" -ForegroundColor Yellow
    exit 1
}

# Check if venv exists
if (-not (Test-Path $VenvPythonPath)) {
    Write-Warning "Virtual environment not found at: $VenvPythonPath"
    Write-Host "Please ensure venv is created and activated, or specify the correct path using -VenvPythonPath parameter" -ForegroundColor Yellow
    exit 1
}

Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  WebFOCUS Python: $WebFOCUSPythonPath" -ForegroundColor White
Write-Host "  venv Python: $VenvPythonPath" -ForegroundColor White
Write-Host "  Requirements: $RequirementsFile" -ForegroundColor White
Write-Host ""

# 1. Install to WebFOCUS Python
Write-Host "Step 1: Installing libraries to WebFOCUS Python environment..." -ForegroundColor Yellow
try {
    & $WebFOCUSPythonPath -m pip install --quiet -r $RequirementsFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ WebFOCUS Python installation completed successfully" -ForegroundColor Green
    } else {
        Write-Error "✗ WebFOCUS Python installation failed"
        exit 1
    }
} catch {
    Write-Error "✗ Error installing to WebFOCUS Python: $_"
    exit 1
}

# 2. Install to venv
Write-Host "Step 2: Installing libraries to virtual environment..." -ForegroundColor Yellow
try {
    & $VenvPythonPath -m pip install --quiet -r $RequirementsFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Virtual environment installation completed successfully" -ForegroundColor Green
    } else {
        Write-Error "✗ Virtual environment installation failed"
        exit 1
    }
} catch {
    Write-Error "✗ Error installing to virtual environment: $_"
    exit 1
}

Write-Host ""
Write-Host "Step 3: Verifying installations..." -ForegroundColor Yellow

# Get installed packages from both environments
$webfocusLibs = & $WebFOCUSPythonPath -m pip list --format=freeze 2>$null
$venvLibs = & $VenvPythonPath -m pip list --format=freeze 2>$null

# Extract key libraries from requirements.txt
$requiredLibs = Get-Content $RequirementsFile | Where-Object { $_ -match '^[^#].*==' } | ForEach-Object { $_.Split('==')[0] }

Write-Host ""
Write-Host "Key libraries status:" -ForegroundColor Cyan
Write-Host ("{0,-20} {1,-15} {2,-15}" -f "Library", "WebFOCUS", "venv") -ForegroundColor White
Write-Host ("{0,-20} {1,-15} {2,-15}" -f "-------", "--------", "----") -ForegroundColor Gray

$syncIssues = 0
foreach ($lib in $requiredLibs) {
    $webfocusVersion = ($webfocusLibs | Select-String -Pattern "^$lib==" | ForEach-Object { $_.Line.Split('==')[1] }) -join ''
    $venvVersion = ($venvLibs | Select-String -Pattern "^$lib==" | ForEach-Object { $_.Line.Split('==')[1] }) -join ''

    $webfocusStatus = if ($webfocusVersion) { $webfocusVersion } else { "NOT FOUND" }
    $venvStatus = if ($venvVersion) { $venvVersion } else { "NOT FOUND" }

    $color = "Green"
    if ($webfocusStatus -eq "NOT FOUND" -or $venvStatus -eq "NOT FOUND") {
        $color = "Red"
        $syncIssues++
    } elseif ($webfocusVersion -ne $venvVersion) {
        $color = "Yellow"
        $syncIssues++
    }

    Write-Host ("{0,-20} {1,-15} {2,-15}" -f $lib, $webfocusStatus, $venvStatus) -ForegroundColor $color
}

Write-Host ""
if ($syncIssues -eq 0) {
    Write-Host "🎉 All libraries are properly synchronized!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Run your tests: pytest" -ForegroundColor White
    Write-Host "  2. Test in WebFOCUS environment" -ForegroundColor White
    Write-Host "  3. Restart WebFOCUS server if deploying to production" -ForegroundColor White
} else {
    Write-Host "⚠️  Library synchronization issues detected!" -ForegroundColor Red
    Write-Host "Please check the output above and resolve any 'NOT FOUND' or version mismatches." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=== Sync Complete ===" -ForegroundColor Green
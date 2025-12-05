# WebFOCUS Python Project Restructuring Script
# このスクリプトはプロジェクト構造を再編成します

Write-Host "WebFOCUS Python プロジェクト構造変更を開始します..." -ForegroundColor Green

# 作業ディレクトリ
$projectRoot = "C:\dev\webfocus-python-function"
Set-Location $projectRoot

# 1. 新しいディレクトリ構造を作成
Write-Host "`n[1/6] 新しいディレクトリ構造を作成中..." -ForegroundColor Cyan

$directories = @(
    "src\basic",
    "src\external", 
    "src\advanced",
    "synonyms",
    "samples\basic",
    "samples\external",
    "tests",
    "tools",
    "outputs\logs",
    "outputs\reports",
    "outputs\excel"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $projectRoot $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  作成: $dir" -ForegroundColor Gray
    }
}

# 2. development-guide を docs にリネーム
Write-Host "`n[2/6] development-guide を docs にリネーム中..." -ForegroundColor Cyan
if (Test-Path "development-guide") {
    if (Test-Path "docs") {
        Write-Host "  警告: docs フォルダが既に存在します。スキップします。" -ForegroundColor Yellow
    } else {
        Rename-Item -Path "development-guide" -NewName "docs"
        Write-Host "  完了: development-guide -> docs" -ForegroundColor Gray
    }
}

# 3. Python ファイルを src/ に移動
Write-Host "`n[3/6] Python ファイルを src/ に移動中..." -ForegroundColor Cyan

# src/basic への移動
$basicFiles = @("newfunc.py", "hensachi.py", "sample.py")
foreach ($file in $basicFiles) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "src\basic\" -Force
        Write-Host "  移動: $file -> src\basic\" -ForegroundColor Gray
    }
}

# src/external への移動  
$externalFiles = @("gsearch.py", "xsearch.py")
foreach ($file in $externalFiles) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "src\external\" -Force
        Write-Host "  移動: $file -> src\external\" -ForegroundColor Gray
    }
}

# 4. シノニムファイルを synonyms/ に移動
Write-Host "`n[4/6] シノニムファイルを synonyms/ に移動中..." -ForegroundColor Cyan

$synonymExtensions = @("*.mas", "*.acx", "*.ftm")
foreach ($ext in $synonymExtensions) {
    $files = Get-ChildItem -Path $projectRoot -Filter $ext -File
    foreach ($file in $files) {
        Move-Item -Path $file.FullName -Destination "synonyms\" -Force
        Write-Host "  移動: $($file.Name) -> synonyms\" -ForegroundColor Gray
    }
}

# 5. サンプルCSVファイルを samples/ に移動
Write-Host "`n[5/6] サンプルCSVファイルを samples/ に移動中..." -ForegroundColor Cyan

if (Test-Path "sample_csv") {
    # sample_csv内のファイルを分類して移動
    $csvFiles = Get-ChildItem -Path "sample_csv" -Filter "*.csv"
    
    foreach ($file in $csvFiles) {
        # ファイル名でカテゴリを判定
        if ($file.Name -like "*gsearch*" -or $file.Name -like "*xsearch*") {
            $dest = "samples\external\"
        } else {
            $dest = "samples\basic\"
        }
        
        Move-Item -Path $file.FullName -Destination $dest -Force
        Write-Host "  移動: $($file.Name) -> $dest" -ForegroundColor Gray
    }
    
    # 空のsample_csvフォルダを削除
    Remove-Item -Path "sample_csv" -Force -ErrorAction SilentlyContinue
}

# ルートのtest.csvも移動
if (Test-Path "test.csv") {
    Move-Item -Path "test.csv" -Destination "samples\" -Force
    Write-Host "  移動: test.csv -> samples\" -ForegroundColor Gray
}

# 6. テストファイルを tests/ に移動
Write-Host "`n[6/6] テストファイルを tests/ に移動中..." -ForegroundColor Cyan

$testFiles = @("test_runner.js", "test_runnner.md")
foreach ($file in $testFiles) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "tests\" -Force
        Write-Host "  移動: $file -> tests\" -ForegroundColor Gray
    }
}

# 7. test_csvoutをoutputsにリネーム
if (Test-Path "test_csvout") {
    if (-not (Test-Path "outputs\test_csvout")) {
        Move-Item -Path "test_csvout" -Destination "outputs\" -Force
        Write-Host "  移動: test_csvout -> outputs\" -ForegroundColor Gray
    }
}

# 8. その他のファイル
if (Test-Path "primelog.txt") {
    Move-Item -Path "primelog.txt" -Destination "outputs\logs\" -Force
    Write-Host "  移動: primelog.txt -> outputs\logs\" -ForegroundColor Gray
}

if (Test-Path "trend.png") {
    Move-Item -Path "trend.png" -Destination "outputs\reports\" -Force
    Write-Host "  移動: trend.png -> outputs\reports\" -ForegroundColor Gray
}

Write-Host "`n✓ プロジェクト構造の変更が完了しました！" -ForegroundColor Green
Write-Host "`n新しい構造:" -ForegroundColor Yellow
Write-Host "  - src/         : Python ソースコード"
Write-Host "  - synonyms/    : WebFOCUS シノニム (.mas, .acx)"
Write-Host "  - samples/     : サンプル CSV データ"
Write-Host "  - docs/        : 開発ガイド"
Write-Host "  - tests/       : テストコード"
Write-Host "  - tools/       : 開発ツール"
Write-Host "  - outputs/     : 出力ファイル"

Write-Host "`n次のステップ:" -ForegroundColor Yellow
Write-Host "  1. 各ディレクトリのREADME.mdを作成"
Write-Host "  2. プロジェクトルートのREADME.mdを更新"
Write-Host "  3. 開発ガイドに実例ドキュメントを追加"

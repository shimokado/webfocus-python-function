# tools/ - 開発ツールとスクリプト

このディレクトリには、WebFOCUS Python関数の開発を支援するツールとスクリプトが含まれています。

## 含まれているツール

### 1. `restructure.ps1`
プロジェクト構造を再編成するPowerShellスクリプト

**用途**: プロジェクトのディレクトリ構造を最適化

**実行方法**:
```powershell
powershell -ExecutionPolicy Bypass -File tools\restructure.ps1
```

### 2. `install_mecab.sh`
MeCab（形態素解析ツール）のインストールスクリプト

**用途**: 日本語テキスト解析ライブラリのインストール

**実行方法**:
```bash
bash tools/install_mecab.sh
```

### 3. `mecab-ipadic-neologd.tar.gz`
MeCab用の辞書ファイル

## 推奨開発ツール

### Python環境管理

#### 仮想環境の作成

```powershell
# venv を使用
python -m venv webfocus-env
.\webfocus-env\Scripts\Activate.ps1

# または conda を使用
conda create -n webfocus-py36 python=3.6
conda activate webfocus-py36
```

#### 必須パッケージのインストール

```powershell
# 基本パッケージ
pip install numpy scipy scikit-learn pandas

# 追加パッケージ（必要に応じて）
pip install requests beautif ulsoup4 lxml
```

### WebFOCUSライブラリインストールスクリプト

以下のPowerShellスクリプトを作成すると便利です:

**`tools/install_packages.ps1`**:
```powershell
# WebFOCUS Python環境へのパッケージインストール
$pythonExe = "C:\ibi\srv93\home\etc\python\python.exe"
$targetDir = "C:\ibi\srv93\home\etc\python\lib\site-packages"

# パッケージリスト
$packages = @(
    "requests",
    "beautif ulsoup4",
    "lxml",
    "python-dateutil"
)

foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Cyan
    & $pythonExe -m pip install --target=$targetDir $package
}

Write-Host "All packages installed!" -ForegroundColor Green
```

**実行方法**:
```powershell
powershell -ExecutionPolicy Bypass -File tools\install_packages.ps1
```

### デプロイスクリプト

**`tools/deploy_to_webfocus.ps1`**:
```powershell
# WebFOCUSサーバへのデプロイスクリプト
param(
    [string]$TargetPath = "C:\ibi\srv93\ibi_apps\python"
)

Write-Host "Deploying to WebFOCUS..." -ForegroundColor Green

# Pythonファイルをコピー
Write-Host "Copying Python files..." -ForegroundColor Cyan
Copy-Item -Path "src\basic\*.py" -Destination "$TargetPath\" -Force
Copy-Item -Path "src\external\*.py" -Destination "$TargetPath\" -Force

# シノニムファイルをコピー
Write-Host "Copying synonym files..." -ForegroundColor Cyan
Copy-Item -Path "synonyms\*.mas" -Destination "$TargetPath\" -Force
Copy-Item -Path "synonyms\*.acx" -Destination "$TargetPath\" -Force
Copy-Item -Path "synonyms\*.ftm" -Destination "$TargetPath\" -Force

# サンプルファイルをコピー（オプション）
Write-Host "Copying sample files..." -ForegroundColor Cyan
Copy-Item -Path "samples\*.csv" -Destination "$TargetPath\" -Force -Recurse

Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Please restart WebFOCUS Reporting Server to apply changes."
```

**実行方法**:
```powershell
.\tools\deploy_to_webfocus.ps1
# またはカスタムパスを指定
.\tools\deploy_to_webfocus.ps1 -TargetPath "D:\custom\path"
```

## 開発ワークフロー

### 1. ローカル開発

```mermaid
graph LR
    A[Python関数作成] --> B[ローカルテスト]
    B --> C[サンプルCSV作成]
    C --> D[動作確認]
```

```powershell
# 1. 関数作成
code src/basic/new_function.py

# 2. テスト
python -c "from src.basic.new_function import my_func; my_func('samples/test.csv', 'outputs/result.csv')"

# 3. 結果確認
Get-Content outputs/result.csv
```

### 2. WebFOCUSデプロイ

```powershell
# デプロイスクリプト実行
.\tools\deploy_to_webfocus.ps1

# WebFOCUS Reporting Server再起動
Restart-Service -Name "WebFOCUS Reporting Server"
```

### 3. シノニム作成

WebFOCUS管理コンソールで:
1. PYTHON アダプタ → Create metadata objects
2. 必要な情報を入力
3. シノニム生成

### 4. 動作確認

```focexec
TABLE FILE DATASOURCE
COMPUTE RESULT/I9 = PYTHON(python/my_function, INPUT1, INPUT2, output);
END
```

## 便利なコマンド集

### プロジェクト構造の確認

```powershell
# ツリー表示
tree /F /A

# またはPowerShellで
Get-ChildItem -Recurse | Select-Object FullName
```

### ファイル検索

```powershell
# Python関数をすべて検索
Get-ChildItem -Recurse -Filter "*.py"

# シノニムをすべて検索
Get-ChildItem -Recurse -Filter "*.mas", "*.acx"
```

### ログの確認

```powershell
# 最新のエラーログ
Get-Content outputs\logs\*.log | Select-Object -Last 50
```

## 開発環境のセットアップ

### IDE推奨設定

#### VS Code

**`.vscode/settings.json`**:
```json
{
  "python.defaultInterpreterPath": "C:\\ibi\\srv93\\home\\etc\\python\\python.exe",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "files.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true
  }
}
```

#### PyCharm

- Python Interpreter: WebFOCUS同梱Python (`C:\ibi\srv93\home\etc\python\python.exe`)
- Project Structure: `src/`をソースルートに設定

## トラブルシューティング

### パッケージインストールエラー

```powershell
# pip をアップグレード
C:\ibi\srv93\home\etc\python\python.exe -m pip install --upgrade pip

# 特定バージョンをインストール
C:\ibi\srv93\home\etc\python\python.exe -m pip install package==version
```

### デプロイエラー

**問題**: ファイルがコピーできない

**解決策**: 
- 管理者権限でPowerShellを実行
- WebFOCUSサービスを停止してからコピー

## 参考資料

- [環境構築](/docs/02_environment_setup.md)
- [ライブラリ管理](/docs/05_library_management.md)
- [トラブルシューティング](/docs/07_troubleshooting.md)

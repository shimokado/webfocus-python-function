# ライブラリ同期ガイド

WebFOCUS Python関数開発におけるライブラリ管理のベストプラクティスを説明します。特に、開発環境とWebFOCUSサーバー環境間のライブラリ同期を確実に実行するための方法を重点的に解説します。

## 概要

### 問題の背景

WebFOCUS Python関数開発では、以下の2つのPython環境で同じライブラリを使用する必要があります：

1. **開発環境 (venv)**: ローカルでのテスト実行
2. **WebFOCUSサーバー環境**: 本番実行

ライブラリ追加時に**サーバー環境へのインストールを忘れる**ことが多く、以下のような問題が発生します：

- ローカルテストは成功するが、本番環境で`ModuleNotFoundError`が発生
- デプロイ時の手順漏れによるトラブル
- 環境差異による動作不一致

### 解決の基本原則

> [!IMPORTANT]
> **ライブラリ追加時は必ず両環境にインストールし、同期を維持する**

## ベストプラクティス

### 1. requirements.txtによる一元管理

プロジェクトの全ライブラリを`requirements.txt`で管理します。

#### ファイル構成例

```text
# requirements.txt
# WebFOCUS標準ライブラリ
pandas>=1.5.0
numpy>=1.21.0
scipy>=1.7.0
scikit-learn>=1.0.0

# プロジェクト固有ライブラリ
requests>=2.28.0
beautifulsoup4>=4.11.0
openpyxl>=3.0.0
```

#### 更新手順

1. 新しいライブラリが必要になったら、まず`requirements.txt`に追加
2. 両環境に一括インストール
3. 動作確認

### 2. インストールスクリプトの活用

手動インストールのミスを防ぐため、PowerShellスクリプトを使用します。

#### sync_libraries.ps1 の作成

プロジェクトルートに以下のスクリプトを作成：

```powershell
# sync_libraries.ps1
param(
    [string]$WebFOCUSPythonPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python39\python.exe",
    [string]$VenvPythonPath = ".\venv\Scripts\python.exe"
)

Write-Host "=== WebFOCUS Python Library Sync ===" -ForegroundColor Green

# 1. WebFOCUS用Pythonにインストール
Write-Host "Installing to WebFOCUS Python..." -ForegroundColor Yellow
& $WebFOCUSPythonPath -m pip install -r requirements.txt

# 2. venv環境にインストール
Write-Host "Installing to venv..." -ForegroundColor Yellow
& $VenvPythonPath -m pip install -r requirements.txt

# 3. インストール確認
Write-Host "Verifying installations..." -ForegroundColor Yellow
$webfocusLibs = & $WebFOCUSPythonPath -m pip list --format=freeze
$venvLibs = & $VenvPythonPath -m pip list --format=freeze

Write-Host "WebFOCUS Python packages:" -ForegroundColor Cyan
$webfocusLibs | Select-String -Pattern "^(pandas|numpy|scipy|scikit-learn|requests|beautifulsoup4|openpyxl)="

Write-Host "venv packages:" -ForegroundColor Cyan
$venvLibs | Select-String -Pattern "^(pandas|numpy|scipy|scikit-learn|requests|beautifulsoup4|openpyxl)="

Write-Host "Sync completed!" -ForegroundColor Green
```

#### 使用方法

```powershell
# 基本使用
.\sync_libraries.ps1

# パスを指定する場合
.\sync_libraries.ps1 -WebFOCUSPythonPath "C:\ibi\srv90\home\etc\python\python.exe"
```

### 3. 環境変数によるパス管理

WebFOCUS Pythonのパスを環境変数で管理すると、チーム開発で便利です。

#### 環境変数の設定

```powershell
# システム環境変数に設定（管理者権限）
[System.Environment]::SetEnvironmentVariable('WEBFOCUS_PYTHON_PATH', 'C:\Users\shimokado\AppData\Local\Programs\Python\Python39\python.exe', 'Machine')

# 確認
$env:WEBFOCUS_PYTHON_PATH
```

#### スクリプトでの活用

```powershell
# sync_libraries.ps1
$WebFOCUSPythonPath = $env:WEBFOCUS_PYTHON_PATH
if (-not $WebFOCUSPythonPath) {
    Write-Warning "WEBFOCUS_PYTHON_PATH environment variable not set. Using default path."
    $WebFOCUSPythonPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python39\python.exe"
}
```

### 4. CI/CDパイプラインの活用（推奨）

GitHub Actionsなどで自動化する場合：

```yaml
# .github/workflows/sync-libs.yml
name: Sync Libraries
on:
  push:
    paths:
      - 'requirements.txt'

jobs:
  sync:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'
      
      - name: Install to venv
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      
      - name: Verify installation
        run: |
          python -c "import pandas, numpy, scipy, sklearn; print('All libraries imported successfully')"
```

## チェックリスト

### ライブラリ追加時の必須チェック

ライブラリを追加するたびに以下の項目を確認してください：

#### □ requirements.txtに追加
- [ ] 新しいライブラリを`requirements.txt`に記載
- [ ] バージョン指定を適切に設定（`>=2.28.0`推奨）

#### □ 開発環境（venv）へのインストール
- [ ] venv環境が有効化されていることを確認
- [ ] `pip install -r requirements.txt`を実行
- [ ] インストール成功を確認（`pip list`）

#### □ WebFOCUSサーバー環境へのインストール
- [ ] WebFOCUS用Pythonのパスを確認
- [ ] WebFOCUS用Pythonで`pip install -r requirements.txt`を実行
- [ ] インストール成功を確認

#### □ 動作確認
- [ ] ローカルテスト（pytest）で成功
- [ ] WebFOCUSからの実行で成功
- [ ] エラーログにライブラリ関連のエラーがない

#### □ ドキュメント更新
- [ ] 変更履歴にライブラリ追加を記載
- [ ] チームメンバーに共有

### 定期メンテナンスチェック

毎週またはデプロイ前に確認：

- [ ] 両環境のライブラリバージョンが一致している
- [ ] requirements.txtが最新である
- [ ] 不要なライブラリがない

## トラブルシューティング

### よくある問題と解決

#### 1. 「ModuleNotFoundError」 in WebFOCUS

**症状:** ローカルテストは成功するが、WebFOCUSでライブラリが見つからない

**解決:**
```powershell
# WebFOCUS用Pythonにインストールされているか確認
C:\Users\shimokado\AppData\Local\Programs\Python\Python39\python.exe -m pip list

# インストール
C:\Users\shimokado\AppData\Local\Programs\Python\Python39\python.exe -m pip install -r requirements.txt

# WebFOCUSサーバー再起動
Restart-Service -Name "WebFOCUS 93 Server"
```

#### 2. パス設定ミス

**症状:** スクリプト実行時に「Pythonが見つからない」

**解決:**
```powershell
# パスを確認
Get-Command python  # デフォルトPython
& "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python39\python.exe" --version  # WebFOCUS用

# 環境変数設定
[System.Environment]::SetEnvironmentVariable('WEBFOCUS_PYTHON_PATH', 'C:\Users\shimokado\AppData\Local\Programs\Python\Python39\python.exe', 'User')
```

#### 3. バージョン不一致

**症状:** 両環境で同じライブラリバージョンがインストールされていない

**解決:**
```powershell
# 両環境のライブラリ一覧を比較
C:\Users\shimokado\AppData\Local\Programs\Python\Python39\python.exe -m pip freeze > webfocus_libs.txt
.\venv\Scripts\python.exe -m pip freeze > venv_libs.txt

# 差分を確認
Compare-Object (Get-Content webfocus_libs.txt) (Get-Content venv_libs.txt)
```

## 関連ドキュメント

- [ライブラリ管理](05_library_management.md): 基本的なライブラリインストール手順
- [Pythonアダプタ設定](09_python_adapter_configuration.md): 環境構築の詳細
- [トラブルシューティング](10_troubleshooting.md): 問題解決のヒント

---

**ライブラリ同期を徹底することで、デプロイ時のトラブルを大幅に削減できます。**</content>
<parameter name="filePath">c:\dev\webfocus-python-function\docs\13_library_sync_guide.md
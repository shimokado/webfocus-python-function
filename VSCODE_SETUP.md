# VS Code 設定ガイド

このドキュメントは、VS Code/AntigravityでPythonテスト機能を有効にするための設定手順を説明します。

## 1. VS Code設定ファイルの作成

プロジェクトルートに`.vscode`フォルダを作成し、その中に`settings.json`を配置してください。

### 手順

```powershell
# プロジェクトルートで実行
mkdir .vscode -Force
```

### .vscode/settings.json の内容

以下の内容で`.vscode/settings.json`を作成してください:

```json
{
  "python.testing.pytestEnabled": true,
  "python.testing.unittestEnabled": false,
  "python.testing.pytestArgs": [
    "tests"
  ],
  "python.defaultInterpreterPath": "${workspaceFolder}\\venv\\Scripts\\python.exe",
  "python.venvPath": "${workspaceFolder}",
  "python.terminal.activateEnvironment": true
}
```

### 設定の説明

| 設定項目 | 値 | 説明 |
|---------|-----|------|
| `python.testing.pytestEnabled` | `true` | pytestを有効化 |
| `python.testing.unittestEnabled` | `false` | unittestを無効化（pytestのみ使用） |
| `python.testing.pytestArgs` | `["tests"]` | テストディレクトリを指定 |
| `python.defaultInterpreterPath` | `${workspaceFolder}\\venv\\Scripts\\python.exe` | venv環境のPythonを使用 |
| `python.venvPath` | `${workspaceFolder}` | venvの場所を指定 |
| `python.terminal.activateEnvironment` | `true` | ターミナル起動時に自動的にvenvを有効化 |

## 2. VS Codeでのテスト実行

設定完了後、以下の方法でテストが実行できます:

### 方法1: Testing アイコンから実行

1. VS CodeのサイドバーにあるTestingアイコン（フラスコマーク）をクリック
2. テスト一覧が表示されます
3. 実行したいテストをクリックして実行

### 方法2: コマンドパレットから実行

1. `Ctrl+Shift+P` でコマンドパレットを開く
2. "Python: Run All Tests" を選択

### 方法3: コードエディタから実行

1. テストファイル（`tests/test_newfunc.py`など）を開く
2. テスト関数の上に表示される「Run Test」リンクをクリック

## 3. トラブルシューティング

### テストが表示されない場合

1. **venv環境が有効化されているか確認**
   ```powershell
   .\venv\Scripts\Activate.ps1
   ```

2. **pytestがインストールされているか確認**
   ```powershell
   .\venv\Scripts\python.exe -m pip list | findstr pytest
   ```
   
   インストールされていない場合:
   ```powershell
   npm run install:venv
   ```

3. **VS Codeを再起動**
   設定変更後はVS Codeの再起動が必要な場合があります

4. **Python拡張機能のインストール確認**
   VS Codeの拡張機能タブで「Python」がインストールされているか確認

### Pythonインタープリタの選択

1. コマンドパレット（`Ctrl+Shift+P`）を開く
2. "Python: Select Interpreter" を入力
3. `.\venv\Scripts\python.exe` を選択

## 4. 補足: .gitignoreとの関係

`.vscode/settings.json`は通常、個人の開発環境設定なので`.gitignore`に含めることが推奨されます。

しかし、このプロジェクトでは標準設定として共有したい場合もあります。

- **個人用設定として管理する場合**: `.gitignore`に`.vscode/`を追加
- **チーム標準設定として管理する場合**: `.vscode/settings.json`をgit管理下に置く

## 5. 参考: VS Code以外でのテスト実行

VS Codeを使用しない場合は、以下のnpmコマンドでテストを実行できます:

```powershell
# 通常のテスト実行
npm test

# 詳細出力付き
npm run test:verbose

# カバレッジレポート付き
npm run test:coverage
```

または直接pytestを実行:

```powershell
.\venv\Scripts\Activate.ps1
pytest
```

# 環境構築

WebFOCUS Python関数を利用するための環境構築手順を説明します。

## 前提条件

### システム要件

- **WebFOCUS Reporting Server**: 同一マシン上にインストール済み
- **Python**: 3.6.x（WebFOCUS Reporting Serverと同じビットサイズ: 32-bitまたは64-bit）  
- **プラットフォーム**: Windows、UNIX、Linux

> [!IMPORTANT]
> WebFOCUSで利用できるPythonバージョンは**3.6.x**に限定されています。他のバージョンとの互換性は保証されません。

### 必須パッケージ

以下のパッケージを**この順序で**インストールする必要があります:

1. `numpy`
2. `scipy` (numpyに依存)
3. `scikit-learn` (numpy、scipyに依存、追加パッケージも自動インストール)
4. `pandas`

## Python環境のセットアップ

### オプション1: WebFOCUS同梱のPythonを使用（推奨）

WebFOCUSサーバには通常、互換性のあるPythonが同梱されています。

**標準インストールパス** (Windows):
```
C:\ibi\srv90\home\etc\python\
```

> [!TIP]
> 同梱版のPythonを使用することで、バージョン互換性の問題を回避できます。

### オプション2: 独自にPythonをインストール

1. **Python 3.6.xをダウンロード**
   - [Python公式サイト](https://www.python.org/downloads/)から3.6.xをダウンロード
   - インストール時に**pipオプションを必ず選択**

2. **必須パッケージのインストール**

```powershell
# 順番に実行
python -m pip install numpy
python -m pip install scipy
python -m pip install scikit-learn
python -m pip install pandas
```

3. **環境変数の設定**
   - システム変数は前提条件ページで確認
   - WebFOCUS管理コンソールから設定可能

## WebFOCUS Pythonアダプタの設定

### 手順1: アダプタの追加

1. **WebFOCUS Reporting Server Web Console**にアクセス
2. サイドバーの**「Connect to Data」**をクリック
3. メニューバーの**「New Datasource」**をクリック
4. **「Statistics」**カテゴリから**「PYTHON」**を右クリック

### 手順2: Pythonインストールディレクトリの指定

「Add PYTHON to Configuration」ページで以下を入力:

**Pythonインストールディレクトリ**:
```
C:\ibi\srv90\home\etc\python
```

> [!NOTE]
> パスは環境に応じて変更してください。独自にインストールした場合は、そのインストールパスを指定します。

### 手順3: テストと設定完了

1. **「Test」**ボタンをクリック
2. 成功メッセージを確認:
   ```
   Successful test for the Python environment
   ```
3. **「Configure」**ボタンをクリック
4. PYTHONアダプタが「Configured Adapters」リストに追加される

### 手順4: WebFOCUS Reporting Server再起動

```powershell
# サービスの再起動（管理者権限が必要）
Restart-Service -Name "WebFOCUS Reporting Server"
```

> [!CAUTION]
> アダプタ設定後は必ずWebFOCUS Reporting Serverを再起動してください。再起動しないと設定が反映されません。

## ローカル開発環境の構築（推奨）

WebFOCUSのPython環境を直接操作するのではなく、ローカルで仮想環境（venv）を作成して開発・テストを行うことを強く推奨します。これにより、システムのPython環境を汚さず、プロジェクトごとに依存関係を管理できます。

### なぜ仮想環境を使うのか？

1. **環境の分離**: WebFOCUSサーバの環境と開発環境を分離し、予期せぬ競合を防ぎます。
2. **依存関係の管理**: プロジェクトに必要なライブラリのみをインストールできます。
3. **安全なテスト**: 開発中のコードがシステム全体に影響を与えるリスクを最小限に抑えます。

### 方法1: venv（標準ライブラリ） - 推奨

```powershell
# Python 3.6.xのパスを指定
$python36 = "C:\ibi\srv90\home\etc\python\python.exe"

# 仮想環境の作成
& $python36 -m venv webfocus-env

# 仮想環境のアクティベート
.\webfocus-env\Scripts\Activate.ps1

# 必須パッケージのインストール
python -m pip install --upgrade pip
python -m pip install numpy scipy scikit-learn pandas
```

### 方法2: conda（推奨）

```powershell
# Python 3.6環境の作成
conda create -n webfocus-py36 python=3.6

# 環境のアクティベート
conda activate webfocus-py36

# 必須パッケージのインストール
conda install numpy scipy scikit-learn pandas
```

## インストール済みパッケージの確認

### WebFOCUS管理コンソールから確認

1. PYTHONアダプタを右クリック
2. **「Test」**を選択
3. **「Python Package List」**で一覧を確認

> [!NOTE]
> パッケージリストが反映されない場合は、WebFOCUS Reporting Serverを再起動してください。

### コマンドラインから確認

```powershell
# WebFOCUS同梱のPythonを使用
C:\ibi\srv90\home\etc\python\python.exe -m pip list
```

## ディレクトリ構成例

WebFOCUS Python関数開発のための推奨ディレクトリ構成:

```
C:\ibi\srv90\ibi_apps\
├── python\                    # Pythonアプリケーション用フォルダ
│   ├── scripts\              # Python関数スクリプト
│   │   ├── calculator.py
│   │   ├── data_analysis.py
│   │   └── web_scraper.py
│   ├── samples\              # サンプルCSVデータ
│   │   ├── calc_sample.csv
│   │   └── data_sample.csv
│   └── synonyms\             # シノニム（MAS/ACXファイル）
│       ├── calculator.mas
│       ├── calculator.acx
│       └── ...
```

## トラブルシューティング

### Python環境が認識されない

**症状**: テスト時にエラーが発生
**解決策**:
- Pythonパスが正しいか確認
- Python 3.6.xがインストールされているか確認
- 32-bit/64-bitがWebFOCUSサーバと一致しているか確認

### パッケージが見つからない

**症状**: 関数実行時に`ModuleNotFoundError`
**解決策**:
- WebFOCUS同梱のPythonにパッケージをインストール
- インストールパスはWebFOCUSが参照する場所を指定

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages <package_name>
```

### サーバ再起動後も設定が反映されない

**解決策**:
- アダプタ設定を再確認
- WebFOCUSサービスが完全に再起動されたか確認
- ログファイルでエラーを確認

## 次のステップ

環境構築が完了したら:
- **[開発ガイドライン](03_development_guidelines.md)**で関数の書き方を学習
- **[シノニム作成](04_synonym_creation.md)**でメタデータの作成方法を確認

# ライブラリ管理

WebFOCUS Python関数で使用できるライブラリの確認方法、追加ライブラリのインストール手順、注意点を説明します。

## デフォルトでインストールされるライブラリ

WebFOCUS Pythonアダプタの前提条件として、以下のライブラリがインストールされています:

### 必須パッケージ

1. **numpy** - 数値計算ライブラリ
2. **scipy** - 科学技術計算ライブラリ（numpyに依存）
3. **scikit-learn** - 機械学習ライブラリ（numpy、scipyに依存）
4. **pandas** - データ分析ライブラリ

### 自動的に含まれるパッケージ

scikit-learnのインストール時に、以下のような関連パッケージも自動的にインストールされます:

- joblib
- threadpoolctl
- その他の依存パッケージ

## インストール済みパッケージの確認

### 方法1: WebFOCUS管理コンソールから確認

1. **WebFOCUS Reporting Server Web Console**にアクセス
2. **「Connect to Data」**ページへ移動
3. **「PYTHON」**アダプタを右クリック
4. **「Test」**を選択
5. **「Python Package List」**でインストール済みパッケージとバージョンを確認

> [!NOTE]
> パッケージリストが反映されない場合は、WebFOCUS Reporting Serverを再起動してください。

### 方法2: コマンドラインから確認

```powershell
# WebFOCUS同梱のPythonを使用
C:\ibi\srv90\home\etc\python\python.exe -m pip list
```

**出力例:**
```
Package         Version
--------------- -------
numpy           1.19.5
pandas          1.1.5
pip             21.3.1
scikit-learn    0.24.2
scipy           1.5.4
```

## 追加ライブラリのインストール

### 重要な注意事項

> [!CAUTION]
> WebFOCUS Pythonアダプタで追加ライブラリをインストールする場合、以下の点に注意してください:
> 
> 1. **WebFOCUS同梱のPython**を使用してインストール
> 2. **インストール先**をWebFOCUSのsite-packagesディレクトリに指定
> 3. **Python 3.6.x対応**のバージョンを選択

### インストールコマンド

```powershell
# 基本構文
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages <package_name>
```

**パラメータ説明:**
- `C:\ibi\srv90\home\etc\python\python.exe`: WebFOCUS同梱のPython実行ファイル
- `--target=...`: インストール先ディレクトリ（WebFOCUSのsite-packages）
- `<package_name>`: インストールするパッケージ名

> [!IMPORTANT]
> `--target`オプションを指定しないと、システムのPythonディレクトリにインストールされ、WebFOCUSから参照できません。

### インストール例

#### 例1: requests（HTTPライブラリ）

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages requests
```

#### 例2: beautifulsoup4（Webスクレイピング）

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages beautifulsoup4
```

#### 例3: lxml（XML/HTML解析）

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages lxml
```

### バージョン指定インストール

特定のバージョンをインストールする場合:

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages requests==2.27.1
```

### インストール後の確認

1. **パッケージリストで確認**:
   ```powershell
   C:\ibi\srv90\home\etc\python\python.exe -m pip list
   ```

2. **WebFOCUS管理コンソールで確認**:
   - PYTHONアダプタ → Test → Python Package List

3. **WebFOCUS Reporting Serverを再起動**:
   ```powershell
   Restart-Service -Name "WebFOCUS Reporting Server"
   ```

> [!WARNING]
> パッケージをインストールした後は、必ずWebFOCUS Reporting Serverを再起動してください。

## よく使われる追加ライブラリ

### Webスクレイピング

```powershell
# requests - HTTP通信
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages requests

# beautifulsoup4 - HTML解析
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages beautifulsoup4
```

**使用例:**
```python
import csv
import requests
from bs4 import BeautifulSoup

def scrape_data(csvin, csvout):
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['title']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            url = row['url']
            response = requests.get(url)
            soup = BeautifulSoup(response.content, 'html.parser')
            title = soup.find('title').text
            writer.writerow({'title': title})
```

### データ可視化

```powershell
# matplotlib - グラフ作成
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages matplotlib
```

### データベース接続

```powershell
# psycopg2 - PostgreSQL
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages psycopg2-binary

# pymysql - MySQL
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages pymysql
```

### 日付・時刻処理

```powershell
# python-dateutil - 日付解析
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages python-dateutil
```

## ライブラリインストールのベストプラクティス

### 1. バージョン互換性の確認

Python 3.6.x対応のバージョンを選択します。

```powershell
# パッケージの利用可能なバージョンを確認
C:\ibi\srv90\home\etc\python\python.exe -m pip index versions <package_name>
```

### 2. 依存関係の管理

依存パッケージも自動的にインストールされますが、`--target`オプションで指定したディレクトリに配置されます。

### 3. requirements.txtの使用

複数のパッケージを一括インストール:

**requirements.txt**
```
requests==2.27.1
beautifulsoup4==4.11.1
lxml==4.9.0
```

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages -r requirements.txt
```

### 4. テスト環境での検証

本番環境にインストールする前に、開発環境でテストします。

```powershell
# 仮想環境でテスト
python -m venv test-env
.\test-env\Scripts\Activate.ps1
pip install <package_name>

# 関数のテスト実行
python test_script.py
```

## ライブラリのアンインストール

```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip uninstall <package_name>
```

> [!WARNING]
> 必須パッケージ（numpy、scipy、scikit-learn、pandas）はアンインストールしないでください。

## トラブルシューティング

### モジュールが見つからない

**症状**: `ModuleNotFoundError: No module named 'xxx'`

**解決策:**
1. パッケージがインストールされているか確認
   ```powershell
   C:\ibi\srv90\home\etc\python\python.exe -m pip list | findstr xxx
   ```
2. `--target`オプションで正しいディレクトリを指定したか確認
3. WebFOCUS Reporting Serverを再起動

### バージョン互換性エラー

**症状**: パッケージのインストールは成功するが、実行時にエラー

**解決策:**
- Python 3.6.x対応のバージョンを明示的に指定
- パッケージの公式ドキュメントでPython 3.6サポート状況を確認

### 依存関係のエラー

**症状**: `ERROR: Could not find a version that satisfies the requirement`

**解決策:**
- 依存パッケージを先にインストール
- pipをアップグレード
  ```powershell
  C:\ibi\srv90\home\etc\python\python.exe -m pip install --upgrade pip
  ```

### パッケージリストに表示されない

**解決策:**
1. WebFOCUS Reporting Serverを再起動
2. 管理コンソールをリフレッシュ（ブラウザの更新）

## 推奨ライブラリ一覧

| カテゴリ | ライブラリ | 用途 |
|---------|----------|------|
| HTTP通信 | requests | API呼び出し、Webスクレイピング |
| HTML/XML解析 | beautifulsoup4, lxml | Webスクレイピング |
| 日付・時刻 | python-dateutil | 日付解析と計算 |
| JSON処理 | - | 標準ライブラリで対応 |
| CSV処理 | - | 標準ライブラリで対応 |
| データベース | psycopg2-binary, pymysql | DB接続 |
| 正規表現 | - | 標準ライブラリで対応 |

> [!TIP]
> 標準ライブラリで対応できる機能は、追加インストール不要です。

## 次のステップ

- **[サンプルコード](06_code_samples.md)**: ライブラリを活用した実用例を参照
- **[トラブルシューティング](07_troubleshooting.md)**: よくある問題と解決方法

# Python関数テストガイド

このガイドでは、WebFOCUSで使用するPython関数のテスト方法について、ベストプラクティスとサンプルコードを交えて解説します。

## 1. なぜテストが必要なのか？

Python関数をWebFOCUSに組み込む前に、ローカル環境で十分にテストを行うことが重要です。
- **開発効率の向上**: WebFOCUSにアップロードして確認する手間を省けます。
- **品質の担保**: 様々な入力パターンを網羅的にテストすることで、バグを未然に防ぎます。
- **リファクタリングの安心感**: コードを変更しても、テストが通れば機能が壊れていないことを保証できます。

## 2. テストフレームワーク: pytest

本プロジェクトでは、Pythonの標準的なテストフレームワークである`pytest`を使用します。
`pytest`はシンプルに書けて、高度な機能も備えているため、初心者から上級者まで幅広く使われています。

### セットアップ

`requirements.txt`に`pytest`が含まれているため、以下のコマンドでインストールできます。

```powershell
pip install -r requirements.txt
```

## 3. サンプルコード解説 (`tests/test_newfunc.py`)

`tests/test_newfunc.py`に含まれるテストコードを例に、具体的な書き方を解説します。

### 基本構造

```python
import sys
import os
import csv
import pytest

# テスト対象のモジュールをインポートできるようにパスを追加
sys.path.append(os.path.join(os.path.dirname(__file__), '../src/basic'))
import newfunc

class TestNewFunc:
    # ... テストメソッド ...
```

### フィクスチャ (Fixture) の活用

テストに必要な準備（セットアップ）と後始末（ティアダウン）を共通化する機能です。
ここでは、一時的な入出力ファイルを作成するために使用しています。

```python
    @pytest.fixture
    def setup_files(self, tmp_path):
        """テスト用の入出力ファイルを準備するフィクスチャ"""
        # tmp_pathはpytestが提供する、テストごとの一時ディレクトリ
        input_file = tmp_path / "test_input.csv"
        output_file = tmp_path / "test_output.csv"
        
        # テストデータの作成
        with open(input_file, 'w', newline='') as f:
            # ... データ書き込み ...
            
        return str(input_file), str(output_file)
```

- **`tmp_path`**: `pytest`が自動的に提供するフィクスチャで、テスト関数ごとに独立した一時ディレクトリを作成します。テスト終了後に自動的に削除されるため、ファイルの後始末を気にする必要がありません。

### 基本的なテストケース

```python
    def test_kakezan(self, setup_files):
        """kakezan関数のテスト"""
        input_file, output_file = setup_files
        
        # 関数を実行
        newfunc.kakezan(input_file, output_file)
        
        # 検証 (Assert)
        assert os.path.exists(output_file)
        # ... 内容の検証 ...
```

- **`assert`**: Pythonの標準的なアサーションです。条件が`True`であればテスト成功、`False`であれば失敗となります。

### パラメータ化テスト (Parametrized Test)

同じロジックで、異なる入力値と期待される出力値の組み合わせをテストしたい場合に便利です。
コードを重複させずに、複数のパターンを効率的にテストできます。

```python
    @pytest.mark.parametrize("col1, col2, expected", [
        (10, 2, 20),       # 通常のケース
        (5, 3, 15),        # 通常のケース
        (100, 0.5, 50),    # 小数のケース
        (0, 10, 0),        # 0を含むケース
        (-5, 2, -10),      # 負の数を含むケース
    ])
    def test_kakezan_parametrize(self, tmp_path, col1, col2, expected):
        # ... テストロジック ...
```

- **`@pytest.mark.parametrize`**: 引数名と値のリストを指定します。この例では、5つのパターンがそれぞれ独立したテストとして実行されます。

## 4. ベストプラクティス

1.  **テストファイルとソースコードの分離**:
    - ソースコードは`src/`、テストコードは`tests/`に配置します。
    - テストファイル名は`test_`で始めます（例: `test_newfunc.py`）。

2.  **独立性の確保**:
    - 各テストは他のテストに依存せず、単独で実行できるようにします。
    - `tmp_path`などを使って、ファイルシステムの状態をテストごとにクリーンに保ちます。

3.  **境界値テスト**:
    - 正常系だけでなく、境界値（0, 負の数, 空文字など）や異常系（ファイルが存在しないなど）もテストします。

4.  **わかりやすいテスト名**:
    - 何をテストしているのかがひと目でわかる関数名にします（例: `test_kakezan_empty_file`）。

## 5. テストの実行

プロジェクトのルートディレクトリで以下のコマンドを実行します。

```powershell
pytest
```

特定のファイルのみ実行する場合:

```powershell
pytest tests/test_newfunc.py
```

詳細な出力を表示する場合:

```powershell
pytest -v
```

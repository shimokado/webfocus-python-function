# tests/ - テストコード

このディレクトリにはPython関数のテストコードとテスト実行ツールが含まれています。

## テストの目的

1. **関数の動作確認** - ローカル環境でPython関数が正しく動作するか検証
2. **リグレッション防止** - コード変更時の既存機能の破壊を防ぐ
3. **エッジケース検証** - 境界値やエラーケースの動作確認

## 含まれているファイル

- **`test_runner.js`** - Node.jsベースのテストランナー
- **`test_runner.md`** - テスト実行方法のドキュメント

## テスト実行方法

### Node.jsテストランナー

```powershell
# package.jsonのスクリプトを使用
npm test

# または直接実行
node tests/test_runner.js
```

### 手動テスト

```powershell
# 各Python関数を直接実行
python src/basic/newfunc.py

# カスタム入出力ファイルで実行
python -c "from src.basic.newfunc import kakezan; kakezan('samples/sample.csv', 'outputs/test_result.csv')"
```

## テストケースの作成

### 基本的なテストパターン

```python
# test_newfunc.py
import unittest
import csv
import os
from src.basic.newfunc import kakezan

class TestKakezan(unittest.TestCase):
    
    def setUp(self):
        """テスト前の準備"""
        self.test_input = 'test_input.csv'
        self.test_output = 'test_output.csv'
        
        # テスト用入力データ作成
        with open(self.test_input, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=['col1', 'col2'],
                                   quoting=csv.QUOTE_NONNUMERIC)
            writer.writeheader()
            writer.writerow({'col1': 2, 'col2': 3})
            writer.writerow({'col1': 10, 'col2': 5})
    
    def test_multiplication(self):
        """乗算が正しく動作するか"""
        kakezan(self.test_input, self.test_output)
        
        # 結果を検証
        with open(self.test_output, 'r', newline='') as f:
            reader = csv.DictReader(f, quoting=csv.QUOTE_NONNUMERIC)
            rows = list(reader)
            
            self.assertEqual(rows[0]['seki'], 6)  # 2 * 3
            self.assertEqual(rows[1]['seki'], 50) # 10 * 5
    
    def tearDown(self):
        """テスト後のクリーンアップ"""
        os.remove(self.test_input)
        os.remove(self.test_output)

if __name__ == '__main__':
    unittest.main()
```

## テスト結果の確認

### 出力ファイルの検証

```powershell
# CSVの内容確認
Get-Content outputs/test_result.csv
```

## CI/CD統合

### GitHub Actionsの例

```yaml
name: Test Python Functions

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.6'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install numpy scipy scikit-learn pandas requests
      - name: Run tests
        run: |
          npm test
```

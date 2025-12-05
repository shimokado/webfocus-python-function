# src/ - Pythonソースコード

このディレクトリにはWebFOCUSで使用するPython関数が含まれています。

## ディレクトリ構成

### `basic/` - 基本的な関数

四則演算、統計処理、文字列操作などの基本的な関数

#### ファイル一覧

- **[newfunc.py](basic/newfunc.py)** - 基本的な関数集
  - `kakezan(csvin, csvout)` - 乗算
  - `prime(csvin, csvout)` - 素数判定
  - `median(csvin, csvout)` - 中央値計算
  - `hensachi(csvin, csvout)` - 偏差値計算

- **[hensachi.py](basic/hensachi.py)** - ランキングと文字列処理
  - `` rank(csvin, csvout)` - ランク付け
  - `unique(csvin, csvout)` - ユニーク文字列抽出

- **[sample.py](basic/sample.py)** - サンプルテンプレート
  - `sample(csvin, csvout)` - サンプル関数

### `external/` - 外部API連携

WebAPIやWebスクレイピングを使った関数

#### ファイル一覧

- **[xsearch.py](external/xsearch.py)** - X(旧Twitter)検索
  - `xsearch(csvin, csvout)` - ツイート取得

- **[temp_script.py](external/temp_script.py)** - テンプレート

## 開発ガイドライン

### 関数の基本構造

```python
import csv

def function_name(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['output_column']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            # 処理
            result = row['input_column'] * 2
            writer.writerow({'output_column': result})
```

### 重要なルール

1. **csvモジュールのインポート** - 必須
2. **csvin/csvout引数** - 関数の最初の2引数
3. **`newline=''`** - ファイルオープン時に必須
4. **`quoting=csv.QUOTE_NONNUMERIC`** - reader/writerで指定
5. **行数の一致** - `csvout`の行数は必ず`csvin`と同じにする

### ローカルテスト

```python
if __name__ == '__main__':
    # テスト実行
    function_name('test_input.csv', 'test_output.csv')
```

> [!TIP]
> ローカルテストは、`venv`で作成した仮想環境上で実行することを推奨します。詳細は[環境構築](/docs/02_environment_setup.md)を参照してください。

## 使用方法

### 1. 開発

`src/`ディレクトリで新しいPython関数を作成

### 2. ローカルテスト

```powershell
python src/basic/newfunc.py
```

### 3. WebFOCUSに配置

```
C:\ibi\srv93\ibi_apps\python\
```

### 4. シノニム作成

WebFOCUS管理コンソールから`.mas`/`.acx`ファイルを生成

### 5. FEXで呼び出し

```focexec
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
```

## 参考資料

- [開発ガイドライン](/docs/03_development_guidelines.md)
- [コードサンプル集](/docs/06_code_samples.md)

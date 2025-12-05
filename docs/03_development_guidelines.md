# 開発ガイドライン

WebFOCUSで使用するPython関数を作成する際の規約とベストプラクティスを説明します。

## 必須要件

Python関数がWebFOCUSと互換性を持つためには、以下の要件を満たす必要があります。

### 1. csvモジュールのインポート

WebFOCUSはデータをCSVファイルでやり取りするため、`csv`モジュールは必須です。

```python
import csv
```

### 2. グローバル変数: csvinとcsvout

- **`csvin`**: WebFOCUSが自動生成する一時入力CSVファイルのパス
- **`csvout`**: WebFOCUSが自動生成する一時出力CSVファイルのパス

> [!CAUTION]
> これらの変数はWebFOCUSによって設定されます。関数内で値を変更しないでください。

> [!NOTE]
> 一時ファイルは処理後すぐに削除されるため、ユーザーが直接見ることはできません。

### 3. 関数シグネチャ

関数の最初の2つの引数は**必ず**`csvin`と`csvout`とします。

```python
def function_name(csvin, csvout):
    # 処理内容
```

### 4. ファイルオープン時のnewlineパラメータ

CSVファイルを開く際は**必ず**`newline=''`を指定します。

```python
with open(csvin, 'r', newline='') as file_in, \
     open(csvout, 'w', newline='') as file_out:
```

> [!IMPORTANT]
> `newline=''`を指定しないと:
> - 引用符内の改行が正しく解釈されない
> - Windowsプラットフォームで余分な`\r`が追加される

### 5. quoting パラメータ

readerとwriterには`quoting=csv.QUOTE_NONNUMERIC`を指定します。

```python
reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                        fieldnames=fieldnames)
```

**効果:**
- 非数値（文字列、日付など）は二重引用符で囲まれる
- 数値は引用符なしで出力される
- 入力時にWebFOCUSの数値はPythonの浮動小数点数に自動変換される

> [!NOTE]
> WebFOCUSでINTEGER型として定義された場合、小数点以下は切り捨てられます。

## 開発規約

### ヘッダーレコードの使用（推奨）

ヘッダーレコードを使用すると、フィールドをインデックスではなく名前で参照できるため、コードの可読性が向上します。

```python
# ヘッダーを使用する場合（推奨）
fieldnames = ['result', 'status']
reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                        fieldnames=fieldnames)
writer.writeheader()  # ヘッダー行を書き込み
```

> [!TIP]
> ヘッダーを使用しない場合、シノニム生成時のフィールド名は`FIELD_1`、`FIELD_2`...となります。

### 出力フィールドの定義

`fieldnames`には、WebFOCUSのPYTHON関数で`output_field`として指定する項目を含めます。

```python
fieldnames = ['col1', 'col2', 'result']
```

> [!NOTE]
> 通常、PYTHON関数で指定できる`output_field`は1つだけです。ただし、複数のフィールドを定義しておき、複数のCOMPUTE文で異なるフィールドを参照することは可能です。

**例: 複数の出力フィールド**
```python
# Python関数
fieldnames = ['addition', 'subtraction', 'multiplication', 'division']

# WebFOCUS側
COMPUTE Add/D7 = PYTHON(python/calc, NUM1, NUM2, addition);
COMPUTE Sub/D7 = PYTHON(python/calc, NUM1, NUM2, subtraction);
COMPUTE Mul/D16 = PYTHON(python/calc, NUM1, NUM2, multiplication);
COMPUTE Div/D7.2 = PYTHON(python/calc, NUM1, NUM2, division);
```

### 行数の一致

> [!CAUTION]
> **最重要ルール**: `csvout`の行数は**必ず**`csvin`の行数と一致させてください。

行数が一致しない場合、WebFOCUSでエラーが発生します。

#### 集計関数の場合

集計結果が1件でも、入力と同じ行数分、同じ値を出力します。

```python
def median(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['median']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        # 全データを読み込み
        col1_list = []
        for row in reader:
            col1_list.append(row['col1'])
        
        # 中央値を計算
        col1_list.sort()
        median_value = col1_list[len(col1_list) // 2]
        
        # 入力と同じ行数分、結果を出力
        for _ in col1_list:
            writer.writerow({'median': median_value})
```

#### サブルーチンとして使用する場合

サーバサイド処理が目的の場合も、全行に成功/失敗ステータスを返します。

```python
def send_email(csvin, csvout):
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['status']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            try:
                # メール送信処理
                send_mail_function(row['email'], row['message'])
                writer.writerow({'status': 'success'})
            except Exception as e:
                writer.writerow({'status': f'error: {str(e)}'})
```

### 出力の形式

出力は**必ずシーケンス**（リストや辞書）で指定します。

**正しい例:**
```python
writer.writerow({'result': value})  # 辞書
writer.writerow([value])  # リスト
```

**誤った例:**
```python
writer.writerow(result)  # スカラー値（エラー発生）
```

### 関数の構成

#### mainブロックの扱い

```python
if __name__ == '__main__':
    # このブロックはWebFOCUSからの実行時には無視される
    # ローカルテスト用に使用可能
    test_function()
```

> [!TIP]
> ローカルテストは、`venv`で作成した仮想環境上で実行することを推奨します。詳細は[環境構築](/docs/02_environment_setup.md)を参照してください。

> [!TIP]
> `if __name__ == '__main__':`ブロックは、WebFOCUS外でのテスト時に便利です。WebFOCUSから実行する際は無視されます。

#### 複数関数の定義

1つのPythonファイルに複数の関数を定義できます。シノニム作成時に、どの関数を起動関数とするか選択します。

```python
# calculator.py
import csv

def add(csvin, csvout):
    # 加算処理
    pass

def subtract(csvin, csvout):
    # 減算処理
    pass

def multiply(csvin, csvout):
    # 乗算処理
    pass
```

## コーディングベストプラクティス

### 1. エンコーディングの明示

文字列を扱う場合は、エンコーディングを明示します。

```python
with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
     open(csvout, 'w', newline='', encoding='utf-8') as file_out:
```

### 2. エラーハンドリング

```python
def safe_function(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['result', 'error']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            try:
                result = complex_calculation(row['value'])
                writer.writerow({'result': result, 'error': ''})
            except Exception as e:
                writer.writerow({'result': 0, 'error': str(e)})
```

### 3. ロギング

デバッグ用にログファイルを出力することも可能です。

```python
import logging

# ログの設定（関数外で1回だけ）
logging.basicConfig(
    filename='C:/ibi/srv90/ibi_apps/python/logs/debug.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def debug_function(csvin, csvout):
    logging.info(f"Function started with csvin: {csvin}")
    
    try:
        # 処理
        pass
    except Exception as e:
        logging.error(f"Error occurred: {str(e)}")
        raise
```

### 4. パフォーマンス最適化

大量データを扱う場合は、メモリ効率を考慮します。

```python
def efficient_function(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=['result'])
        writer.writeheader()
        
        # 行ごとに処理（全データをメモリに読み込まない）
        for row in reader:
            result = process_row(row)
            writer.writerow({'result': result})
```

## テンプレート

### 基本テンプレート

```python
import csv

def template_function(csvin, csvout):
    """
    WebFOCUS Python関数のテンプレート
    
    Args:
        csvin: 入力CSVファイルパス
        csvout: 出力CSVファイルパス
    """
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        # 出力フィールド定義
        fieldnames = ['output_column']
        
        # リーダー/ライターの設定
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        
        # ヘッダー書き込み
        writer.writeheader()
        
        # データ処理
        for row in reader:
            # 入力フィールドから値を取得
            input_value = row['input_column']
            
            # 処理ロジック
            output_value = your_logic(input_value)
            
            # 結果を出力
            writer.writerow({'output_column': output_value})
```

### 外部ライブラリ使用テンプレート

```python
import csv
import external_library  # 外部ライブラリ

def library_function(csvin, csvout):
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['result']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            # ライブラリの機能を使用
            result = external_library.process(row['data'])
            writer.writerow({'result': result})
```

## 次のステップ

- **[シノニム作成](04_synonym_creation.md)**: 作成した関数のシノニムを生成
- **[サンプルコード](06_code_samples.md)**: 実用的なコード例を参照

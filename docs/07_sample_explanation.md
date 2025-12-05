# Python関数サンプル解説: `kakezan`

このドキュメントでは、WebFOCUSから呼び出すPython関数のサンプルとして、`src/basic/newfunc.py`に含まれる`kakezan`関数を詳しく解説します。

## 1. 関数の概要

`kakezan`関数は、入力データとして渡された2つの数値列(`col1`, `col2`)を掛け算し、その結果を新しい列(`seki`)として出力するシンプルな関数です。

### 処理イメージ

| 入力 (col1) | 入力 (col2) | -> | 出力 (col1) | 出力 (col2) | 出力 (seki) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 10 | 2 | -> | 10 | 2 | 20 |
| 5 | 3 | -> | 5 | 3 | 15 |
| 100 | 0.5 | -> | 100 | 0.5 | 50.0 |

## 2. Pythonコード解説

ソースコード: `src/basic/newfunc.py`

```python
import csv

# a_numberとanother_numberの積をcsvoutに出力
def kakezan(csvin, csvout):
    # ファイルの読み書き処理
    with open(csvin,  'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        
        # 出力するCSVのヘッダー（列名）を定義します
        fieldnames = ['col1', 'col2', 'seki']
        
        # CSV読み込みオブジェクトを作成
        # quoting=csv.QUOTE_NONNUMERIC: 数値は数値として読み込みます
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        
        # CSV書き込みオブジェクトを作成
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        
        # ヘッダー行を書き込みます
        writer.writeheader()
        
        # 各行について処理を行います
        for row in reader:
            # 掛け算を行います
            ret1 = row['col1'] * row['col2']
            
            # 結果を書き込みます
            writer.writerow({
                'col1': row['col1'],
                'col2': row['col2'],
                'seki': ret1
            })
```

### ポイント
- **`csv`モジュール**: CSVファイルの読み書きを簡単に行うための標準ライブラリです。
- **`csvin`, `csvout`**: WebFOCUSから渡される入力ファイルパスと出力ファイルパスです。
- **`quoting=csv.QUOTE_NONNUMERIC`**: これを指定することで、CSV内の数値を文字列ではなく数値（float型）として読み込むことができます。計算を行う場合に便利です。
- **`writer.writerow`**: 辞書形式でデータを渡すことで、指定した列に対応する値を書き込みます。

## 3. WebFOCUSとの連携 (Master/Access File)

Python関数をWebFOCUSから呼び出すためには、Master File (.mas) と Access File (.acx) が必要です。

### Master File (`synonyms/newfunc_kakezan.mas`)

```
FILENAME=NEWFUNC_KAKEZAN, SUFFIX=PYTHON  ,
 REMARKS='Synonym for Python Input/Output Data with parameters: , ... MODNAME=python/newfunc.py, FUNCTION=kakezan, ...', $
  SEGMENT=INPUT_DATA, SEGTYPE=S0, $
    FIELDNAME=COL1, ALIAS=col1, USAGE=I11, ACTUAL=STRING, ... $
    FIELDNAME=COL2, ALIAS=col2, USAGE=I11, ACTUAL=STRING, ... $
  SEGMENT=OUTPUT_DATA, SEGTYPE=U, PARENT=INPUT_DATA, $
    FIELDNAME=COL1, ALIAS=col1, USAGE=D33.1, ACTUAL=STRING, ... $
    FIELDNAME=COL2, ALIAS=col2, USAGE=D33.1, ACTUAL=STRING, ... $
    FIELDNAME=SEKI, ALIAS=seki, USAGE=D33.1, ACTUAL=STRING, ... $
```

- **`MODNAME=python/newfunc.py`**: 呼び出すPythonファイル名を指定します（WebFOCUSのパス基準）。
- **`FUNCTION=kakezan`**: 呼び出す関数名を指定します。
- **`SEGMENT=INPUT_DATA`**: Python関数への入力項目を定義します。
- **`SEGMENT=OUTPUT_DATA`**: Python関数からの出力項目を定義します。

### Access File (`synonyms/newfunc_kakezan.acx`)

Access Fileは通常、Master Fileと同じ場所に作成され、データの物理的な場所などを定義しますが、PYTHONアダプタの場合は主にMaster Fileの情報で動作します。

## 4. テスト実行方法

### ローカルでのテスト

開発環境（VS Codeなど）で動作確認を行うには、以下のようなコードを`newfunc.py`の末尾に追加するか、別のテスト用スクリプトを作成して実行します。

**テスト用データの準備 (`test_input.csv`)**
```csv
"col1","col2"
10,2
5,3
```

**テスト実行コード**
```python
if __name__ == '__main__':
    kakezan('test_input.csv', 'test_output.csv')
```

**実行コマンド**
```powershell
python src/basic/newfunc.py
```

実行後、`test_output.csv`が作成され、計算結果が含まれていることを確認します。

### WebFOCUSでの実行

FOCEXEC (FEX) から以下のように呼び出します。

```focexec
-* サンプルデータの作成
TABLE FILE SYSTABLE
PRINT 
     COMPUTE COL1/I5 = 10;
     COMPUTE COL2/I5 = 2;
IF RECORDLIMIT EQ 1
ON TABLE HOLD AS INPUT_DATA FORMAT COMMA
END

-* Python関数の呼び出し
TABLE FILE INPUT_DATA
PRINT 
     COMPUTE RESULT/D12.2 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
END
```

- **`PYTHON(...)`**: 定義したMaster File (`python/newfunc_kakezan`) を指定し、入力項目 (`COL1`, `COL2`) と取得したい出力項目 (`seki`) を指定します。

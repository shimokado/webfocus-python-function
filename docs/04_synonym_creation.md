# シノニム作成

WebFOCUS Python関数を使用するためには、シノニム（メタデータオブジェクト）を作成する必要があります。シノニムは、Master File（入出力フィールドの定義）とAccess File（スクリプトファイルとサンプルデータの情報）で構成されます。

## 事前準備

### 1. サンプルCSVファイルの作成

シノニム作成時に、入力データのフィールド名とデータ型を判定するためのサンプルCSVが必要です。

**作成ルール:**
- **ヘッダー付き**のCSVファイル
- Python関数の`csvin`で定義した**列名を必ず含める**
- データは最低1行あればOK（複数行推奨）
- 拡張子は`.csv`
- 他の関数と兼用可能（余分な列があってもOK）

**サンプル: calc_sample.csv**
```csv
"col1","col2","col3","col4"
1,2,3,4
2,3,4,5
10,20,30,40
100,200,300,400
```

> [!TIP]
> Python関数開発時にローカルテストで使用したCSVファイルをそのまま使用できます。

### 2. ファイルの配置

WebFOCUSの有効なAPPパスにファイルを配置します。

**配置例:**
```
C:\ibi\srv90\ibi_apps\python\
├── scripts\
│   └── calculator.py          # Python関数ファイル
└── samples\
    └── calc_sample.csv        # サンプルCSV
```

## シノニム作成手順

### ステップ1: シノニム作成画面を開く

1. **WebFOCUS Reporting Server Web Console**にアクセス
2. **「Connect to Data」**ページへ移動
3. **「Configured Adapters」**リストから**「PYTHON」**を右クリック
4. コンテキストメニューで**「Create metadata objects」**をクリック

### ステップ2: パラメータ設定

「Create Synonym for Python」画面で以下の項目を設定します:

#### Python Script
利用する関数を含む`.py`ファイルを選択

- 直接入力: `アプリケーション名/スクリプト名`
- または省略記号ボタン（...）でファイルピッカーから選択

**例:**
```
python/calculator.py
```

#### Function Name
Pythonスクリプト内に定義されている関数名を選択

**例:**
```python
# calculator.py内の関数定義
def adder(csvin, csvout):
    # 処理
```
→ 関数名として`adder`を選択

> [!NOTE]
> 1つの`.py`ファイルに複数の関数がある場合、ドロップダウンリストから起動したい関数を選択します。

#### Select file with sample input data for the PYTHON Script
サンプルCSVファイルを選択

- 省略記号ボタン（...）でファイルピッカーを開く
- アプリケーションディレクトリとファイルを選択
- **OK**をクリック

**例:**
```
python/calc_sample.csv
```

> [!IMPORTANT]
> このファイルは、`csvin`に送られるデータのフィールド名、データ型、長さを決定するために使用されます。

#### CSV files with header
ヘッダーレコードの有無を指定

- **Input**: 入力CSVにヘッダー行がある場合はチェック✅
- **Output**: 出力CSVにヘッダー行がある場合はチェック✅

> [!TIP]
> 推奨設定: 両方チェック✅（入力・出力ともにヘッダー付き）

**ヘッダーなしの例:**
```python
# 入力にヘッダーなし、出力にヘッダーあり
with open(csvin, 'r', newline='') as file_in, \
     open(csvout, 'w', newline='') as file_out:
    
    reader = csv.DictReader(file_in, fieldnames=['input_field'],
                            quoting=csv.QUOTE_NONNUMERIC)
    writer = csv.DictWriter(file_out, fieldnames=['output_field'],
                            quoting=csv.QUOTE_NONNUMERIC)
    writer.writeheader()  # ヘッダー書き込み
```

#### Application
シノニムを保存するアプリケーションディレクトリ

- 直接入力または省略記号ボタン（...）で選択
- 通常はPythonスクリプトと同じアプリケーション

**例:**
```
python
```

#### Synonym Name
シノニムの名称（WebFOCUS PYTHON関数で指定する名前）

- デフォルト名を受け入れるか、独自の名前を入力
- わかりやすい名前を推奨

**例:**
```
calculator_add
```

### ステップ3: シノニムの作成

1. 全パラメータを入力後、リボンの**「Create Synonym」**ボタンをクリック
2. エラーなく完了すれば、指定したアプリケーションディレクトリにシノニムが作成される

## 生成されるファイル

### Master File (.mas)
フィールド定義を含むメタデータファイル

**例: calculator_add.mas**
```
FILENAME=CALCULATOR_ADD, SUFFIX=PYTHON , $
SEGMENT=INPUT_DATA, SEGTYPE=S0, $
  FIELDNAME=COL1, ALIAS=col1, USAGE=I11,
      ACTUAL=STRING,      MISSING=ON,      TITLE='col1', $
  FIELDNAME=COL2, ALIAS=col2, USAGE=I11,
      ACTUAL=STRING,      MISSING=ON,      TITLE='col2', $
SEGMENT=OUTPUT_DATA, SEGTYPE=U, PARENT=INPUT_DATA, $
  FIELDNAME=ADDITION, ALIAS=addition, USAGE=D10.1,
      ACTUAL=STRING,      MISSING=ON,      TITLE='addition', $
```

**セグメント説明:**
- **INPUT_DATA**: 入力フィールドの定義
- **OUTPUT_DATA**: 出力フィールドの定義（親セグメントはINPUT_DATA）

### Access File (.acx)
スクリプトとサンプルデータの参照情報

**例: calculator_add.acx**
```
SEGNAME=INPUT_DATA,
  MODNAME=python/calculator.py,
  FUNCTION=adder,
  PYTHON_INPUT_SAMPL=python/calc_sample.csv,
  INPUT_HEADER=YES,
  OUTPUT_HEADER=YES, $
```

**パラメータ説明:**
- **MODNAME**: Pythonスクリプトのパス
- **FUNCTION**: 起動する関数名
- **PYTHON_INPUT_SAMPL**: サンプル入力データのパス
- **INPUT_HEADER / OUTPUT_HEADER**: ヘッダーの有無

## WebFOCUSでの使用

シノニム作成後、WebFOCUS内でPYTHON関数として利用できます。

### 構文

```focexec
COMPUTE output/format = PYTHON([app/]synonym, input1, input2, output_column);
```

### 例: 加算関数

```focexec
TABLE FILE DATASOURCE
SUM FIELD1 FIELD2
COMPUTE RESULT/I9 = PYTHON(python/calculator_add, FIELD1, FIELD2, addition);
END
```

**パラメータ:**
- `python/calculator_add`: アプリケーション名/シノニム名
- `FIELD1, FIELD2`: 入力フィールド（`csvin`の`col1`, `col2`にマッピング）
- `addition`: 出力フィールド（Master FileのOUTPUT_DATAセグメントの列名）

> [!IMPORTANT]
> 最後の引数（`output_column`）は、Master FileのOUTPUT_DATAセグメントに定義されたフィールド名（大文字）と一致している必要があります。

## 複数出力フィールドの利用

1つの関数が複数の出力フィールドを返す場合、複数のCOMPUTE文でそれぞれのフィールドを取得します。

### Python関数例

```python
def arithmetic(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['addition', 'subtraction', 'multiplication', 'division']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            add = row['a'] + row['b']
            sub = row['a'] - row['b']
            mul = row['a'] * row['b']
            div = row['a'] / row['b']
            writer.writerow({
                'addition': add,
                'subtraction': sub,
                'multiplication': mul,
                'division': div
            })
```

### WebFOCUS呼び出し例

```focexec
TABLE FILE SALES
SUM DOLLARS UNITS
COMPUTE ADD_RESULT/D7 = PYTHON(python/arithmetic, DOLLARS, UNITS, ADDITION);
COMPUTE SUB_RESULT/D7 = PYTHON(python/arithmetic, DOLLARS, UNITS, SUBTRACTION);
COMPUTE MUL_RESULT/D16 = PYTHON(python/arithmetic, DOLLARS, UNITS, MULTIPLICATION);
COMPUTE DIV_RESULT/D7.2 = PYTHON(python/arithmetic, DOLLARS, UNITS, DIVISION);
END
```

> [!NOTE]
> 同じ関数を複数回呼び出しても、WebFOCUSは効率的に処理します。

## サンプルチュートリアル

WebFOCUS管理コンソールから、サンプルスクリプトとデータを自動生成できます。

### 手順

1. アプリケーションフォルダを作成
2. フォルダを右クリック → **New** → **Tutorials**
3. **「WebFOCUS - Retail Demo」**を選択
4. **「Create Python Example」**をチェック✅
5. **「Tutorial Data Volume Limit」**で「Large」または「Medium」を選択
6. **「Create」**をクリック

> [!TIP]
> チュートリアルで生成されたサンプルは学習に最適です。構造を参考にして独自の関数を開発しましょう。

## トラブルシューティング

### シノニム作成時のエラー

**症状**: 「Cannot find Python script」エラー
**解決策**:
- Pythonスクリプトが指定したパスに存在するか確認
- アプリケーションパスが正しいか確認

**症状**: 「Function not found」エラー
**解決策**:
- スクリプト内に指定した関数名が存在するか確認
- 関数のシグネチャが`def function_name(csvin, csvout):`となっているか確認

**症状**: フィールド名が「FIELD_1」「FIELD_2」となる
**解決策**:
- サンプルCSVにヘッダー行が含まれているか確認
- 「CSV files with header」の「Input」にチェック✅が入っているか確認

### WebFOCUS実行時のエラー

**症状**: 「Field not found in segment OUTPUT_DATA」
**解決策**:
- PYTHON関数の最後の引数（output_column）がMaster Fileに定義されているか確認
- 大文字・小文字の一致を確認（通常は大文字）

## 次のステップ

- **[ライブラリ管理](05_library_management.md)**: 追加パッケージのインストール方法
- **[サンプルコード](06_code_samples.md)**: 実用的なコード例を参照

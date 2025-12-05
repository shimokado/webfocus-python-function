# プロジェクト実例解説

このドキュメントでは、このプロジェクトに含まれる実際のWebFOCUS Python関数の詳細な解説を提供します。

## 概要

このプロジェクトには、WebFOCUS環境で実際に動作する様々なPython関数が含まれています。各関数はWebFOCUSの開発ガイドラインに準拠し、本番環境で使用できる品質を持っています。

## 基本関数の実例

### 1. 乗算関数 (`newfunc.kakezan`)

**ファイル**: [`src/basic/newfunc.py`](../src/basic/newfunc.py)

**関数シグネチャ**:
```python
def kakezan(csvin, csvout):
```

**機能**: 2つの数値を乗算し、元の値と積を出力

**入力CSV** (`col1`, `col2`):
```csv
"col1","col2"
1,2
10,20
100,200
```

**出力CSV** (`col1`, `col2`, `seki`):
```csv
"col1","col2","seki"
1,2,2
10,20,200
100,200,20000
```

**WebFOCUS呼び出し**:
```focexec
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, NUM1, NUM2, seki);
```

**実装のポイント**:
- `csv.QUOTE_NONNUMERIC`で数値型を正しく扱う
- 入力の`col1`, `col2`を出力にも含める（デバッグ用）
- 出力フィールド名`seki`はシノニムのOUTPUT_DATAと一致

### 2. 中央値関数 (`newfunc.median`)

**機能**: データセットの中央値を計算し、**全行に同じ値**を出力

**実装コード抜粋**:
```python
def median(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['median']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        # データを全て読み込み
        col1_list = []
        for row in reader:
            col1_list.append(row['col1'])
        
        # 中央値を計算
        col1_list.sort()
        median = col1_list[len(col1_list) // 2]
        
        # 入力と同じ行数を出力（重要！）
        for _ in col1_list:
            writer.writerow({'median': median})
```

**重要ポイント**:
> [!IMPORTANT]
> 集計関数でも、**csvinと同じ行数をcsvoutに出力**する必要があります。
> 結果が1件でも、全行に同じ値を繰り返し出力します。

**入力例**:
```csv
"col1"
5
1
9
3
7
```

**出力例**（全行に中央値5を出力）:
```csv
"median"
5
5
5
5
5
```

### 3. 偏差値関数 (`newfunc.hensachi`)

**機能**: 各データの偏差値を計算

**数式**: `偏差値 = 50 + 10 × (値 - 平均) / 標準偏差`

**実装のポイント**:
1. 全データを読み込んで平均と標準偏差を計算
2. 各値の偏差値を計算して**元の順序で**出力

### 4. 素数関数 (`newfunc.prime`)

**機能**: 指定した数値より大きい最小の素数と、小さい最大の素数を求める

**特徴**:
- ログファイルへの書き込み（実行履歴の記録）
- エッジケース処理（1より小さい場合は0を返す）

**ログ記録例**:
```python
from datetime import datetime
with open('c:\\ibi\\apps\\python\\primelog.txt', 'a') as f:
    f.write(str(datetime.now()) + '\n')
```

> [!TIP]
> サーバサイドでの実行履歴を残したい場合、このようにログファイルに追記することで追跡できます。

## 文字列処理関数の実例

### 5. ランク関数 (`hensachi.rank`)

**ファイル**: [`src/basic/hensachi.py`](../src/basic/hensachi.py)

**機能**: 数値の降順ランキングを計算

**実装の工夫**:
```python
# ソート前の順序を保持
original_col1_list = col1_list.copy()

# 降順にソート
col1_list.sort(reverse=True)

# 元の順序でランクを取得
ret = [col1_list.index(col1) + 1 for col1 in original_col1_list]
```

### 6. ユニーク文字列抽出 (`hensachi.unique`)

**機能**: 文字列を一意に識別できる最短の部分文字列を抽出

**例**:
```
入力: ["abcde", "abe", "bcd", "cde", "cdf"]
出力: ["abc", "abe", "b", "cde", "cdf"]
```

**アルゴリズム**:
1. 各文字列の左から1文字ずつ取得
2. 未使用の文字列が見つかるまで文字数を増やす
3. 一意になった時点でリストに追加

## 外部API連携の実例

### 7. X(旧Twitter)検索ツイート取得 (`xsearch.xsearch`)

**ファイル**: [`src/external/xsearch.py`](../src/external/xsearch.py)

**機能**: X(旧Twitter)の検索結果から最新のツイートを取得

**必要なライブラリ**:
```powershell
pip install requests beautifulsoup4
```

**実装の詳細**:

```python
import requests
from bs4 import BeautifulSoup

def xsearch(csvin, csvout):
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['ret']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            ret = sub_get_tweet(row['str'])
            writer.writerow({'ret': ret})

def sub_get_tweet(query):
    url = f"https://twitter.com/search?q={query}&f=live"
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    tweet = soup.find('div', {'data-testid': 'tweet'})
    if tweet:
        tweet_text = tweet.find('div', {'lang': True}).text
        return tweet_text
    return 'No tweet found'
```

**ポイント**:
1. **`encoding='utf-8'`**: 日本語を含む文字列を扱うため
2. **スクレイピング**: `BeautifulSoup`を使用してHTML解析
3. **ヘルパー関数**: ロジックの分離

**入力例**:
```csv
"str"
"python"
"webfocus"
```

**出力例**:
```csv
"ret"
"Pythonの新しいバージョンがリリースされました..."
"WebFOCUSのデータ可視化機能について..."
```

## シノニムファイルの実例

### Master File (.mas) の構造

**例**: [`synonyms/newfunc_kakezan.mas`](../synonyms/newfunc_kakezan.mas)

```
FILENAME=NEWFUNC_KAKEZAN, SUFFIX=PYTHON ,
  SEGMENT=INPUT_DATA, SEGTYPE=S0, $
    FIELDNAME=COL1, ALIAS=col1, USAGE=I11, ACTUAL=STRING, ...
    FIELDNAME=COL2, ALIAS=col2, USAGE=I11, ACTUAL=STRING, ...
  SEGMENT=OUTPUT_DATA, SEGTYPE=U, PARENT=INPUT_DATA, $
    FIELDNAME=COL1, ALIAS=col1, USAGE=D33.1, ACTUAL=STRING, ...
    FIELDNAME=COL2, ALIAS=col2, USAGE=D33.1, ACTUAL=STRING, ...
    FIELDNAME=SEKI, ALIAS=seki, USAGE=D33.1, ACTUAL=STRING, ...
```

**構成要素**:
- `FILENAME`: シノニム名（大文字）
- `SUFFIX=PYTHON`: Python関数であることを示す
- `INPUT_DATA`: 入力フィールドの定義
- `OUTPUT_DATA`: 出力フィールドの定義

### Access File (.acx) の構造

**例**: [`synonyms/newfunc_kakezan.acx`](../synonyms/newfunc_kakezan.acx)

```
SEGNAME=INPUT_DATA, 
  MODNAME=python/newfunc.py, 
  FUNCTION=kakezan, 
  PYTHON_INPUT_SAMPL=python/sample.csv, 
  INPUT_HEADER=YES, 
  OUTPUT_HEADER=YES, $
```

**パラメータ説明**:
- `MODNAME`: WebFOCUSサーバでのPythonファイルパス
- `FUNCTION`: 実行する関数名
- `PYTHON_INPUT_SAMPL`: サンプルCSVのパス
- `INPUT_HEADER` / `OUTPUT_HEADER`: ヘッダーの有無

> [!NOTE]
> `MODNAME`のパスは、WebFOCUSサーバ上のパスです。
> ローカル開発環境の`src/`パスとは異なります。

## ベストプラクティスの実例まとめ

### 1. エラーハンドリング

素数関数でのエッジケース処理:
```python
if previous_prime == 1:
    previous_prime = 0  # 素数が見つからない場合
```

### 2. ロギング

実行履歴の記録:
```python
from datetime import datetime
with open('primelog.txt', 'a') as f:
    f.write(str(datetime.now()) + '\n')
```

### 3. コードの再利用

検索関数でのヘルパー関数:
```python
def sub_get_tweet(query):
    # API呼び出しロジック
    pass
```

### 4. データ型の適切な処理

数値データ:
```python
reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC, ...)
```

文字列データ:
```python
reader = csv.DictReader(file_in)  # quotingなし
writer = csv.DictWriter(file_out, ...)  # quotingなし
```

### 5. 文字エンコーディング

日本語を含む場合:
```python
with open(csvin, 'r', newline='', encoding='utf-8') as file_in:
    ...
```

## デプロイメントの実例

### 1. ファイル配置

```
C:\ibi\srv93\ibi_apps\python\
├── newfunc.py              # src/basic/ から
├── hensachi.py             # src/basic/ から
├── xsearch.py              # src/external/ から
├── newfunc_kakezan.mas     # synonyms/ から
├── newfunc_kakezan.acx     # synonyms/ から
└── sample.csv              # samples/ から
```

### 2. シノニム作成

WebFOCUS管理コンソールで既存の`.mas`/`.acx`を使用、または新規作成

### 3. WebFOCUSでの利用

```focexec
TABLE FILE DATASOURCE
SUM COL1 COL2
COMPUTE PRODUCT/I9 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
COMPUTE MEDIAN/D7 = PYTHON(python/newfunc_median, VALUE, median);
COMPUTE RANK/I5 = PYTHON(python/hensachi_rank, SCORE, ret);
COMPUTE TWEET/A256 = PYTHON(python/xsearch, KEYWORD, ret);
END
```

## トラブルシューティングの実例

### 問題: 行数不一致エラー

**誤った実装**:
```python
# NG: 集計結果1件のみ出力
median_value = calculate_median(data)
writer.writerow({'median': median_value})  # 1行のみ
```

**正しい実装**:
```python
# OK: 入力と同じ行数を出力
for _ in col1_list:
    writer.writerow({'median': median_value})  # 全行
```

### 問題: 文字コードエラー

**解決策**:
```python
# encoding指定を追加
with open(csvin, 'r', newline='', encoding='utf-8') as file_in:
    ...
```

## まとめ

このプロジェクトの実例から学べること:

1. **基本を守る**: csvin/csvout、newline、quotingの正しい使用
2. **行数一致の徹底**: 集計関数でも全行出力
3. **外部ライブラリの活用**: requests、xml.etree等
4. **エラーハンドリング**: エッジケースへの対応
5. **ログ記録**: 実行履歴の追跡
6. **コードの再利用**: ヘルパー関数の活用

これらの実例を参考に、独自のWebFOCUS Python関数を開発してください。

## 参考資料

- [開発ガイドライン](03_development_guidelines.md)
- [コードサンプル集](06_code_samples.md)
- [トラブルシューティング](07_troubleshooting.md)

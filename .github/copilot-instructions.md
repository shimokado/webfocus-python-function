# WebFOCUS用PYTHON関数用、pythonプログラム開発

## プログラム仕様

- WebFOCUS用の関数は、CSVファイルを読み込み、処理結果を別のCSVファイルに書き出します。
- 引数
    - csvin (str): 入力CSVファイルのパス。
    - csvout (str): 出力CSVファイルのパス。

- csvinはタイトル行を含むCSVファイル
- csvoutはタイトル行を含みcsvinの列と結果の列"ret"を出力する
- csvoutには必ずcsvoutと同じ行数の結果を返すこととする。
    - 出力する値が１件の場合も全行に同じ結果を返す
    - 戻り値がないサブルーチン場合も全行にokの文字を返す
    - 関数内で別の関数を呼び出す場合、サブルーチン名はsub_で始める

### sample.py 
kakezan関数でcsvinのa_number列とb_number列の積をret列として出力
- 出力結果のretをcsvinと同じ行数返す
```python
import csv
import time

# a_numberとb_numberの積をcsvoutに出力
def kakezan(csvin, csvout):
    with open(csvin,  'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        fieldnames = ['a_number', 'b_number', 'ret']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        for row in reader:
            ret = row['a_number'] * row['b_nnumber']
            writer.writerow({
                'ret': ret
            })
```

### 文字処理型サンプル
```python
# strのgoogle検索関連ワードをcsvoutに出力
import csv
import requests
import xml.etree.ElementTree as ET

def related(csvin, csvout):
    with open(csvin,  'r', newline='', encoding='utf-8') as file_in,\
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        fieldnames = ['ret']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        for row in reader:
            ret = sub_get_related_words(row['str'])
            writer.writerow({
                'ret': ret
            })

def sub_get_related_words(query):
    url = f"https://www.google.com/complete/search?ie=utf-8&oe=utf-8&q={query}&output=toolbar"
    response = requests.get(url)
    root = ET.fromstring(response.content)
    suggestions = root.findall('.//suggestion')
    related_words = [suggestion.attrib['data'] for suggestion in suggestions[:5]]
    return ': '.join(related_words)
```


### 集計型サンプル
```python
import csv
def average(csvin, csvout):
    with open(csvin,  'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        fieldnames = ['ret']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        col1_list = []
        for row in reader:
            col1_list.append(row['col1'])
        ave = sum(col1_list) / len(col1_list)
        # 全行に同じ結果を返す
        for row in col1_list:
            writer.writerow({'ret': ave})
```

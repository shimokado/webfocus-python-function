# サンプルコード集

WebFOCUS Python関数の実用的なコード例を紹介します。

## 基本操作

### 1. 四則演算

```python
import csv

def arithmetic(csvin, csvout):
    """
    2つの数値の四則演算
    """
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['addition', 'subtraction', 'multiplication', 'division']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            a = row['a_number']
            b = row['another_number']
            
            writer.writerow({
                'addition': a + b,
                'subtraction': a - b,
                'multiplication': a * b,
                'division': a / b if b != 0 else 0
            })
```

**WebFOCUS呼び出し:**
```focexec
COMPUTE ADD/D7 = PYTHON(python/arithmetic, NUM1, NUM2, addition);
COMPUTE SUB/D7 = PYTHON(python/arithmetic, NUM1, NUM2, subtraction);
```

### 2. 文字列操作

```python
import csv

def string_ops(csvin, csvout):
    """
    文字列の大文字変換と長さ計算
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['upper', 'length', 'reversed']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            text = row['text']
            writer.writerow({
                'upper': text.upper(),
                'length': len(text),
                'reversed': text[::-1]
            })
```

## 統計・集計処理

### 3. 中央値（Median）

```python
import csv

def median(csvin, csvout):
    """
    列の中央値を計算（全行に同じ値を返す）
    """
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

### 4. pandasを使った統計

```python
import csv
import pandas as pd
import io

def pandas_stats(csvin, csvout):
    """
    pandasでデータを読み込み、統計量を計算
    """
    # CSVをpandas DataFrameとして読み込み
    df = pd.read_csv(csvin, quoting=1)  # quoting=1はQUOTE_ALL
    
    # 統計量を計算
    mean_value = df['value'].mean()
    std_value = df['value'].std()
    
    # 結果を各行に追加
    df['mean'] = mean_value
    df['std'] = std_value
    
    # 出力
    df[['mean', 'std']].to_csv(csvout, index=False, quoting=1)
```

## 外部データ取得

### 5. Google関連キーワード取得

```python
import csv
import requests
import xml.etree.ElementTree as ET

def get_related_keywords(csvin, csvout):
    """
    Google検索の関連キーワードを取得
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['related_words']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            query = row['keyword']
            related = fetch_google_suggestions(query)
            writer.writerow({'related_words': related})

def fetch_google_suggestions(query):
    """
    Google Auto-Complete APIから候補を取得
    """
    url = f"https://www.google.com/complete/search?ie=utf-8&oe=utf-8&q={query}&output=toolbar"
    
    try:
        response = requests.get(url, timeout=5)
        root = ET.fromstring(response.content)
        suggestions = root.findall('.//suggestion')
        related_words = [s.attrib['data'] for s in suggestions[:5]]
        return ', '.join(related_words)
    except Exception as e:
        return f"Error: {str(e)}"
```

**必要なライブラリ:**
```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages requests
```

### 6. WebスクレイピングでWebFOCUS

```python
import csv
import requests
from bs4 import BeautifulSoup

def scrape_title(csvin, csvout):
    """
    Webページのタイトルとメタディスクリプションを取得
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['title', 'description']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            url = row['url']
            
            try:
                response = requests.get(url, timeout=10)
                soup = BeautifulSoup(response.content, 'html.parser')
                
                title = soup.find('title')
                title_text = title.text if title else 'No title'
                
                description = soup.find('meta', attrs={'name': 'description'})
                desc_text = description['content'] if description else 'No description'
                
                writer.writerow({
                    'title': title_text,
                    'description': desc_text
                })
            except Exception as e:
                writer.writerow({
                    'title': f'Error: {str(e)}',
                    'description': ''
                })
```

**必要なライブラリ:**
```powershell
C:\ibi\srv90\home\etc\python\python.exe -m pip install --target=C:\ibi\srv90\home\etc\python\lib\site-packages beautifulsoup4
```

## 日付・時刻処理

### 7. 日付計算

```python
import csv
from datetime import datetime, timedelta

def date_calculation(csvin, csvout):
    """
    日付の加算・減算、営業日計算
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['days_diff', 'future_date', 'weekday']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            date_str = row['date']  # 'YYYY-MM-DD'形式
            days = int(row['days'])
            
            date_obj = datetime.strptime(date_str, '%Y-%m-%d')
            future = date_obj + timedelta(days=days)
            
            # 現在日との差分
            today = datetime.now()
            diff = (date_obj - today).days
            
            # 曜日
            weekday = date_obj.strftime('%A')  # Monday, Tuesday, ...
            
            writer.writerow({
                'days_diff': diff,
                'future_date': future.strftime('%Y-%m-%d'),
                'weekday': weekday
            })
```

### 8. 営業日計算（pandasを使用）

```python
import csv
import pandas as pd
from datetime import datetime

def business_days(csvin, csvout):
    """
    営業日計算（土日を除外）
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['business_days']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            start_date = pd.to_datetime(row['start_date'])
            end_date = pd.to_datetime(row['end_date'])
            
            # 営業日の数を計算
            bdays = pd.bdate_range(start_date, end_date)
            count = len(bdays)
            
            writer.writerow({'business_days': count})
```

## データ変換

### 9. JSON解析

```python
import csv
import json

def parse_json(csvin, csvout):
    """
    JSON文字列を解析して特定のフィールドを抽出
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['name', 'age', 'city']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            json_str = row['json_data']
            
            try:
                data = json.loads(json_str)
                writer.writerow({
                    'name': data.get('name', ''),
                    'age': data.get('age', 0),
                    'city': data.get('city', '')
                })
            except json.JSONDecodeError:
                writer.writerow({'name': 'Error', 'age': 0, 'city': ''})
```

### 10. Base64エンコード/デコード

```python
import csv
import base64

def base64_encode(csvin, csvout):
    """
    文字列をBase64エンコード
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['encoded']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            text = row['text']
            encoded = base64.b64encode(text.encode('utf-8')).decode('utf-8')
            writer.writerow({'encoded': encoded})
```

## 機械学習（scikit-learn）

### 11. 線形回帰予測

```python
import csv
import numpy as np
from sklearn.linear_model import LinearRegression

def linear_prediction(csvin, csvout):
    """
    過去データから線形回帰でトレンド予測
    """
    with open(csvin, 'r', newline='') as file_in:
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        data = list(reader)
    
    # データ準備
    X = np.array([[i] for i in range(len(data))])
    y = np.array([row['value'] for row in data])
    
    # モデル訓練
    model = LinearRegression()
    model.fit(X, y)
    
    # 予測
    with open(csvout, 'w', newline='') as file_out:
        fieldnames = ['predicted']
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for i in range(len(data)):
            pred = model.predict([[i]])[0]
            writer.writerow({'predicted': pred})
```

## ファイル操作

### 12. ファイル存在確認

```python
import csv
import os

def file_exists(csvin, csvout):
    """
    ファイルパスの存在確認
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['exists', 'is_file', 'size']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            path = row['file_path']
            
            exists = os.path.exists(path)
            is_file = os.path.isfile(path) if exists else False
            size = os.path.getsize(path) if is_file else 0
            
            writer.writerow({
                'exists': 'Yes' if exists else 'No',
                'is_file': 'Yes' if is_file else 'No',
                'size': size
            })
```

## エラーハンドリング

### 13. 堅牢なエラー処理

```python
import csv
import logging

# ログ設定
logging.basicConfig(
    filename='C:/ibi/srv90/ibi_apps/python/logs/error.log',
    level=logging.ERROR,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def safe_division(csvin, csvout):
    """
    ゼロ除算を適切に処理
    """
    with open(csvin, 'r', newline='') as file_in, \
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['result', 'status']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            try:
                a = row['numerator']
                b = row['denominator']
                
                if b == 0:
                    result = 0
                    status = 'Division by zero'
                else:
                    result = a / b
                    status = 'OK'
                
                writer.writerow({'result': result, 'status': status})
                
            except Exception as e:
                logging.error(f"Error processing row: {row}, Error: {str(e)}")
                writer.writerow({'result': 0, 'status': f'Error: {str(e)}'})
```

## サブルーチンとしての利用

### 14. メール送信

```python
import csv
import smtplib
from email.mime.text import MIMEText

def send_notification(csvin, csvout):
    """
    条件を満たす場合にメール送信
    """
    with open(csvin, 'r', newline='', encoding='utf-8') as file_in, \
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        
        fieldnames = ['status']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            try:
                threshold = float(row['threshold'])
                value = float(row['value'])
                
                if value > threshold:
                    send_email(
                        to=row['email'],
                        subject='Alert: Threshold Exceeded',
                        body=f'Value {value} exceeded threshold {threshold}'
                    )
                    status = 'Email sent'
                else:
                    status = 'No action'
                
                writer.writerow({'status': status})
            except Exception as e:
                writer.writerow({'status': f'Error: {str(e)}'})

def send_email(to, subject, body):
    """メール送信関数（要設定）"""
    # SMTPサーバ設定
    smtp_server = 'smtp.example.com'
    smtp_port = 587
    sender = 'noreply@example.com'
    password = 'password'
    
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = to
    
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(sender, password)
        server.send_message(msg)
```

## 次のステップ

- **[トラブルシューティング](07_troubleshooting.md)**: よくある問題と解決方法

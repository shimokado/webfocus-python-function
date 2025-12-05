# csvinで与えられたstrの値でX(旧Twitter)を検索し、一番新しい１件のツイートを取得し、ret列に出力します。

# 以下のライブラリをインストールしてください
# pip install requests
# pip install beautifulsoup4
#
import csv
import requests
from bs4 import BeautifulSoup
import re

def xsearch(csvin, csvout):
    with open(csvin,  'r', newline='', encoding='utf-8') as file_in,\
         open(csvout, 'w', newline='', encoding='utf-8') as file_out:
        fieldnames = ['ret']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        for row in reader:
            ret = sub_get_tweet(row['str'])
            writer.writerow({
                'ret': ret
            })

def sub_get_tweet(query):
    url = f"https://twitter.com/search?q={query}&f=live"
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    tweet = soup.find('div', {'data-testid': 'tweet'})
    if tweet:
        tweet_text = tweet.find('div', {'lang': True}).text
        return tweet_text
    return 'No tweet found'

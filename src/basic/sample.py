# sample.py
# 全ての関数でタイトル付のCSVを読み込み、タイトル付のCSVを出力する

import csv
import time


def sample(csvin, csvout):
    with open(csvin,  'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        fieldnames = ['a_number', 'another_number', 'product']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        for row in reader:
            ret = row['a_number'] * row['another_number']
            writer.writerow({
                'ret': ret
            })

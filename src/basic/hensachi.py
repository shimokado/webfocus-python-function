# rank関数
# rank関数は、csvinのcol1列の値に基づいて順位を計算し、結果をret列としてcsvoutに出力します。
import csv
def rank(csvin, csvout):
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
        # ソート前のcol1_listを保持
        original_col1_list = col1_list.copy()
        # 降順にソート
        col1_list.sort(reverse=True)
        # オリジナルのcol1_listの値に対して、ソート後のcol1_listの値のインデックスを取得
        ret = [col1_list.index(col1) + 1 for col1 in original_col1_list]
        for row in ret:
            writer.writerow({'ret': row})

# unique関数
# unique関数は、csvinのstr列の値を一意に識別できる範囲で短くした値をret列としてcsvoutに出力します。
# 例えばabcde, abe,bcd,cde,cdf,ef,egという文字列があった場合、abc, abe,b,cde,cdf,ef,egを返す
# それぞれの文字はcsvoutの中で一意である必要があります。
# この条件を満たしながら最短の文字数まで最小の範囲で左から順に文字を取得します。
def unique(csvin, csvout):
    with open(csvin,  'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        fieldnames = ['ret']
        reader = csv.DictReader(file_in)
        writer = csv.DictWriter(file_out, fieldnames=fieldnames)
        writer.writeheader()
        str_list = []
        for row in reader:
            str_list.append(row['str'])
        # 重複を削除
        str_list = list(set(str_list))
        # 一意な文字列を取得
        unique_str_list = []
        for str in str_list:
            for i in range(1, len(str) + 1):
                unique_str = str[:i]
                if unique_str not in unique_str_list:
                    unique_str_list.append(unique_str)
                    break
        for row in unique_str_list:
            writer.writerow({'ret':
                                row})
            

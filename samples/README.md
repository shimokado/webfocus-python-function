# samples/ - サンプルCSVデータ

このディレクトリには、Python関数のテストとシノニム作成に使用するサンプルCSVファイルが含まれています。

## サンプルデータの役割

1. **ローカルテスト** - Python関数の動作確認
2. **シノニム作成** - WebFOCUSシノニム生成時の入力データ型判定
3. **動作検証** - WebFOCUSでの実行結果確認

## サンプルファイル一覧

- **[sample.csv](sample.csv)** - 基本的な数値データ（`newfunc.py`などのテスト用）

## サンプルCSVの作成ガイドライン

### 基本フォーマット

```csv
"column1","column2","column3"
value1,value2,value3
```

### 重要なルール

1. **ヘッダー付き** - 必ず最初の行にカラム名を含める
2. **引用符** - 文字列は二重引用符で囲む
3. **数値** - 引用符なしで記述
4. **列名** - Python関数の`csv.DictReader`で使用する名前と一致させる
5. **データ型** - シノニム作成時のデータ型判定に影響するため、実際のデータに近い値を使用

### 数値データの例

```csv
"col1","col2"
1,2
10,20
100,200
```

- 数値は引用符なし
- WebFOCUSは自動的に浮動小数点数に変換

### 文字列データの例

```csv
"str","description"
"test","テストデータ"
"sample","サンプル"
```

- 文字列は二重引用符で囲む
- 日本語もUTF-8でサポート

## 使用方法

### ローカルテスト

```python
# Python関数の直接実行
if __name__ == '__main__':
    function_name('samples/sample.csv', 'outputs/result.csv')
```

### シノニム作成時

WebFOCUS管理コンソールで:
1. **Select file with sample input data** でこのディレクトリのCSVを選択
2. シノニムが生成される際に、サンプルCSVからフィールド名とデータ型が決定される

### WebFOCUSでのテスト

```focexec
FILEDEF TESTDATA DISK samples/sample.csv
TABLE FILE TESTDATA
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
END
```

## トラブルシューティング

### 問題: フィールド名が "FIELD_1" になる

**原因**: サンプルCSVにヘッダー行がない

**解決策**: 最初の行にカラム名を追加

### 問題: 数値が文字列として認識される

**原因**: サンプルCSVで数値が引用符で囲まれている

**解決策**: 数値は引用符なしで記述

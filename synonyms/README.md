# synonyms/ - WebFOCUSシノニムファイル

このディレクトリにはWebFOCUS Python関数のシノニム（メタデータ）ファイルが含まれています。

## シノニムファイルの役割

WebFOCUSからPython関数を呼び出すためには、以下のファイルが必要です:

- **`.mas` (Master File)** - 入出力フィールドの定義
- **`.acx` (Access File)** - Pythonスクリプトとサンプルデータの参照情報
- **`.ftm` (Format File)** - データフォーマット定義（オプション）
- **`.fex` (Focexec File)** - 実行スクリプト（オプション）

## 含まれているシノニム

### 基本関数用シノニム

| シノニム名 | 関数 | 説明 |
|----------|------|------|
| `newfunc_kakezan` | `newfunc.kakezan` | 乗算 |
| `newfunc_median` | `newfunc.median` | 中央値計算 |
| `newfunc_prime` | `newfunc.prime` | 素数判定 |
| `kakezan` | `newfunc.kakezan` | 乗算（別名） |

### 外部API連携用シノニム

| シノニム名 | 関数 | 説明 |
|----------|------|------|
| `gsearch_related` | gsearch.related | Google関連キーワード取得 |
| `gsearch_related2` | `gsearch.related` | Google関連キーワード（バージョン2） |

## ファイル構成例

### Master File (.mas)

```
FILENAME=NEWFUNC_KAKEZAN, SUFFIX=PYTHON ,
  SEGMENT=INPUT_DATA, SEGTYPE=S0, $
    FIELDNAME=COL1, ALIAS=col1, USAGE=I11, ...
    FIELDNAME=COL2, ALIAS=col2, USAGE=I11, ...
  SEGMENT=OUTPUT_DATA, SEGTYPE=U, PARENT=INPUT_DATA, $
    FIELDNAME=SEKI, ALIAS=seki, USAGE=D33.1, ...
```

### Access File (.acx)

```
SEGNAME=INPUT_DATA, 
  MODNAME=python/newfunc.py, 
  FUNCTION=kakezan, 
  PYTHON_INPUT_SAMPL=python/sample.csv, 
  INPUT_HEADER=YES, 
  OUTPUT_HEADER=YES, $
```

## シノニム作成手順

### 1. サンプルCSV準備

```csv
"col1","col2"
1,2
10,20
```

### 2. WebFOCUS管理コンソールからシノニム作成

1. **Connect to Data** → **PYTHON** を右クリック
2. **Create metadata objects** を選択
3. 必要な情報を入力:
   - Python Script: `python/newfunc.py`
   - Function Name: `kakezan`
   - Sample Input Data: `python/sample.csv`
   - CSV files with header: Input/Output両方チェック
   - Application: `python`
   - Synonym Name: `newfunc_kakezan`
4. **Create Synonym** をクリック

### 3. 生成されたファイルを確認

- `newfunc_kakezan.mas`
- `newfunc_kakezan.acx`

## WebFOCUSでの使用

```focexec
TABLE FILE DATASOURCE
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, FIELD1, FIELD2, seki);
END
```

**パラメータ:**
- `python/newfunc_kakezan` - アプリケーション名/シノニム名
- `FIELD1, FIELD2` - 入力フィールド
- `seki` - 出力フィールド（Master FileのOUTPUT_DATAセグメント内の列名）

## デプロイ方法

### WebFOCUSサーバへの配置

```powershell
# シノニムファイルをWebFOCUSサーバにコピー
Copy-Item synonyms\*.mas, synonyms\*.acx C:\ibi\srv93\ibi_apps\python\
```

> [!IMPORTANT]
> `.acx`ファイル内の`MODNAME`パスは、WebFOCUSサーバでの配置パスを指定しています。
> ローカル開発環境とは異なる場合があるので注意してください。

## トラブルシューティング

### エラー: "Field not found in segment OUTPUT_DATA"

**原因**: PYTHON関数の最後の引数がMaster Fileに定義されていない

**解決策**: Master File (.mas) のOUTPUT_DATAセグメントを確認し、正しいフィールド名（大文字）を指定

### エラー: "Cannot find Python script"

**原因**: ACXファイルの`MODNAME`パスが正しくない

**解決策**: Pythonスクリプトが正しい場所に配置されているか確認

## 参考資料

- [シノニム作成ガイド](/docs/04_synonym_creation.md)
- [トラブルシューティング](/docs/07_troubleshooting.md)

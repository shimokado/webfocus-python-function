# GitHub Copilot Instructions

このプロジェクトは、WebFOCUSでPython関数を開発する技術者向けの**テンプレート、ガイド、ベストプラクティス集**です。
開発者がこのリポジトリをベースとして、独自のPython関数を効率的に開発できることを目的としています。

## プロジェクト構成

- **`src/`**: Python関数のソースコード
  - `src/basic/`: 基本的な関数（算術演算、統計処理など）
  - `src/external/`: 外部API連携の関数
- **`synonyms/`**: WebFOCUSシノニムファイル (.mas, .acx)
- **`samples/`**: テスト用サンプルCSVデータ
- **`tests/`**: pytestによるテストコード
- **`docs/`**: 包括的な開発ドキュメント（12種類）
- **`tools/`**: 開発支援スクリプト（環境構築など）

## ドキュメント参照

開発者を支援する際は、以下のドキュメントを参照してください:

### 基本ガイド（必読）
1. **概要**: `docs/01_overview.md`
2. **環境構築**: `docs/02_environment_setup.md`
3. **開発ガイドライン**: `docs/03_development_guidelines.md`
4. **シノニム作成**: `docs/04_synonym_creation.md`
5. **ライブラリ管理**: `docs/05_library_management.md`
6. **コードサンプル集**: `docs/06_code_samples.md`

### 実践ガイド
7. **サンプル解説 (kakezan関数)**: `docs/07_sample_explanation.md`
8. **テストガイド (pytest)**: `docs/08_testing_guide.md`
9. **Pythonアダプタ設定**: `docs/09_python_adapter_configuration.md` ← **重要**

### トラブル対応・参考
10. **トラブルシューティング**: `docs/10_troubleshooting.md`
11. **プロジェクト例**: `docs/11_project_examples.md`
12. **Pythonアダプタリファレンス**: `docs/12_reference_python_adapter.md`

## コーディング規約

### 関数の基本構造
すべてのPython関数は以下のパターンに従ってください:

```python
import csv

def function_name(csvin, csvout):
    with open(csvin, 'r', newline='') as file_in,\
         open(csvout, 'w', newline='') as file_out:
        
        fieldnames = ['output_column']
        reader = csv.DictReader(file_in, quoting=csv.QUOTE_NONNUMERIC)
        writer = csv.DictWriter(file_out, quoting=csv.QUOTE_NONNUMERIC,
                                fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            # 処理
            result = row['input_column'] * 2
            writer.writerow({'output_column': result})
```

### 重要なポイント
- `newline=''`を必ず指定
- `quoting=csv.QUOTE_NONNUMERIC`を使用
- 入力行数と出力行数を一致させる
- 外部API連携の例は`src/external/xsearch.py`を参照

## ローカル環境での開発

### 環境構築
```powershell
# venv環境のセットアップ（推奨）
.\tools\setup_env.ps1

# WebFOCUS用Pythonへのライブラリインストール
C:\Users\<username>\AppData\Local\Programs\Python\Python39\python.exe -m pip install -r requirements.txt
```

### テスト実行
```powershell
# pytestによるテスト（推奨）
pytest

# または個別のPythonファイルを直接実行
python src/basic/newfunc.py
```

## WebFOCUS連携

### シノニムファイル
- `.mas`ファイル: Master File（データ構造定義）
- `.acx`ファイル: Access File（データソース定義）
- `synonyms/`フォルダ内のサンプルを参照

### FEXからの呼び出し
```focexec
TABLE FILE DATASOURCE
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
END
```

## よくある質問への対応

### Q: venvとWebFOCUS用Pythonの違いは？
→ `docs/09_python_adapter_configuration.md`の「環境の使い分けガイド」を参照

### Q: ライブラリを追加したのにWebFOCUSで動かない
→ `docs/09_python_adapter_configuration.md`の「よくある誤解」セクションを参照
（WebFOCUS Serverの再起動が必要です）

### Q: テストの書き方は？
→ `docs/08_testing_guide.md`と`tests/test_newfunc.py`を参照

### Q: エラーが出た
→ まず`docs/10_troubleshooting.md`を確認

## このプロジェクトの活用方法

1. **テンプレートとして使用**: プロジェクト全体をコピーして自分用にカスタマイズ
2. **サンプルコードを参考に**: `src/`内のコードを参考に新しい関数を作成
3. **ドキュメントで学習**: `docs/`の各ガイドで段階的に学習
4. **テストで品質確保**: `tests/`のパターンを真似てテストを作成

---

**開発者の成功を支援することが、あなたの役割です。** 
わからないことがあれば、常に関連ドキュメントを案内し、ベストプラクティスに従った開発を促してください。

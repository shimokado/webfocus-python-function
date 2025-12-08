# WebFOCUS Python関数 開発テンプレート

このリポジトリは、WebFOCUSでPython関数を開発する技術者のための**テンプレート、ガイド、ベストプラクティス集**です。

> [!NOTE]
> このプロジェクトは**出発点として設計**されています。プロジェクト全体をコピーして、あなた独自のWebFOCUS Python関数開発に活用してください。

## 🎯 このプロジェクトの目的

- ✅ WebFOCUS Python関数開発の**実用的なテンプレート**を提供
- ✅ 段階的に学べる**包括的なドキュメント**（12種類）
- ✅ すぐに使える**サンプルコード**と**テストパターン**
- ✅ 開発環境構築から本番デプロイまでの**ベストプラクティス**
- ✅ pytestを使った**テスト駆動開発**の推奨

## 🚀 クイックスタート

### 1. プロジェクトをコピー

```powershell
git clone https://github.com/yourusername/webfocus-python-function.git
cd webfocus-python-function
```

### 2. 開発環境のセットアップ

```powershell
# venv環境の自動構築（推奨）
.\tools\setup_env.ps1

# 環境の有効化
.\venv\Scripts\Activate.ps1
```

### 3. ドキュメントで学ぶ

まずは[ドキュメント一覧](#-ドキュメント)から以下を読むことをお勧めします：
1. [概要](docs/01_overview.md) - WebFOCUS Python関数とは
2. [環境構築](docs/02_environment_setup.md) - 開発環境のセットアップ
3. [サンプル解説](docs/07_sample_explanation.md) - kakezan関数の詳細解説
4. [Pythonアダプタ設定](docs/09_python_adapter_configuration.md) - WebFOCUS側の設定（重要）

### 4. サンプルコードを実行

```powershell
# サンプル関数のローカルテスト
python src/basic/newfunc.py

# pytestによるテスト実行
pytest
```

### 5. 独自の関数を開発

`src/`ディレクトリにあるサンプルコードを参考に、独自のPython関数を作成してください。

## 📁 プロジェクト構成

```
webfocus-python-function/
├── src/                # Python関数のソースコード（ここを編集）
│   ├── basic/         # 基本関数のサンプル
│   └── external/      # 外部API連携のサンプル
│
├── synonyms/          # WebFOCUSシノニムファイル (.mas, .acx)
├── samples/           # テスト用サンプルCSVデータ
├── tests/             # pytestテストコード
├── docs/              # 包括的な開発ドキュメント（12種類）
├── tools/             # 開発支援スクリプト
└── outputs/           # 出力ファイル保存先
```

## 📖 ドキュメント

すべてのドキュメントは[`docs/`](docs/)ディレクトリにあります:

### 基礎編
1. [概要と導入](docs/01_overview.md)
2. [環境構築](docs/02_environment_setup.md)
3. [開発ガイドライン](docs/03_development_guidelines.md)
4. [シノニム作成](docs/04_synonym_creation.md)
5. [ライブラリ管理](docs/05_library_management.md)
6. [ライブラリ同期ガイド](docs/13_library_sync_guide.md) ← **重要**
7. [コードサンプル集](docs/06_code_samples.md)

### 実践編
8. [サンプル解説 (kakezan関数)](docs/07_sample_explanation.md)
9. [テストガイド (pytest)](docs/08_testing_guide.md)
10. [Pythonアダプタ設定](docs/09_python_adapter_configuration.md) ← **重要**

### トラブル対応・参考
11. [トラブルシューティング](docs/10_troubleshooting.md)
12. [プロジェクト例](docs/11_project_examples.md)
13. [Pythonアダプタリファレンス](docs/12_reference_python_adapter.md)

## 💡 サンプルコード

### 基本関数 (`src/basic/`)

| ファイル | 機能 |
|---------|------|
| `newfunc.py` | 四則演算、中央値、偏差値計算 |
| `hensachi.py` | ランク付け、ユニーク文字列抽出 |
| `sample.py` | 最小限のテンプレート |

### 外部連携 (`src/external/`)

| ファイル | 機能 |
|---------|------|
| `xsearch.py` | X(旧Twitter)検索・ツイート取得 |

## 🧪 テスト

### pytestによる自動テスト（推奨）

```powershell
# すべてのテストを実行
pytest

# 詳細な出力で実行
pytest -v
```

### 個別のPythonファイルをテスト

```powershell
python src/basic/newfunc.py
```

詳細は[テストガイド](docs/08_testing_guide.md)を参照してください。

## 🔧 WebFOCUSへのデプロイ

### 1. Python関数とシノニムを配置

```
C:\ibi\srv93\ibi_apps\python\
```

### 2. WebFOCUS管理コンソールでアダプタ設定

詳細な手順は[Pythonアダプタ設定ガイド](docs/09_python_adapter_configuration.md)を参照してください。

### 3. FEXファイルで呼び出し

```focexec
TABLE FILE DATASOURCE
COMPUTE RESULT/I9 = PYTHON(python/newfunc_kakezan, COL1, COL2, seki);
END
```

## 🛠️ 必要な環境

- **Python**: 3.9.x（WebFOCUS推奨）
- **WebFOCUS**: Reporting Server 8.2以降
- **必須パッケージ**: pandas, numpy, scipy, scikit-learn, matplotlib, seaborn, statsmodels, xgboost, openpyxl
- **開発用**: pytest

## 📝 ライセンス

このプロジェクトは[MITライセンス](LICENSE)の下で公開されています。
自由に使用、変更、配布していただけます。

## 🔗 参考資料

- [WebFOCUS公式ドキュメント](https://webfocusinfocenter.informationbuilders.com/wfappent/TL5s/TL_srv_adapters/source/python1_using.htm)
- [Zenn記事 - WebFOCUSでPython関数を利用する](https://zenn.dev/shimokado/articles/2f8634331686b4)
- [WebFOCUS Python Adapter Manual](docs/12_reference_python_adapter.md) - 公式リファレンス（ローカル版）

## 🤝 コントリビューション

プロジェクトへのコントリビューションを歓迎します！

- バグ報告や機能提案は[Issues](https://github.com/yourusername/webfocus-python-function/issues)へ
- プルリクエストもお待ちしています

## 📮 サポート

質問や問題があれば、[Issues](https://github.com/yourusername/webfocus-python-function/issues)で気軽にお問い合わせください。
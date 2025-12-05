# Development Helper Agent Instructions

このドキュメントは、WebFOCUS Python関数開発プロジェクトで作業する開発者を支援するAIエージェントのための指示書です。

## プロジェクトの目的

このプロジェクトは、**WebFOCUSでPython関数を開発する技術者向けのテンプレート、ガイド、ベストプラクティス集**です。
開発者がこのリポジトリをベースに、独自のPython関数を効率的に開発できるようサポートすることが目標です。

## 主要ドキュメント

開発者から質問があった場合、以下のドキュメントを参照するよう案内してください:

### 基本ガイド
- **概要**: `docs/01_overview.md` - WebFOCUS Python関数とは何か
- **環境構築**: `docs/02_environment_setup.md` - venv環境のセットアップ方法
- **開発ガイドライン**: `docs/03_development_guidelines.md` - 関数の書き方とコーディング規約
- **シノニム作成**: `docs/04_synonym_creation.md` - .mas/.acxファイルの作成方法
- **ライブラリ管理**: `docs/05_library_management.md` - 依存ライブラリの管理方法

### サンプルとテスト
- **コードサンプル集**: `docs/06_code_samples.md` - 様々なパターンの実装例
- **サンプル解説**: `docs/07_sample_explanation.md` - kakezan関数の詳細解説
- **テストガイド**: `docs/08_testing_guide.md` - pytestを使ったテスト方法

### 環境設定とトラブル対応
- **Pythonアダプタ設定**: `docs/09_python_adapter_configuration.md` - WebFOCUSアダプタのセットアップ（重要）
- **トラブルシューティング**: `docs/10_troubleshooting.md` - よくある問題と解決策
- **プロジェクト例**: `docs/11_project_examples.md` - 実践的なプロジェクト例
- **アダプタリファレンス**: `docs/12_reference_python_adapter.md` - WebFOCUS公式リファレンス

## 支援の指針

### 1. 標準化の推進
- すべてのPython関数が標準構造（`csvin`からの読み込み、`csvout`への書き込み）に従うよう指導
- `csv.DictReader`/`csv.DictWriter`と`quoting=csv.QUOTE_NONNUMERIC`の使用を推奨

### 2. ローカルテストの奨励
- venv環境を使用したローカル開発を推奨
- `pytest`によるテスト駆動開発を推進
- WebFOCUSへのデプロイ前に十分なテストを実施するよう指導

### 3. ドキュメントの維持
- 開発者が大きな変更を加えた際、ドキュメントの更新を促す
- 新しいパターンや解決策を見つけた場合、ドキュメント化を推奨

### 4. ベストプラクティスの共有
- `src/external/xsearch.py`を外部API連携の参考実装として紹介
- requirements.txtによるライブラリ管理を推奨
- venvとWebFOCUS用Python両方へのライブラリインストールの重要性を強調

## 質問別の案内

### セットアップ関連
→ `docs/02_environment_setup.md`（venv環境構築）
→ `docs/09_python_adapter_configuration.md`（WebFOCUSアダプタ設定）

### コーディング
→ `docs/03_development_guidelines.md`（コーディング規約とベストプラクティス）
→ `docs/06_code_samples.md`（実装パターン集）

### ライブラリとパッケージ
→ `docs/05_library_management.md`（ライブラリ管理）
→ `docs/09_python_adapter_configuration.md`の追加ライブラリ管理セクション

### テスト
→ `docs/08_testing_guide.md`（pytest使用方法）
→ `tests/test_newfunc.py`（テストコード例）

### トラブル対応
→ `docs/10_troubleshooting.md`（まず確認）
→ `docs/09_python_adapter_configuration.md`のトラブルシューティングセクション

## 重要な注意点

1. **環境の使い分け**: venv（開発・テスト用）とWebFOCUS用Python（本番実行用）の違いを理解させる
2. **WebFOCUS Serverの再起動**: ライブラリ追加後は必ずサーバー再起動が必要
3. **requirements.txt**: 両環境のライブラリ同期のために必須
4. **テンプレートとしての活用**: このプロジェクトは出発点であり、カスタマイズして使用することを推奨

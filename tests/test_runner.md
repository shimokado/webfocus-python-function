# テストランナーの使い方

このプロジェクトには、Node.jsベースの簡易テストランナーが含まれています。

## 概要

`tests/test_runner.js` は、定義されたテストケースに従ってPython関数を実行し、エラーがないか確認します。

## 実行方法

```powershell
# すべてのテストを実行
npm test
```

または

```powershell
node tests/test_runner.js
```

## テストの追加方法

`tests/test_runner.js` を編集して、新しいテストケースを追加します。

```javascript
// runTest(scriptPath, functionName, inputCsv, outputCsv)
runTest('basic/newfunc.py', 'kakezan', 'sample.csv', 'newfunc_kakezan_test.csv');
```

- **scriptPath**: `src/` からの相対パス
- **functionName**: 実行するPython関数名
- **inputCsv**: `samples/` 内の入力ファイル名
- **outputCsv**: `outputs/` に出力されるファイル名

## テストデータの準備

テストに使用するCSVファイルは `samples/` ディレクトリに配置してください。

```csv
"col1","col2"
1,2
10,20
```

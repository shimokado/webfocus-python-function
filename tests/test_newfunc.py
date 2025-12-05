import sys
import os
import csv
import pytest

# srcディレクトリをパスに追加してモジュールをインポートできるようにする
sys.path.append(os.path.join(os.path.dirname(__file__), '../src/basic'))
import newfunc

class TestNewFunc:
    @pytest.fixture
    def setup_files(self, tmp_path):
        """テスト用の入出力ファイルを準備するフィクスチャ"""
        # 一時ディレクトリに入力ファイルを作成
        input_file = tmp_path / "test_input.csv"
        output_file = tmp_path / "test_output.csv"
        
        # テストデータの作成
        with open(input_file, 'w', newline='') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
            writer.writerow(['col1', 'col2'])
            writer.writerow([10, 2])
            writer.writerow([5, 3])
            writer.writerow([100, 0.5])
            
        return str(input_file), str(output_file)

    def test_kakezan(self, setup_files):
        """kakezan関数のテスト"""
        input_file, output_file = setup_files
        
        # 関数を実行
        newfunc.kakezan(input_file, output_file)
        
        # 出力ファイルが存在することを確認
        assert os.path.exists(output_file)
        
        # 出力内容の検証
        with open(output_file, 'r', newline='') as f:
            reader = csv.DictReader(f, quoting=csv.QUOTE_NONNUMERIC)
            rows = list(reader)
            
            # 行数の確認
            assert len(rows) == 3
            
            # 計算結果の確認
            # 1行目: 10 * 2 = 20
            assert rows[0]['col1'] == 10.0
            assert rows[0]['col2'] == 2.0
            assert rows[0]['seki'] == 20.0
            
            # 2行目: 5 * 3 = 15
            assert rows[1]['col1'] == 5.0
            assert rows[1]['col2'] == 3.0
            assert rows[1]['seki'] == 15.0
            
            # 3行目: 100 * 0.5 = 50
            assert rows[2]['col1'] == 100.0
            assert rows[2]['col2'] == 0.5
            assert rows[2]['seki'] == 50.0

    @pytest.mark.parametrize("col1, col2, expected", [
        (10, 2, 20),
        (5, 3, 15),
        (100, 0.5, 50),
        (0, 10, 0),
        (-5, 2, -10),
    ])
    def test_kakezan_parametrize(self, tmp_path, col1, col2, expected):
        """パラメータ化テストの例: 様々な入力パターンを効率的にテストする"""
        input_file = tmp_path / "param_input.csv"
        output_file = tmp_path / "param_output.csv"
        
        # テストデータの作成
        with open(input_file, 'w', newline='') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
            writer.writerow(['col1', 'col2'])
            writer.writerow([col1, col2])
            
        # 関数を実行
        newfunc.kakezan(str(input_file), str(output_file))
        
        # 出力内容の検証
        with open(output_file, 'r', newline='') as f:
            reader = csv.DictReader(f, quoting=csv.QUOTE_NONNUMERIC)
            rows = list(reader)
            
            assert len(rows) == 1
            assert rows[0]['seki'] == float(expected)

    def test_kakezan_empty_file(self, tmp_path):
        """空のファイルを入力した場合のテスト"""
        input_file = tmp_path / "empty_input.csv"
        output_file = tmp_path / "empty_output.csv"
        
        # ヘッダーのみのファイルを作成
        with open(input_file, 'w', newline='') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
            writer.writerow(['col1', 'col2'])
            
        # 関数を実行
        newfunc.kakezan(str(input_file), str(output_file))
        
        # 出力内容の検証
        with open(output_file, 'r', newline='') as f:
            reader = csv.DictReader(f, quoting=csv.QUOTE_NONNUMERIC)
            rows = list(reader)
            
            # データ行がないことを確認
            assert len(rows) == 0

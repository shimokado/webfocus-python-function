import newfunc
import csv
import os

def test_kakezan():
    input_file = 'test_input.csv'
    output_file = 'test_output.csv'
    
    if os.path.exists(output_file):
        os.remove(output_file)
        
    newfunc.kakezan(input_file, output_file)
    
    assert os.path.exists(output_file)
    
    with open(output_file, 'r', newline='') as f:
        reader = csv.DictReader(f, quoting=csv.QUOTE_NONNUMERIC)
        rows = list(reader)
        
        assert len(rows) == 3
        assert rows[0]['seki'] == 20.0
        assert rows[1]['seki'] == 15.0
        assert rows[2]['seki'] == 50.0
        
    print("Test passed!")
    
    # Clean up
    if os.path.exists(output_file):
        os.remove(output_file)
    if os.path.exists(input_file):
        os.remove(input_file)

if __name__ == '__main__':
    test_kakezan()

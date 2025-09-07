import sys
from itertools import zip_longest

def compare_files(expected_output_path, sim_output_path):
    mismatches = []
    
    try:
        with open(expected_output_path, 'r', encoding='utf-8') as f1, \
             open(sim_output_path, 'r', encoding='utf-8') as f2:
            
            for line_num, (line1, line2) in enumerate(zip_longest(f1, f2, fillvalue=''), 1):
                if line1 != line2:
                    mismatches.append(f"Mismatch at line {line_num}:\n"
                                      f"  Expected: {line1.strip()!r}\n"
                                      f"  Sim output: {line2.strip()!r}\n")
        
        if not mismatches:
            print(f"PASSED: RTL simulation output matches expected results.")
        else:
            print(f"FAILED: Mismatches found in {sim_output_path}")
            for mismatch in mismatches:
                print(mismatch)

    except FileNotFoundError:
        print(f"Error: One or both files not found. Please check paths:")
        print(f"  File 1: {expected_output_path}")
        print(f"  File 2: {sim_output_path}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python check_onboarding.py <expected_output_path> <sim_output_path>")
        sys.exit(1) # Exit with an error code

    file1 = sys.argv[1]
    file2 = sys.argv[2]
    
    compare_files(file1, file2)
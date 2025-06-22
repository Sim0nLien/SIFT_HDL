import numpy as np
import os


# def find_begining

def remove_lines(filename, start, end):
    with open(filename, 'r') as f:
        lines = f.readlines()
    new_lines = lines[:start] + lines[end+1:]
    with open(filename, 'w') as f:
        f.writelines(new_lines)

def add_lines(filename, data, begin_line):
    with open(filename, 'r') as f:
        lines = f.readlines()
    # data_lines = [" "]
    data_lines = [f"{i}  => std_logic_vector(to_unsigned({value},  DEPTH)),\n" for i, value in enumerate(data)]
    new_lines = lines[:begin_line] + data_lines + lines[begin_line:]

    with open(filename, 'w') as f:
        f.writelines(new_lines)

def main(filename, data):
    assert os.path.exists(filename), f"Error: File '{filename}' not found."
    
    begin = "-- BEGIN"

    end = "-- END"
    
    with open(filename, 'r') as f:
        lines = f.readlines()
    
    for idx, line in enumerate(lines):
        if begin in line:
            b_line = idx + 2
        if end in line:
            e_line = idx - 2
    
    remove_lines(filename, b_line, e_line)
    add_lines(filename, data, b_line)


# if __name__ == "__main__":
#     main("image2tb/test.txt", np.array([10, 20, 30, 40, 50, 60, 70, 80, 90, 100]))
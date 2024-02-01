#!/usr/bin/env python3
import sys

def remove_translation_blocks(input_file_path):
    with open(input_file_path, 'r') as input_file:
        lines = input_file.readlines()

        filtered_lines = []
        include_line = True
        for line in lines:
            line = line.strip()
            if 'pragma translate_on' in line:
                include_line = True
            if 'synthesis translate_on' in line:
                include_line = True
            if 'pragma translate on' in line:
                include_line = True

            if include_line:
                filtered_lines.append(line)

            if 'pragma translate_off' in line:
                include_line = False
            if 'synthesis translate_off' in line:
                include_line = False
            if 'pragma translate off' in line:
                include_line = False
            

        sys.stdout.writelines('\n'.join(filtered_lines))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file_path>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    remove_translation_blocks(input_file_path)
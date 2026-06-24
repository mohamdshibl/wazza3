import subprocess
import re
import os

def fix_const_errors():
    # Run flutter analyze
    result = subprocess.run('flutter analyze', shell=True, capture_output=True, text=True)
    output = result.stdout + result.stderr

    # Parse errors
    # Example line:
    # error - Invalid constant value - lib\src\features\home\presentation\stop_details_screen.dart:677:50 - invalid_constant
    pattern = re.compile(r'error - (?:Invalid constant value|Methods can\'t be invoked in constant expressions) - ([^\:]+)\:(\d+)\:\d+')
    
    fixes = {}
    for match in pattern.finditer(output):
        filepath = match.group(1).strip()
        line_num = int(match.group(2))
        
        if filepath not in fixes:
            fixes[filepath] = []
        fixes[filepath].append(line_num)

    total_fixed = 0
    for filepath, lines in fixes.items():
        if not os.path.exists(filepath):
            continue
        with open(filepath, 'r', encoding='utf-8') as f:
            file_lines = f.readlines()
        
        for line_num in lines:
            idx = line_num - 1
            if 0 <= idx < len(file_lines):
                # We need to remove the word 'const' on this line.
                # Sometimes it might be on a previous line if the error points to a child, but flutter usually points to the line where const was used or the child itself.
                # Let's remove 'const ' and 'const\t' from the line.
                original_line = file_lines[idx]
                new_line = re.sub(r'\bconst\s+', '', original_line)
                
                # If there was no const on this line, we might need to look up 1 or 2 lines.
                if new_line == original_line:
                    # Look up a bit
                    for lookup in range(1, 15):
                        if idx - lookup >= 0:
                            lookup_line = file_lines[idx - lookup]
                            new_lookup_line = re.sub(r'\bconst\s+', '', lookup_line)
                            if new_lookup_line != lookup_line:
                                file_lines[idx - lookup] = new_lookup_line
                                total_fixed += 1
                                break
                else:
                    file_lines[idx] = new_line
                    total_fixed += 1
                    
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(file_lines)

    return total_fixed

# Run it a few times in case fixing one uncovers another or the first pass misses
for i in range(3):
    fixed = fix_const_errors()
    print(f"Pass {i+1}: fixed {fixed} const errors")
    if fixed == 0:
        break

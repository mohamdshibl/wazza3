import os
import re
import json

dart_files = []
for root, dirs, files in os.walk('lib/src/features'):
    for f in files:
        if f.endswith('.dart'):
            dart_files.append(os.path.join(root, f))

strings_found = set()

text_pattern = re.compile(r'Text\(\s*([\'\"])([^\$\\\'\"]+)\1')
const_text_pattern = re.compile(r'const\s+Text\(\s*([\'\"])([^\$\\\'\"]+)\1')

for path in dart_files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for match in text_pattern.finditer(content):
        strings_found.add(match.group(2))
    for match in const_text_pattern.finditer(content):
        strings_found.add(match.group(2))

with open('extracted_strings.json', 'w', encoding='utf-8') as f:
    json.dump(sorted(list(strings_found)), f, indent=2)

print(f'Extracted {len(strings_found)} unique strings to extracted_strings.json')

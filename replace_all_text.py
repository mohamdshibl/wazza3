import json
import re
import os

with open('extracted_strings.json', 'r', encoding='utf-8') as f:
    strings = json.load(f)

# Filter out obvious mock data
def is_valid_ui_string(s):
    if len(s) <= 2: return False
    if re.match(r'^[\d\+\- \.\%\$\u00d7]+$', s): return False # just numbers and symbols
    if re.search(r'\d{4}', s): return False # dates or IDs like SO-6001, Jun 23, 2026
    if s.startswith('\ud83d'): return False
    if "Alex Driver" in s: return False
    if "Juice Orange" in s or "Premium Water" in s: return False
    if s in ['retail', 'total invoiced', 'units loaded']: return False # lowercase might be enum data, wait, we might need these?
    return True

ui_strings = [s for s in strings if is_valid_ui_string(s)]

# Add some specific ones back if needed, or remove some
ui_strings = [s for s in ui_strings if not (s.startswith('DO-') or s.startswith('SO-') or s.startswith('ABC-'))]
ui_strings = [s for s in ui_strings if s != 'Good Evening \ud83d\udc4b']
ui_strings.append('Good Evening') # we will manually fix this one if needed

def to_camel_case(text):
    # Remove non-alphanumeric, split by spaces/symbols
    s = re.sub(r'[^a-zA-Z0-9]', ' ', text).strip().split()
    if not s: return "emptyKey"
    return s[0].lower() + ''.join(word.capitalize() for word in s[1:])

mapping = {}
for s in ui_strings:
    key = to_camel_case(s)
    # Handle duplicates
    original_key = key
    counter = 2
    while key in mapping.values():
        key = f"{original_key}{counter}"
        counter += 1
    mapping[s] = key

# Now update app_en.arb
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    app_en = json.load(f)

with open('lib/l10n/app_ar.arb', 'r', encoding='utf-8') as f:
    app_ar = json.load(f)

for s, k in mapping.items():
    if k not in app_en:
        app_en[k] = s
        app_ar[k] = s # Defaulting to english for now

with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(app_en, f, indent=2, ensure_ascii=False)

with open('lib/l10n/app_ar.arb', 'w', encoding='utf-8') as f:
    json.dump(app_ar, f, indent=2, ensure_ascii=False)

# Now replace in dart files
dart_files = []
for root, dirs, files in os.walk('lib/src/features'):
    for f in files:
        if f.endswith('.dart'):
            dart_files.append(os.path.join(root, f))

# Sort keys by length descending to prevent partial replacements
sorted_strings = sorted(mapping.keys(), key=len, reverse=True)

import_statement = "import 'package:wazza3/l10n/app_localizations.dart';"

for path in dart_files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    for s in sorted_strings:
        k = mapping[s]
        # Replace const Text('s') -> Text(AppLocalizations.of(context)!.k)
        # Handle both single and double quotes
        escaped_s = re.escape(s)
        
        # const Text
        content = re.sub(
            r'const\s+Text\(\s*[\'\"]' + escaped_s + r'[\'\"]',
            r'Text(AppLocalizations.of(context)!.' + k,
            content
        )
        # normal Text
        content = re.sub(
            r'Text\(\s*[\'\"]' + escaped_s + r'[\'\"]',
            r'Text(AppLocalizations.of(context)!.' + k,
            content
        )

    if content != original_content:
        # Check if import is present
        if import_statement not in content:
            # find first import
            match = re.search(r'^import\s', content, flags=re.MULTILINE)
            if match:
                idx = match.start()
                content = content[:idx] + import_statement + '\n' + content[idx:]
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

print(f"Replaced {len(mapping)} strings in dart files.")

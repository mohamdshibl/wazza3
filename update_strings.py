import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    
    # Replace AppStrings.<key> with AppLocalizations.of(context)!.<key>
    if 'AppStrings.' in content:
        content = re.sub(r'AppStrings\.([a-zA-Z0-9_]+)', r'AppLocalizations.of(context)!.\1', content)
        
        # Remove AppStrings import if present
        content = re.sub(r"import\s+['\"].*?app_strings\.dart['\"];\n?", '', content)
        
        # Add AppLocalizations import if not present
        if 'package:flutter_gen/gen_l10n/app_localizations.dart' not in content:
            first_import = re.search(r'^import\s', content, flags=re.MULTILINE)
            if first_import:
                idx = first_import.start()
                content = content[:idx] + "import 'package:flutter_gen/gen_l10n/app_localizations.dart';\n" + content[idx:]
            
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {filepath}')

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

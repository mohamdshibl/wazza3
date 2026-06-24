import re
import os

replacements = {
    r"const\s+Text\('Add New Customer'": r"Text(AppLocalizations.of(context)!.addNewCustomer",
    r"const\s+Text\('Type:'": r"Text(AppLocalizations.of(context)!.typeLabel",
    r"Text\('Retail'\)": r"Text(AppLocalizations.of(context)!.retail)",
    r"Text\('Horeca'\)": r"Text(AppLocalizations.of(context)!.horeca)",
    r"Text\('Wholesale'\)": r"Text(AppLocalizations.of(context)!.wholesale)",
    r"const\s+Text\('Cancel'": r"Text(AppLocalizations.of(context)!.cancel",
    r"const\s+Text\('Save'": r"Text(AppLocalizations.of(context)!.save",
    r"const\s+Text\('Today\\'s Route'": r"Text(AppLocalizations.of(context)!.todaysRoute",
    r"Text\('View All'": r"Text(AppLocalizations.of(context)!.viewAll",
    r"Text\('View all 4 upcoming stops →'": r"Text(AppLocalizations.of(context)!.viewAllUpcomingStops(4)",
    r"Text\('\$\{data\.units\} units'": r"Text(AppLocalizations.of(context)!.units(data.units.toString())",
    r"Text\('\$\{data\.amount\} due'": r"Text(AppLocalizations.of(context)!.amountDue(data.amount.toString())",
    r"const\s+Text\('Previous Orders'": r"Text(AppLocalizations.of(context)!.previousOrders",
    r"Text\('View more '": r"Text(AppLocalizations.of(context)!.viewMore",
    r"const\s+Text\('Done'": r"Text(AppLocalizations.of(context)!.done",
    r"Text\('Quantities loaded successfully!'\)": r"Text(AppLocalizations.of(context)!.quantitiesLoaded)",
    r"Text\('Phone number verified successfully!'\)": r"Text(AppLocalizations.of(context)!.phoneVerified)",
    r"Text\('Please enter a valid email address'\)": r"Text(AppLocalizations.of(context)!.enterValidEmail)",
    r"Text\('Reset link sent to \$email'\)": r"Text(AppLocalizations.of(context)!.resetLinkSent(email))",
}

files_to_check = [
    'lib/src/features/orders/presentation/new_order_draft_screen.dart',
    'lib/src/features/home/presentation/widgets/home_view.dart',
    'lib/src/features/home/presentation/do_details_screen.dart',
    'lib/src/features/auth/presentation/otp_verification_screen.dart',
    'lib/src/features/auth/presentation/reset_password_screen.dart'
]

for filepath in files_to_check:
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    for pattern, repl in replacements.items():
        content = re.sub(pattern, repl, content)

    if content != original_content:
        # Add import
        if 'package:wazza3/l10n/app_localizations.dart' not in content:
            first_import = re.search(r'^import\s', content, flags=re.MULTILINE)
            if first_import:
                idx = first_import.start()
                content = content[:idx] + "import 'package:wazza3/l10n/app_localizations.dart';\n" + content[idx:]

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {filepath}')

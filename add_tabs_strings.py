import json

en_dict = {
  "upcomingTab": "Upcoming",
  "mapTab": "Map",
  "completedTab": "Completed"
}

ar_dict = {
  "upcomingTab": "القادمة",
  "mapTab": "الخريطة",
  "completedTab": "المكتملة"
}

for arb_file, data in [('lib/l10n/app_en.arb', en_dict), ('lib/l10n/app_ar.arb', ar_dict)]:
    with open(arb_file, 'r', encoding='utf-8') as f:
        arb = json.load(f)
    for k, v in data.items():
        if k not in arb:
            arb[k] = v
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(arb, f, indent=2, ensure_ascii=False)

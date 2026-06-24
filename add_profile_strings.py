import json

profile_en = {
  "salesRep": "Sales Rep",
  "idRep042": "ID: REP-042",
  "assignedTruck": "Assigned Truck",
  "truckA101": "Truck A-101",
  "territory": "Territory",
  "northDistrict": "North District",
  "role": "Role",
  "appSettings": "App Settings",
  "endSessionLogout": "End Session & Logout"
}

profile_ar = {
  "salesRep": "مندوب مبيعات",
  "idRep042": "المعرف: REP-042",
  "assignedTruck": "الشاحنة المعينة",
  "truckA101": "شاحنة A-101",
  "territory": "المنطقة",
  "northDistrict": "المنطقة الشمالية",
  "role": "الدور",
  "appSettings": "إعدادات التطبيق",
  "endSessionLogout": "إنهاء الجلسة وتسجيل الخروج"
}

for arb_file, data in [('lib/l10n/app_en.arb', profile_en), ('lib/l10n/app_ar.arb', profile_ar)]:
    with open(arb_file, 'r', encoding='utf-8') as f:
        arb = json.load(f)
    for k, v in data.items():
        if k not in arb:
            arb[k] = v
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(arb, f, indent=2, ensure_ascii=False)

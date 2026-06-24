import json

en_dict = {
  "newOrder": "New Order",
  "newCustomer": "New Customer",
  "custody": "Custody",
  "itemsOnTruck": "items on truck",
  "stops": "Stops",
  "doneCount": "{count} done",
  "@doneCount": { "placeholders": { "count": { "type": "String" } } },
  "leftCount": "{count} left",
  "@leftCount": { "placeholders": { "count": { "type": "String" } } },
  "ofAmount": "of {amount}",
  "@ofAmount": { "placeholders": { "amount": { "type": "String" } } },
  "cashAmount": "{amount} cash",
  "@cashAmount": { "placeholders": { "amount": { "type": "String" } } },
  "chkAmount": "{amount} chk",
  "@chkAmount": { "placeholders": { "amount": { "type": "String" } } },
  "ofStopsCount": "of {count} stops",
  "@ofStopsCount": { "placeholders": { "count": { "type": "String" } } }
}

ar_dict = {
  "newOrder": "طلب جديد",
  "newCustomer": "عميل جديد",
  "custody": "العهدة",
  "itemsOnTruck": "عنصر على الشاحنة",
  "stops": "المحطات",
  "doneCount": "{count} منجزة",
  "@doneCount": { "placeholders": { "count": { "type": "String" } } },
  "leftCount": "{count} متبقية",
  "@leftCount": { "placeholders": { "count": { "type": "String" } } },
  "ofAmount": "من {amount}",
  "@ofAmount": { "placeholders": { "amount": { "type": "String" } } },
  "cashAmount": "{amount} نقداً",
  "@cashAmount": { "placeholders": { "amount": { "type": "String" } } },
  "chkAmount": "{amount} شيك",
  "@chkAmount": { "placeholders": { "amount": { "type": "String" } } },
  "ofStopsCount": "من {count} محطات",
  "@ofStopsCount": { "placeholders": { "count": { "type": "String" } } }
}

for arb_file, data in [('lib/l10n/app_en.arb', en_dict), ('lib/l10n/app_ar.arb', ar_dict)]:
    with open(arb_file, 'r', encoding='utf-8') as f:
        arb = json.load(f)
    for k, v in data.items():
        if k not in arb:
            arb[k] = v
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(arb, f, indent=2, ensure_ascii=False)

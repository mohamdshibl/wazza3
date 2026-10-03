/// Delivery Order model representing orders in get_home, get_order, and get_history.
class DeliveryOrder {
  const DeliveryOrder({
    required this.id,
    required this.name,
    this.reference,
    this.stage,
    this.state,
    this.finalStatus,
    this.stopCount,
    this.itemsCount,
    this.salesRep,
    this.warehouse,
    this.currency,
    this.startTime,
    this.loadingOrder,
    this.vehicle,
    this.vehicleString,
    this.shift,
    this.actions,
    this.stops = const [],
    this.goods = const [],
    this.partnerId,
    this.partnerName,
    this.partnerPhone,
    this.partnerAddress,
    this.date,
    this.amountTotal,
    this.lines = const [],
    this.raw = const {},
  });

  final int id;
  final String name;
  final String? reference;
  final String? stage;
  final String? state;
  final String? finalStatus;
  final int? stopCount;
  final int? itemsCount;
  final String? salesRep;
  final String? warehouse;
  final String? currency;
  final String? startTime;
  final dynamic loadingOrder;
  final DeliveryVehicle? vehicle;
  final String? vehicleString;
  final DeliveryShift? shift;
  final DeliveryOrderActions? actions;
  final List<DeliveryStop> stops;
  final List<DeliveryGoodItem> goods;
  final int? partnerId;
  final String? partnerName;
  final String? partnerPhone;
  final String? partnerAddress;
  final String? date;
  final double? amountTotal;
  final List<DeliveryOrderLine> lines;
  final Map<String, dynamic> raw;

  String get displayReference =>
      reference?.isNotEmpty == true ? reference! : (name.isNotEmpty ? name : 'DO-$id');

  String get displayVehicle =>
      vehicle?.name.isNotEmpty == true ? vehicle!.name : (vehicleString ?? '');

  String get displayStatus {
    if (finalStatus?.isNotEmpty == true) return finalStatus!;
    if (state?.isNotEmpty == true) return state!;
    if (stage?.isNotEmpty == true) return stage!.replaceAll('_', ' ');
    return 'draft';
  }

  factory DeliveryOrder.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryOrder(id: 0, name: '');
    }

    final root = <String, dynamic>{};
    for (final entry in rawData.entries) {
      root[entry.key.toString()] = entry.value;
    }

    // Check if wrapped in "order" object (e.g. get_order response)
    final Map<String, dynamic> json;
    if (root['order'] is Map) {
      json = Map<String, dynamic>.from(root['order'] as Map);
    } else {
      json = root;
    }

    // Parse ID
    int id = 0;
    final rawId = json['id'] ?? root['id'];
    if (rawId is num) {
      id = rawId.toInt();
    } else if (rawId is String) {
      id = int.tryParse(rawId) ?? 0;
    }

    // Parse vehicle
    DeliveryVehicle? parsedVehicle;
    String? vStr;
    final rawVeh = json['vehicle'] ?? root['vehicle'];
    if (rawVeh is Map) {
      parsedVehicle = DeliveryVehicle.fromJson(rawVeh);
      vStr = parsedVehicle.name;
    } else if (rawVeh is String) {
      vStr = rawVeh;
    }

    // Parse shift
    DeliveryShift? parsedShift;
    final rawShift = json['shift'] ?? root['shift'];
    if (rawShift is Map) {
      parsedShift = DeliveryShift.fromJson(rawShift);
    }

    // Parse actions
    DeliveryOrderActions? parsedActions;
    final rawActions = root['actions'] ?? json['actions'];
    if (rawActions is Map) {
      parsedActions = DeliveryOrderActions.fromJson(rawActions);
    }

    // Parse stops
    List<DeliveryStop> parsedStops = [];
    final rawStops = root['stops'] ?? json['stops'];
    if (rawStops is List) {
      for (final s in rawStops) {
        if (s is Map) {
          parsedStops.add(DeliveryStop.fromJson(s));
        }
      }
    }

    // Parse goods
    List<DeliveryGoodItem> parsedGoods = [];
    final rawGoods = root['goods'] ?? json['goods'];
    if (rawGoods is List) {
      for (final g in rawGoods) {
        if (g is Map) {
          parsedGoods.add(DeliveryGoodItem.fromJson(g));
        }
      }
    }

    // Parse legacy lines
    List<DeliveryOrderLine> parsedLines = [];
    final rawLines = json['lines'] ?? json['order_lines'] ?? json['items'];
    if (rawLines is List) {
      for (final l in rawLines) {
        if (l is Map) {
          parsedLines.add(DeliveryOrderLine.fromJson(l));
        }
      }
    }

    // Stop count
    int? stopCount;
    final rawStopCount = json['stop_count'] ?? root['stop_count'];
    if (rawStopCount is num) {
      stopCount = rawStopCount.toInt();
    } else if (rawStopCount is String) {
      stopCount = int.tryParse(rawStopCount);
    }
    if (stopCount == null && parsedStops.isNotEmpty) {
      stopCount = parsedStops.length;
    }

    // Items count
    int? itemsCount;
    final rawItemsCount = json['items_count'] ?? root['items_count'];
    if (rawItemsCount is num) {
      itemsCount = rawItemsCount.toInt();
    } else if (rawItemsCount is String) {
      itemsCount = int.tryParse(rawItemsCount);
    }
    if (itemsCount == null && parsedGoods.isNotEmpty) {
      itemsCount = parsedGoods.length;
    }

    // Total amount
    double? total;
    final rawTotal = json['total_amount'] ?? json['amount_total'] ?? root['total_amount'];
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal);
    }

    // Partner info
    int? pId;
    String? pName;
    if (json['partner_id'] is List && (json['partner_id'] as List).isNotEmpty) {
      pId = (json['partner_id'] as List)[0] as int?;
      if ((json['partner_id'] as List).length > 1) {
        pName = (json['partner_id'] as List)[1]?.toString();
      }
    } else if (json['partner_id'] is int) {
      pId = json['partner_id'] as int;
      pName = json['partner_name']?.toString();
    } else if (json['partner_name'] != null) {
      pName = json['partner_name']?.toString();
    }

    final stageStr = root['stage']?.toString() ?? json['stage']?.toString();
    final startTimeVal = json['start_time'] is String ? json['start_time'] as String : null;

    return DeliveryOrder(
      id: id,
      name: json['name']?.toString() ?? json['reference']?.toString() ?? 'DO-$id',
      reference: json['reference']?.toString() ?? root['reference']?.toString(),
      stage: stageStr,
      state: json['state']?.toString() ?? root['state']?.toString() ?? json['final_status']?.toString(),
      finalStatus: json['final_status']?.toString() ?? root['final_status']?.toString(),
      stopCount: stopCount,
      itemsCount: itemsCount,
      salesRep: json['sales_rep']?.toString() ?? root['sales_rep']?.toString(),
      warehouse: json['warehouse']?.toString() ?? root['warehouse']?.toString(),
      currency: json['currency']?.toString() ?? root['currency']?.toString() ?? 'USD',
      startTime: startTimeVal,
      loadingOrder: json['loading_order'] ?? root['loading_order'],
      vehicle: parsedVehicle,
      vehicleString: vStr,
      shift: parsedShift,
      actions: parsedActions,
      stops: parsedStops,
      goods: parsedGoods,
      partnerId: pId,
      partnerName: pName,
      partnerPhone: json['partner_phone']?.toString() ?? json['phone']?.toString(),
      partnerAddress: json['partner_address']?.toString() ?? json['address']?.toString(),
      date: json['date']?.toString() ?? root['date']?.toString() ?? json['scheduled_date']?.toString(),
      amountTotal: total,
      lines: parsedLines,
      raw: root,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (reference != null) 'reference': reference,
        if (stage != null) 'stage': stage,
        if (state != null) 'state': state,
        if (finalStatus != null) 'final_status': finalStatus,
        if (stopCount != null) 'stop_count': stopCount,
        if (itemsCount != null) 'items_count': itemsCount,
        if (salesRep != null) 'sales_rep': salesRep,
        if (warehouse != null) 'warehouse': warehouse,
        if (currency != null) 'currency': currency,
        if (vehicle != null) 'vehicle': vehicle?.toJson(),
        if (shift != null) 'shift': shift?.toJson(),
        if (actions != null) 'actions': actions?.toJson(),
        'stops': stops.map((s) => s.toJson()).toList(),
        'goods': goods.map((g) => g.toJson()).toList(),
        if (date != null) 'date': date,
        if (amountTotal != null) 'amount_total': amountTotal,
        ...raw,
      };
}

class DeliveryShift {
  const DeliveryShift({
    required this.id,
    required this.reference,
    required this.state,
  });

  final int id;
  final String reference;
  final String state;

  factory DeliveryShift.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryShift(id: 0, reference: '', state: '');
    }
    final json = Map<String, dynamic>.from(rawData);
    return DeliveryShift(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      reference: json['reference']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'state': state,
      };
}

class DeliveryVehicle {
  const DeliveryVehicle({
    required this.id,
    required this.name,
    required this.plate,
  });

  final int id;
  final String name;
  final String plate;

  factory DeliveryVehicle.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryVehicle(id: 0, name: '', plate: '');
    }
    final json = Map<String, dynamic>.from(rawData);
    return DeliveryVehicle(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: json['name']?.toString() ?? '',
      plate: json['plate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'plate': plate,
      };
}

class DeliveryOrderActions {
  const DeliveryOrderActions({
    this.startLoading = false,
    this.confirmLoadedGoods = false,
    this.startTrip = false,
  });

  final bool startLoading;
  final bool confirmLoadedGoods;
  final bool startTrip;

  factory DeliveryOrderActions.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryOrderActions();
    }
    final json = Map<String, dynamic>.from(rawData);
    return DeliveryOrderActions(
      startLoading: json['start_loading'] == true,
      confirmLoadedGoods: json['confirm_loaded_goods'] == true,
      startTrip: json['start_trip'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'start_loading': startLoading,
        'confirm_loaded_goods': confirmLoadedGoods,
        'start_trip': startTrip,
      };
}

class DeliveryStop {
  const DeliveryStop({
    required this.id,
    this.sequence = 0,
    this.name = '',
    this.address = '',
    this.phone = '',
    this.time = '',
    this.units = 0,
    this.amount = 0.0,
    this.state = 'pending',
    this.alert,
    this.soCount = 0,
    this.raw = const {},
  });

  final int id;
  final int sequence;
  final String name;
  final String address;
  final String phone;
  final String time;
  final int units;
  final double amount;
  final String state;
  final String? alert;
  final int soCount;
  final Map<String, dynamic> raw;

  factory DeliveryStop.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryStop(id: 0);
    }
    final json = Map<String, dynamic>.from(rawData);
    return DeliveryStop(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      sequence: json['sequence'] is num ? (json['sequence'] as num).toInt() : 0,
      name: json['name']?.toString() ?? json['partner_name']?.toString() ?? '',
      address: json['address']?.toString() ?? json['partner_address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['partner_phone']?.toString() ?? '',
      time: json['time']?.toString() ?? json['scheduled_time']?.toString() ?? '',
      units: json['units'] is num ? (json['units'] as num).toInt() : 0,
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0,
      state: json['state']?.toString() ?? 'pending',
      alert: json['alert']?.toString(),
      soCount: json['so_count'] is num ? (json['so_count'] as num).toInt() : 0,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequence': sequence,
        'name': name,
        'address': address,
        'phone': phone,
        'time': time,
        'units': units,
        'amount': amount,
        'state': state,
        if (alert != null) 'alert': alert,
        'so_count': soCount,
        ...raw,
      };
}

class DeliveryGoodItem {
  const DeliveryGoodItem({
    this.id,
    this.productId,
    required this.productName,
    this.productCode,
    this.quantity = 0.0,
    this.uom,
    this.priceUnit,
    this.priceSubtotal,
    this.raw = const {},
  });

  final int? id;
  final int? productId;
  final String productName;
  final String? productCode;
  final double quantity;
  final String? uom;
  final double? priceUnit;
  final double? priceSubtotal;
  final Map<String, dynamic> raw;

  factory DeliveryGoodItem.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryGoodItem(productName: '');
    }
    final json = Map<String, dynamic>.from(rawData);
    return DeliveryGoodItem(
      id: json['id'] is num ? (json['id'] as num).toInt() : null,
      productId: json['product_id'] is num ? (json['product_id'] as num).toInt() : null,
      productName: json['product_name']?.toString() ?? json['name']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? json['default_code']?.toString(),
      quantity: json['quantity'] is num ? (json['quantity'] as num).toDouble() : 0.0,
      uom: json['uom']?.toString(),
      priceUnit: (json['price_unit'] as num?)?.toDouble(),
      priceSubtotal: (json['price_subtotal'] as num?)?.toDouble(),
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (productId != null) 'product_id': productId,
        'product_name': productName,
        if (productCode != null) 'product_code': productCode,
        'quantity': quantity,
        if (uom != null) 'uom': uom,
        if (priceUnit != null) 'price_unit': priceUnit,
        if (priceSubtotal != null) 'price_subtotal': priceSubtotal,
        ...raw,
      };
}

class DeliveryOrderLine {
  const DeliveryOrderLine({
    this.id,
    this.productId,
    required this.productName,
    this.productCode,
    this.quantity = 0.0,
    this.uom,
    this.priceUnit,
    this.priceSubtotal,
    this.raw = const {},
  });

  final int? id;
  final int? productId;
  final String productName;
  final String? productCode;
  final double quantity;
  final String? uom;
  final double? priceUnit;
  final double? priceSubtotal;
  final Map<String, dynamic> raw;

  factory DeliveryOrderLine.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryOrderLine(productName: '');
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    int? pId;
    String pName = '';
    if (json['product_id'] is List && (json['product_id'] as List).isNotEmpty) {
      pId = (json['product_id'] as List)[0] as int?;
      if ((json['product_id'] as List).length > 1) {
        pName = (json['product_id'] as List)[1]?.toString() ?? '';
      }
    } else if (json['product_id'] is int) {
      pId = json['product_id'] as int;
      pName = json['product_name']?.toString() ?? '';
    } else {
      pName = json['product_name']?.toString() ?? json['name']?.toString() ?? '';
    }

    int? id;
    if (json['id'] is num) {
      id = (json['id'] as num).toInt();
    }

    double qty = 0.0;
    final rawQty = json['product_uom_qty'] ?? json['quantity'] ?? json['qty'];
    if (rawQty is num) {
      qty = rawQty.toDouble();
    } else if (rawQty is String) {
      qty = double.tryParse(rawQty) ?? 0.0;
    }

    return DeliveryOrderLine(
      id: id,
      productId: pId,
      productName: pName,
      productCode: json['product_code']?.toString() ?? json['default_code']?.toString(),
      quantity: qty,
      uom: json['uom'] is List && (json['uom'] as List).length > 1
          ? (json['uom'] as List)[1]?.toString()
          : json['uom']?.toString(),
      priceUnit: (json['price_unit'] as num?)?.toDouble(),
      priceSubtotal: (json['price_subtotal'] as num?)?.toDouble(),
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (productId != null) 'product_id': productId,
        'product_name': productName,
        if (productCode != null) 'product_code': productCode,
        'quantity': quantity,
        if (uom != null) 'uom': uom,
        if (priceUnit != null) 'price_unit': priceUnit,
        if (priceSubtotal != null) 'price_subtotal': priceSubtotal,
        ...raw,
      };
}

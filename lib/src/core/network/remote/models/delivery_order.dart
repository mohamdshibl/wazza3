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
    this.vehicle,
    this.partnerId,
    this.partnerName,
    this.partnerPhone,
    this.partnerAddress,
    this.date,
    this.amountTotal,
    this.lines = const [],
    this.actions = const [],
    this.raw = const {},
  });

  final int id;
  final String name;
  final String? reference;
  final String? stage;
  final String? state;
  final String? finalStatus;
  final int? stopCount;
  final String? vehicle;
  final int? partnerId;
  final String? partnerName;
  final String? partnerPhone;
  final String? partnerAddress;
  final String? date;
  final double? amountTotal;
  final List<DeliveryOrderLine> lines;
  final List<String> actions;
  final Map<String, dynamic> raw;

  String get displayReference =>
      reference?.isNotEmpty == true ? reference! : (name.isNotEmpty ? name : 'DO-$id');

  factory DeliveryOrder.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const DeliveryOrder(id: 0, name: '');
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    List<DeliveryOrderLine> parsedLines = [];
    final rawLines = json['lines'] ?? json['order_lines'] ?? json['items'];
    if (rawLines is List) {
      for (final l in rawLines) {
        if (l is Map) {
          parsedLines.add(DeliveryOrderLine.fromJson(l));
        }
      }
    }

    List<String> parsedActions = [];
    final rawActions = json['actions'];
    if (rawActions is List) {
      parsedActions = rawActions.map((a) => a.toString()).toList();
    }

    // Parse partner info (could be [id, "Name"] tuple or separate fields)
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

    int id = 0;
    if (json['id'] is num) {
      id = (json['id'] as num).toInt();
    } else if (json['id'] is String) {
      id = int.tryParse(json['id'] as String) ?? 0;
    }

    int? stopCount;
    if (json['stop_count'] is num) {
      stopCount = (json['stop_count'] as num).toInt();
    } else if (json['stop_count'] is String) {
      stopCount = int.tryParse(json['stop_count'] as String);
    }

    double? total;
    final rawTotal = json['total_amount'] ?? json['amount_total'] ?? json['total'];
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal);
    }

    return DeliveryOrder(
      id: id,
      name: json['name']?.toString() ?? json['reference']?.toString() ?? json['order_number']?.toString() ?? '',
      reference: json['reference']?.toString(),
      stage: json['stage']?.toString(),
      state: json['state']?.toString() ?? json['final_status']?.toString(),
      finalStatus: json['final_status']?.toString(),
      stopCount: stopCount,
      vehicle: json['vehicle']?.toString(),
      partnerId: pId,
      partnerName: pName,
      partnerPhone: json['partner_phone']?.toString() ?? json['phone']?.toString(),
      partnerAddress: json['partner_address']?.toString() ?? json['address']?.toString(),
      date: json['date']?.toString() ?? json['scheduled_date']?.toString() ?? json['date_order']?.toString(),
      amountTotal: total,
      lines: parsedLines,
      actions: parsedActions,
      raw: json,
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
        if (vehicle != null) 'vehicle': vehicle,
        if (partnerId != null) 'partner_id': partnerId,
        if (partnerName != null) 'partner_name': partnerName,
        if (partnerPhone != null) 'partner_phone': partnerPhone,
        if (partnerAddress != null) 'partner_address': partnerAddress,
        if (date != null) 'date': date,
        if (amountTotal != null) 'amount_total': amountTotal,
        'lines': lines.map((l) => l.toJson()).toList(),
        'actions': actions,
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

/// Delivery Order model representing orders in get_home, get_order, and get_history.
class DeliveryOrder {
  const DeliveryOrder({
    required this.id,
    required this.name,
    this.stage,
    this.state,
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
  final String? stage;
  final String? state;
  final int? partnerId;
  final String? partnerName;
  final String? partnerPhone;
  final String? partnerAddress;
  final String? date;
  final double? amountTotal;
  final List<DeliveryOrderLine> lines;
  final List<String> actions;
  final Map<String, dynamic> raw;

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    List<DeliveryOrderLine> parsedLines = [];
    final rawLines = json['lines'] ?? json['order_lines'] ?? json['items'];
    if (rawLines is List) {
      parsedLines = rawLines
          .whereType<Map<String, dynamic>>()
          .map((l) => DeliveryOrderLine.fromJson(l))
          .toList();
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

    return DeliveryOrder(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? json['order_number']?.toString() ?? '',
      stage: json['stage']?.toString(),
      state: json['state']?.toString(),
      partnerId: pId,
      partnerName: pName,
      partnerPhone: json['partner_phone']?.toString() ?? json['phone']?.toString(),
      partnerAddress: json['partner_address']?.toString() ?? json['address']?.toString(),
      date: json['date']?.toString() ?? json['scheduled_date']?.toString() ?? json['date_order']?.toString(),
      amountTotal: (json['amount_total'] as num?)?.toDouble() ?? (json['total'] as num?)?.toDouble(),
      lines: parsedLines,
      actions: parsedActions,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (stage != null) 'stage': stage,
        if (state != null) 'state': state,
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

  factory DeliveryOrderLine.fromJson(Map<String, dynamic> json) {
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

    return DeliveryOrderLine(
      id: (json['id'] as num?)?.toInt(),
      productId: pId,
      productName: pName,
      productCode: json['product_code']?.toString() ?? json['default_code']?.toString(),
      quantity: (json['product_uom_qty'] as num?)?.toDouble() ??
          (json['quantity'] as num?)?.toDouble() ??
          (json['qty'] as num?)?.toDouble() ??
          0.0,
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

/// Data returned by `get_loaded_goods`.
class LoadedGoods {
  const LoadedGoods({
    this.doId,
    this.orderName,
    this.lines = const [],
    this.raw = const {},
  });

  final int? doId;
  final String? orderName;
  final List<LoadedGoodLine> lines;
  final Map<String, dynamic> raw;

  factory LoadedGoods.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      if (rawData is List) {
        return LoadedGoods(
          lines: rawData
              .whereType<Map>()
              .map((l) => LoadedGoodLine.fromJson(l))
              .toList(),
        );
      }
      return const LoadedGoods();
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    List<LoadedGoodLine> parsedLines = [];
    final rawLines = json['lines'] ?? json['goods'] ?? json['items'] ?? json['rows'] ?? json['data'];
    if (rawLines is List) {
      for (final l in rawLines) {
        if (l is Map) {
          parsedLines.add(LoadedGoodLine.fromJson(l));
        }
      }
    }

    return LoadedGoods(
      doId: (json['do_id'] as num?)?.toInt() ?? (json['id'] as num?)?.toInt(),
      orderName: json['order_name']?.toString() ?? json['name']?.toString() ?? json['reference']?.toString(),
      lines: parsedLines,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        if (doId != null) 'do_id': doId,
        if (orderName != null) 'order_name': orderName,
        'lines': lines.map((l) => l.toJson()).toList(),
        ...raw,
      };
}

class LoadedGoodLine {
  const LoadedGoodLine({
    this.id,
    this.productId,
    required this.productName,
    this.productCode,
    this.quantity = 0.0,
    this.uom,
    this.lotNumber,
    this.isConfirmed = false,
    this.raw = const {},
  });

  final int? id;
  final int? productId;
  final String productName;
  final String? productCode;
  final double quantity;
  final String? uom;
  final String? lotNumber;
  final bool isConfirmed;
  final Map<String, dynamic> raw;

  factory LoadedGoodLine.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const LoadedGoodLine(productName: '');
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

    return LoadedGoodLine(
      id: (json['id'] as num?)?.toInt(),
      productId: pId,
      productName: pName,
      productCode: json['product_code']?.toString() ?? json['default_code']?.toString(),
      quantity: (json['quantity'] as num?)?.toDouble() ??
          (json['qty'] as num?)?.toDouble() ??
          (json['product_uom_qty'] as num?)?.toDouble() ??
          0.0,
      uom: json['uom'] is List && (json['uom'] as List).length > 1
          ? (json['uom'] as List)[1]?.toString()
          : json['uom']?.toString(),
      lotNumber: json['lot_number']?.toString() ?? json['lot_id']?.toString(),
      isConfirmed: json['is_confirmed'] == true || json['confirmed'] == true,
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
        if (lotNumber != null) 'lot_number': lotNumber,
        'is_confirmed': isConfirmed,
        ...raw,
      };
}

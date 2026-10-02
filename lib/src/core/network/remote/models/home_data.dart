import 'delivery_order.dart';

/// Data returned by `get_home`.
class HomeData {
  const HomeData({
    this.hasCurrentOrder = false,
    this.current,
    this.unreadNotifications = 0,
    this.history = const [],
    this.raw = const {},
  });

  final bool hasCurrentOrder;
  final HomeCurrent? current;
  final int unreadNotifications;
  final List<DeliveryOrder> history;
  final Map<String, dynamic> raw;

  factory HomeData.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const HomeData();
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    final hasCurrent = json['has_current_order'] == true ||
        json['has_current_order'] == 1 ||
        json['has_current_order']?.toString().toLowerCase() == 'true';

    HomeCurrent? currentParsed;
    if (json['current'] is Map) {
      currentParsed = HomeCurrent.fromJson(json['current']);
    }

    int unread = 0;
    if (json['unread_notifications'] is num) {
      unread = (json['unread_notifications'] as num).toInt();
    } else if (json['unread_notifications'] is String) {
      unread = int.tryParse(json['unread_notifications'] as String) ?? 0;
    }

    List<DeliveryOrder> historyParsed = [];
    if (json['history'] is List) {
      for (final item in json['history'] as List) {
        if (item is Map) {
          historyParsed.add(DeliveryOrder.fromJson(item));
        }
      }
    }

    return HomeData(
      hasCurrentOrder: hasCurrent || currentParsed != null,
      current: currentParsed,
      unreadNotifications: unread,
      history: historyParsed,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'has_current_order': hasCurrentOrder,
        if (current != null) 'current': current!.toJson(),
        'unread_notifications': unreadNotifications,
        'history': history.map((h) => h.toJson()).toList(),
        ...raw,
      };
}

class HomeCurrent {
  const HomeCurrent({
    required this.order,
    this.stage,
    this.actions = const [],
    this.raw = const {},
  });

  final DeliveryOrder order;
  final String? stage;
  final List<String> actions;
  final Map<String, dynamic> raw;

  factory HomeCurrent.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return HomeCurrent(order: DeliveryOrder(id: 0, name: ''));
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    final orderData = json['order'] is Map ? json['order'] : json;

    List<String> parsedActions = [];
    if (json['actions'] is List) {
      parsedActions = (json['actions'] as List).map((a) => a.toString()).toList();
    } else if (orderData is Map && orderData['actions'] is List) {
      parsedActions = (orderData['actions'] as List).map((a) => a.toString()).toList();
    }

    return HomeCurrent(
      order: DeliveryOrder.fromJson(orderData),
      stage: json['stage']?.toString() ?? (orderData is Map ? orderData['stage']?.toString() : null),
      actions: parsedActions,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'order': order.toJson(),
        if (stage != null) 'stage': stage,
        'actions': actions,
        ...raw,
      };
}

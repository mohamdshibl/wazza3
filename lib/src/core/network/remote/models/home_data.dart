import 'delivery_order.dart';

/// Data returned by `get_home`.
class HomeData {
  const HomeData({
    this.current,
    this.history = const [],
    this.raw = const {},
  });

  final HomeCurrent? current;
  final List<DeliveryOrder> history;
  final Map<String, dynamic> raw;

  factory HomeData.fromJson(Map<String, dynamic> json) {
    HomeCurrent? currentParsed;
    if (json['current'] is Map<String, dynamic>) {
      currentParsed = HomeCurrent.fromJson(json['current'] as Map<String, dynamic>);
    }

    List<DeliveryOrder> historyParsed = [];
    if (json['history'] is List) {
      historyParsed = (json['history'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => DeliveryOrder.fromJson(item))
          .toList();
    }

    return HomeData(
      current: currentParsed,
      history: historyParsed,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        if (current != null) 'current': current!.toJson(),
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

  factory HomeCurrent.fromJson(Map<String, dynamic> json) {
    final orderJson = json['order'] is Map<String, dynamic>
        ? json['order'] as Map<String, dynamic>
        : json;

    List<String> parsedActions = [];
    if (json['actions'] is List) {
      parsedActions = (json['actions'] as List).map((a) => a.toString()).toList();
    } else if (orderJson['actions'] is List) {
      parsedActions = (orderJson['actions'] as List).map((a) => a.toString()).toList();
    }

    return HomeCurrent(
      order: DeliveryOrder.fromJson(orderJson),
      stage: json['stage']?.toString() ?? orderJson['stage']?.toString(),
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

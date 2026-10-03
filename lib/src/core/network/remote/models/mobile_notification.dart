/// Model for notifications returned by `get_notifications`.
class MobileNotification {
  const MobileNotification({
    required this.id,
    required this.event,
    required this.title,
    this.message,
    this.isRead = false,
    this.doId,
    this.createdAt,
    this.raw = const {},
  });

  final int id;
  final String event;
  final String title;
  final String? message;
  final bool isRead;
  final int? doId;
  final String? createdAt;
  final Map<String, dynamic> raw;

  factory MobileNotification.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const MobileNotification(id: 0, event: '', title: '');
    }
    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }
    return MobileNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      event: json['event']?.toString() ?? json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? json['event']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? json['body']?.toString() ?? json['description']?.toString(),
      isRead: json['is_read'] == true || json['read'] == true || json['state'] == 'read',
      doId: (json['do_id'] as num?)?.toInt() ?? (json['order_id'] as num?)?.toInt(),
      createdAt: json['create_date']?.toString() ?? json['created_at']?.toString() ?? json['date']?.toString(),
      raw: json,
    );
  }

  MobileNotification copyWith({
    int? id,
    String? event,
    String? title,
    String? message,
    bool? isRead,
    int? doId,
    String? createdAt,
    Map<String, dynamic>? raw,
  }) {
    return MobileNotification(
      id: id ?? this.id,
      event: event ?? this.event,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      doId: doId ?? this.doId,
      createdAt: createdAt ?? this.createdAt,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'event': event,
        'title': title,
        if (message != null) 'message': message,
        'is_read': isRead,
        if (doId != null) 'do_id': doId,
        if (createdAt != null) 'create_date': createdAt,
        ...raw,
      };
}

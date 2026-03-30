class NotificationModel {
  final String id;
  final String userId;
  final String sendBy;
  final String? transactionId;
  final String title;
  final String content;
  final String status;
  final String type;
  final String priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.sendBy,
    this.transactionId,
    required this.title,
    required this.content,
    required this.status,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return NotificationModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      userId: json['userId'] is String ? json['userId'] as String : '',
      sendBy: json['sendBy'] is String ? json['sendBy'] as String : '',
      transactionId: json['transactionId'] is String ? json['transactionId'] as String : null,
      title: json['title'] is String ? json['title'] as String : '',
      content: json['content'] is String ? json['content'] as String : '',
      status: json['status'] is String ? json['status'] as String : '',
      type: json['type'] is String ? json['type'] as String : '',
      priority: json['priority'] is String ? json['priority'] as String : '',
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
      v: json['__v'] is int ? json['__v'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'sendBy': sendBy,
    'transactionId': transactionId,
    'title': title,
    'content': content,
    'status': status,
    'type': type,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? sendBy,
    String? transactionId,
    String? title,
    String? content,
    String? status,
    String? type,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sendBy: sendBy ?? this.sendBy,
      transactionId: transactionId ?? this.transactionId,
      title: title ?? this.title,
      content: content ?? this.content,
      status: status ?? this.status,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  bool get isUnread => status == 'unread';
  bool get isRead => status == 'read';
  bool get isHighPriority => priority == 'high';
}
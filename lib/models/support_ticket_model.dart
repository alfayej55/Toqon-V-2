class SupportTicketModel {
  final String id;
  final String subject;
  final String description;
  final String status;
  final String priority;
  final String channel;
  final DateTime createdAt;
  final String? referenceNo;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.channel,
    required this.createdAt,
    this.referenceNo,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    final DateTime now = DateTime.now();
    return SupportTicketModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      subject: (json['subject'] ?? json['title'] ?? 'Support Request').toString(),
      description: (json['description'] ?? json['message'] ?? '').toString(),
      status: (json['status'] ?? 'open').toString(),
      priority: (json['priority'] ?? 'medium').toString(),
      channel: (json['channel'] ?? 'app').toString(),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? now,
      referenceNo: (json['referenceNo'] ?? json['ticketNo'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subject': subject,
      'description': description,
      'status': status,
      'priority': priority,
      'channel': channel,
      'createdAt': createdAt.toIso8601String(),
      'referenceNo': referenceNo,
    };
  }

  SupportTicketModel copyWith({
    String? id,
    String? subject,
    String? description,
    String? status,
    String? priority,
    String? channel,
    DateTime? createdAt,
    String? referenceNo,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      channel: channel ?? this.channel,
      createdAt: createdAt ?? this.createdAt,
      referenceNo: referenceNo ?? this.referenceNo,
    );
  }
}

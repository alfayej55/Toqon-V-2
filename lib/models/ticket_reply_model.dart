class TicketReplyModel {
  final String id;
  final String ticketId;
  final String message;
  final String senderType; // 'user' or 'support'
  final String? senderName;
  final DateTime createdAt;

  const TicketReplyModel({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.senderType,
    this.senderName,
    required this.createdAt,
  });

  factory TicketReplyModel.fromJson(Map<String, dynamic> json) {
    return TicketReplyModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      ticketId: (json['ticketId'] ?? json['ticket'] ?? '').toString(),
      message: (json['message'] ?? json['content'] ?? '').toString(),
      senderType: (json['senderType'] ?? json['sender'] ?? 'user').toString(),
      senderName: json['senderName']?.toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ticketId': ticketId,
      'message': message,
      'senderType': senderType,
      'senderName': senderName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isFromSupport => senderType.toLowerCase() == 'support' || senderType.toLowerCase() == 'admin';
  bool get isFromUser => !isFromSupport;
}
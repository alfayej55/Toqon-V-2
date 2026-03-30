class TicketReplyModel {
  final String id;
  final String message;
  final bool isAdminReply;
  final ReplyUser? user;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TicketReplyModel({
    required this.id,
    required this.message,
    required this.isAdminReply,
    this.user,
    required this.createdAt,
    this.updatedAt,
  });

  factory TicketReplyModel.fromJson(Map<String, dynamic> json) {
    return TicketReplyModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      isAdminReply: json['isAdminReply'] ?? false,
      user: json['user'] != null ? ReplyUser.fromJson(json['user']) : null,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'isAdminReply': isAdminReply,
      'user': user?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isFromSupport => isAdminReply;
  bool get isFromUser => !isAdminReply;
}

class ReplyUser {
  final String id;
  final String email;

  const ReplyUser({
    required this.id,
    required this.email,
  });

  factory ReplyUser.fromJson(Map<String, dynamic> json) {
    return ReplyUser(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
    };
  }
}

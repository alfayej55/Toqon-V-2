import 'package:car_care/models/profile_model.dart';

class MessageModel {
  final String id;
  final String conversation;
  final ProfileModel? sender;
  final ProfileModel? recipient;
  final String content;
  final List<String> attachments;
  final String messageType;
  final bool isRead;
  final bool delivered;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversation,
     this.sender,
     this.recipient,
    required this.content,
    required this.attachments,
    required this.messageType,
    required this.isRead,
    required this.delivered,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return MessageModel(
      id: json['id'] is String ? json['id'] as String : '',
      conversation: json['conversation'] is String ? json['conversation'] as String : '',
      sender: json['sender'] == null ? null : ProfileModel.fromJson(json['sender']),
      recipient: json['recipient'] == null ? null : ProfileModel.fromJson(json['recipient']),
      content: json['content'] is String ? json['content'] as String : '',
      attachments:
          json['attachments'] is List
              ? (json['attachments'] as List)
                  .map((x) => x is String ? x : '')
                  .where((x) => x.isNotEmpty)
                  .toList()
              : [],
      messageType: json['messageType'] is String ? json['messageType'] as String : 'text',
      isRead: json['isRead'] == true,
      delivered: json['delivered'] == true,
      createdAt:
          json['createdAt'] is String
              ? DateTime.tryParse(json['createdAt']) ?? now
              : now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversation,
      'sender': sender?.toJson(),
      'recipient': recipient?.toJson(),
      'content': content,
      'attachments': attachments,
      'messageType': messageType,
      'isRead': isRead,
      'delivered': delivered,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? conversation,
    ProfileModel? sender,
    ProfileModel? recipient,
    String? content,
    List<String>? attachments,
    String? messageType,
    bool? isRead,
    bool? delivered,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversation: conversation ?? this.conversation,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      delivered: delivered ?? this.delivered,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


import 'package:car_care/models/profile_model.dart';

class ConversationModel {
  final String id;
  final String lastMessage;
  final bool isGroup;
  final List<UserSettingsModel> userSettings;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileModel? chatPartner;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.isGroup,
    required this.lastMessage,
    required this.userSettings,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    required this.chatPartner,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return ConversationModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      lastMessage: json['lastMessage'] is String ? json['lastMessage'] as String : '',
      isGroup: json['isGroup'] == true,
      userSettings:
          json['userSettings'] is List
              ? (json['userSettings'] as List)
                  .map(
                    (x) =>
                        UserSettingsModel.fromJson(x as Map<String, dynamic>),
                  )
                  .toList()
              : [],
      lastMessageAt:
          json['lastMessageAt'] is String
              ? DateTime.tryParse(json['lastMessageAt']) ?? now
              : now,
      createdAt:
          json['createdAt'] is String
              ? DateTime.tryParse(json['createdAt']) ?? now
              : now,
      updatedAt:
          json['updatedAt'] is String
              ? DateTime.tryParse(json['updatedAt']) ?? now
              : now,
      chatPartner:
          json['chatPartner'] is Map<String, dynamic>
              ? ProfileModel.fromJson(
                json['chatPartner'] as Map<String, dynamic>,
              )
              : null,
      unreadCount: json['unreadCount'] is int ? json['unreadCount'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lastMessage': lastMessage,
      'isGroup': isGroup,
      'userSettings': userSettings.map((x) => x.toJson()).toList(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'chatPartner': chatPartner?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  ConversationModel copyWith({
    String? id,
    String? lastMessage,
    bool? isGroup,
    List<UserSettingsModel>? userSettings,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProfileModel? chatPartner,
    int? unreadCount,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      isGroup: isGroup ?? this.isGroup,
      userSettings: userSettings ?? this.userSettings,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chatPartner: chatPartner ?? this.chatPartner,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class UserSettingsModel {
  final String id;
  final String user;
  final bool isMuted;
  final bool isArchived;

  UserSettingsModel({
    required this.id,
    required this.user,
    required this.isMuted,
    required this.isArchived,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      user: json['user'] is String ? json['user'] as String : '',
      isMuted: json['isMuted'] == true,
      isArchived: json['isArchived'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'isMuted': isMuted,
      'isArchived': isArchived,
    };
  }

  UserSettingsModel copyWith({
    String? id,
    String? user,
    bool? isMuted,
    bool? isArchived,
  }) {
    return UserSettingsModel(
      id: id ?? this.id,
      user: user ?? this.user,
      isMuted: isMuted ?? this.isMuted,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

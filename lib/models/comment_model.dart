import 'package:car_care/models/profile_model.dart';

class CommentModel {
  final String id;
  final ProfileModel user;
  final String post;
  final String comment;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.user,
    required this.post,
    required this.comment,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return CommentModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      user: ProfileModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      post: json['post'] is String ? json['post'] as String : '',
      comment: json['comment'] is String ? json['comment'] as String : '',
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'post': post,
      'comment': comment,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CommentModel copyWith({
    String? id,
    ProfileModel? user,
    String? post,
    String? comment,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      user: user ?? this.user,
      post: post ?? this.post,
      comment: comment ?? this.comment,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class PrivacyModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  PrivacyModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return PrivacyModel(
      id: json['_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
      v: json['__v'] is int ? json['__v'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  PrivacyModel copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PrivacyModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
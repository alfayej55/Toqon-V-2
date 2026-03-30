class MoreEarnModel {
  final String id;
  final String typeName;
  final String description;
  final int pointsValue;
  final String image;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoreEarnModel({
    required this.id,
    required this.typeName,
    required this.description,
    required this.pointsValue,
    required this.image,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MoreEarnModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return MoreEarnModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      typeName: json['typeName'] is String ? json['typeName'] as String : '',
      description: json['description'] is String ? json['description'] as String : '',
      pointsValue: json['pointsValue'] is int ? json['pointsValue'] as int : 0,
      image: json['image'] is String ? json['image'] as String : '',
      displayOrder: json['displayOrder'] is int ? json['displayOrder'] as int : 0,
      isActive: json['isActive'] is bool ? json['isActive'] as bool : false,
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
      'typeName': typeName,
      'description': description,
      'pointsValue': pointsValue,
      'image': image,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MoreEarnModel copyWith({
    String? id,
    String? typeName,
    String? description,
    int? pointsValue,
    String? image,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoreEarnModel(
      id: id ?? this.id,
      typeName: typeName ?? this.typeName,
      description: description ?? this.description,
      pointsValue: pointsValue ?? this.pointsValue,
      image: image ?? this.image,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
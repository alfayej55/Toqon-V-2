class CategoryModel {
  final String id;
  final String categoryName;
  final String categoryType;
  final String categoryDescription;
  final String categoryImage;
  final bool isActive;
  final bool isDeleted;
  final bool isPopular;
  final bool isEmergency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int nearbyServiceCount;
  final String averageRating;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryType,
    required this.categoryDescription,
    required this.categoryImage,
    required this.isActive,
    required this.isDeleted,
    required this.isPopular,
    required this.isEmergency,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.nearbyServiceCount,
    required this.averageRating,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return CategoryModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      categoryName: json['categoryName'] is String ? json['categoryName'] as String : '',
      categoryType: json['categoryType'] is String ? json['categoryType'] as String : '',
      categoryDescription: json['categoryDescription'] is String ? json['categoryDescription'] as String : '',
      categoryImage: json['categoryImage'] is String ? json['categoryImage'] as String : '',
      isActive: json['isActive'] == true,
      isDeleted: json['isDeleted'] == true,
      isPopular: json['isPopuler'] == true,
      isEmergency: json['isEmergency'] == true,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
      v: json['__v'] is int ? json['__v'] as int : 0,
      nearbyServiceCount: json['nearbyServiceCount'] is int ? json['nearbyServiceCount'] as int : 0,
      averageRating: json['averageRating'] is String ? json['averageRating'] as String : "0.0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'categoryType': categoryType,
      'categoryDescription': categoryDescription,
      'categoryImage': categoryImage,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'isPopuler': isPopular,
      'isEmergency': isEmergency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'nearbyServiceCount': nearbyServiceCount,
      'averageRating': averageRating,
    };
  }

}

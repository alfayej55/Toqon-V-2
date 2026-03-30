import 'catagori_model.dart';

class RedeemModel {
  final String id;
  final CategoryModel? category;
  final int requiredPoints;
  final int requiredVisits;
  final int pointsPerVisit;
  final String description;
  final bool isActive;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int userPoints;
  final int userCompletedVisits;
  final bool hasEnoughPoints;
  final bool hasEnoughVisits;
  final bool canRedeem;

  RedeemModel({
    required this.id,
    this.category,
    required this.requiredPoints,
    required this.requiredVisits,
    required this.pointsPerVisit,
    required this.description,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    required this.userPoints,
    required this.userCompletedVisits,
    required this.hasEnoughPoints,
    required this.hasEnoughVisits,
    required this.canRedeem,
  });

  factory RedeemModel.fromJson(Map<String, dynamic> json) {
    return RedeemModel(
      id: json['_id'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      requiredPoints: json['requiredPoints'] ?? 0,
      requiredVisits: json['requiredVisits'] ?? 0,
      pointsPerVisit: json['pointsPerVisit'] ?? 0,
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      userPoints: json['userPoints'] ?? 0,
      userCompletedVisits: json['userCompletedVisits'] ?? 0,
      hasEnoughPoints: json['hasEnoughPoints'] ?? false,
      hasEnoughVisits: json['hasEnoughVisits'] ?? false,
      canRedeem: json['canRedeem'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category?.toJson(),
      'requiredPoints': requiredPoints,
      'requiredVisits': requiredVisits,
      'pointsPerVisit': pointsPerVisit,
      'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userPoints': userPoints,
      'userCompletedVisits': userCompletedVisits,
      'hasEnoughPoints': hasEnoughPoints,
      'hasEnoughVisits': hasEnoughVisits,
      'canRedeem': canRedeem,
    };
  }
}
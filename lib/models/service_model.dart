import 'package:car_care/models/catagori_model.dart';
import 'package:car_care/models/profile_model.dart';

class ServiceModel {
  final String id;
  final ProfileModel? serviceprovider;
  final String serviceName;
  final CategoryModel? serviceCategory;
  final dynamic serviceStartingPrice;
  final dynamic servicePrice;
  final int serviceDuration;
  final String serviceDetails;
  final List<ServiceImage> serviceImage;
  final bool availability;
  final dynamic discount;
  final bool isOfferOpne;
  final String serviceStatus;
  final bool isDeleted;
  final bool isFixedPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final double weightedScore;
  final double averageRating;
  final dynamic distance;
  final dynamic distanceInKm;
  final ProfileModel? garageProfile;

  ServiceModel({
    required this.id,
    this.serviceprovider,
    required this.serviceName,
    this.serviceCategory,
    required this.serviceStartingPrice,
    required this.servicePrice,
    required this.serviceDuration,
    required this.serviceDetails,
    required this.serviceImage,
    required this.availability,
    required this.discount,
    required this.isOfferOpne,
    required this.serviceStatus,
    required this.isDeleted,
    required this.isFixedPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.weightedScore,
    required this.averageRating,
    required this.distance,
    required this.distanceInKm,
    this.garageProfile,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return ServiceModel(
      id: json["id"] is String ? json["id"] as String : '',
      serviceprovider: json["serviceprovider"] is Map<String, dynamic> ? ProfileModel.fromJson(json["serviceprovider"] as Map<String, dynamic>) : null,
      serviceName: json["serviceName"] is String ? json["serviceName"] as String : '',
      serviceCategory: json["serviceCategory"] is Map<String, dynamic> ? CategoryModel.fromJson(json["serviceCategory"] as Map<String, dynamic>) : null,
      serviceStartingPrice: json["serviceStartingPrice"] is int ? json["serviceStartingPrice"] as int : 0,
      servicePrice: json["servicePrice"] is int ? json["servicePrice"] as int : 0,
      serviceDuration: json["serviceDuration"] is int ? json["serviceDuration"] as int : 0,
      serviceDetails: json["serviceDetails"] is String ? json["serviceDetails"] as String : '',
      serviceImage: json["serviceImage"] is List ? List<ServiceImage>.from((json["serviceImage"] as List).map((x) => ServiceImage.fromJson(x as Map<String, dynamic>))) : const [],
      availability: json["availability"] == true,
      discount: json["discount"] is int ? json["discount"] as int : 0,
      isOfferOpne: json["isOfferOpne"] == true,
      serviceStatus: json["serviceStatus"] is String ? json["serviceStatus"] as String : '',
      isDeleted: json["isDeleted"] == true,
      isFixedPrice: json["isFixedPrice"] == true,
      createdAt: json["createdAt"] is String ? DateTime.tryParse(json["createdAt"]) ?? now : now,
      updatedAt: json["updatedAt"] is String ? DateTime.tryParse(json["updatedAt"]) ?? now : now,
      v: json["__v"] is int ? json["__v"] as int : 0,
      weightedScore: json["weightedScore"] is num ? (json["weightedScore"] as num).toDouble() : 0.0,
      averageRating: json["averageRating"] is num ? (json["averageRating"] as num).toDouble() : 0.0,
      distance: json["distance"] is int ? json["distance"] as int : 0,
      distanceInKm: json["distanceInKm"] is int ? json["distanceInKm"] as int : 0,
      garageProfile: json["garageProfile"] is Map<String, dynamic> ? ProfileModel.fromJson(json["garageProfile"] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "serviceprovider": serviceprovider?.toJson(),
    "serviceName": serviceName,
    "serviceCategory": serviceCategory?.toJson(),
    "serviceStartingPrice": serviceStartingPrice,
    "servicePrice": servicePrice,
    "serviceDuration": serviceDuration,
    "serviceDetails": serviceDetails,
    "serviceImage": List<dynamic>.from(serviceImage.map((x) => x.toJson())),
    "availability": availability,
    "discount": discount,
    "isOfferOpne": isOfferOpne,
    "serviceStatus": serviceStatus,
    "isDeleted": isDeleted,
    "isFixedPrice": isFixedPrice,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "weightedScore": weightedScore,
    "averageRating": averageRating,
    "distance": distance,
    "distanceInKm": distanceInKm,
    "garageProfile": garageProfile?.toJson(),
  };

  ServiceModel copyWith({
    String? id,
    ProfileModel? serviceprovider,
    String? serviceName,
    CategoryModel? serviceCategory,
    int? serviceStartingPrice,
    int? servicePrice,
    int? serviceDuration,
    String? serviceDetails,
    List<ServiceImage>? serviceImage,
    bool? availability,
    int? discount,
    bool? isOfferOpne,
    String? serviceStatus,
    bool? isDeleted,
    bool? isFixedPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    double? weightedScore,
    double? averageRating,
    int? distance,
    int? distanceInKm,
    ProfileModel? garageProfile,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      serviceprovider: serviceprovider ?? this.serviceprovider,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceStartingPrice: serviceStartingPrice ?? this.serviceStartingPrice,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      serviceImage: serviceImage ?? this.serviceImage,
      availability: availability ?? this.availability,
      discount: discount ?? this.discount,
      isOfferOpne: isOfferOpne ?? this.isOfferOpne,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      isFixedPrice: isFixedPrice ?? this.isFixedPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      weightedScore: weightedScore ?? this.weightedScore,
      averageRating: averageRating ?? this.averageRating,
      distance: distance ?? this.distance,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      garageProfile: garageProfile ?? this.garageProfile,
    );
  }
}
class ServiceImage {
  final String url;
  final String id;

  ServiceImage({
    required this.url,
    required this.id,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      url: json["url"] is String ? json["url"] as String : '',
      id: json["_id"] is String ? json["_id"] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "_id": id,
  };

  ServiceImage copyWith({
    String? url,
    String? id,
  }) {
    return ServiceImage(
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}

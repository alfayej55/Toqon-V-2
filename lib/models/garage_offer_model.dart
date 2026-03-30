class GarageOfferModel {
  final String id;
  final String postCommunity;
  final OfferSender? offerSender;
  final String offerService;
  final int offerPrice;
  final String postOfferDescription;
  final bool isOfferAccepted;
  final bool isDelete;
  final DateTime createdAt;
  final DateTime updatedAt;

  GarageOfferModel({
    required this.id,
    required this.postCommunity,
    this.offerSender,
    required this.offerService,
    required this.offerPrice,
    required this.postOfferDescription,
    required this.isOfferAccepted,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GarageOfferModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return GarageOfferModel(
      id: json["_id"] is String ? json["_id"] as String : '',
      postCommunity: json["postCommunity"] is String ? json["postCommunity"] as String : '',
      offerSender: json["offerSender"] is Map<String, dynamic> ? OfferSender.fromJson(json["offerSender"] as Map<String, dynamic>) : null,
      offerService: json["offerService"] is String ? json["offerService"] as String : '',
      offerPrice: json["offerPrice"] is int ? json["offerPrice"] as int : 0,
      postOfferDescription: json["postOfferDescription"] is String ? json["postOfferDescription"] as String : '',
      isOfferAccepted: json["isOfferAccepted"] == true,
      isDelete: json["isDelete"] == true,
      createdAt: json["createdAt"] is String ? DateTime.tryParse(json["createdAt"]) ?? now : now,
      updatedAt: json["updatedAt"] is String ? DateTime.tryParse(json["updatedAt"]) ?? now : now,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "postCommunity": postCommunity,
    "offerSender": offerSender?.toJson(),
    "offerService": offerService,
    "offerPrice": offerPrice,
    "postOfferDescription": postOfferDescription,
    "isOfferAccepted": isOfferAccepted,
    "isDelete": isDelete,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  GarageOfferModel copyWith({
    String? id,
    String? postCommunity,
    OfferSender? offerSender,
    String? offerService,
    int? offerPrice,
    String? postOfferDescription,
    bool? isOfferAccepted,
    bool? isDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GarageOfferModel(
      id: id ?? this.id,
      postCommunity: postCommunity ?? this.postCommunity,
      offerSender: offerSender ?? this.offerSender,
      offerService: offerService ?? this.offerService,
      offerPrice: offerPrice ?? this.offerPrice,
      postOfferDescription: postOfferDescription ?? this.postOfferDescription,
      isOfferAccepted: isOfferAccepted ?? this.isOfferAccepted,
      isDelete: isDelete ?? this.isDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OfferSender {
  final String id;
  final String fullName;
  final String email;
  final String image;
  final String phoneNumber;

  final SenderGarageProfile? garageProfile;
  final String address;

  OfferSender({
    required this.id,
    required this.fullName,
    required this.email,
    required this.image,
    required this.phoneNumber,
    this.garageProfile,
    required this.address,
  });

  factory OfferSender.fromJson(Map<String, dynamic> json) {
    return OfferSender(
      id: json["id"] is String ? json["id"] as String : '',
      fullName: json["fullName"] is String ? json["fullName"] as String : '',
      email: json["email"] is String ? json["email"] as String : '',
      image: json["image"] is String ? json["image"] as String : '',
      phoneNumber: json["phoneNumber"] is String ? json["phoneNumber"] as String : '',
      garageProfile: json["garageProfile"] is Map<String, dynamic> ? SenderGarageProfile.fromJson(json["garageProfile"] as Map<String, dynamic>) : null,
      address: json["address"] is String ? json["address"] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "image": image,
    "phoneNumber": phoneNumber,
    "garageProfile": garageProfile?.toJson(),
    "address": address,
  };

  OfferSender copyWith({
    String? id,
    String? fullName,
    String? email,
    String? image,
    String? phoneNumber,
    SenderGarageProfile? garageProfile,
    String? address,
  }) {
    return OfferSender(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      garageProfile: garageProfile ?? this.garageProfile,
      address: address ?? this.address,
    );
  }
}

class SenderGarageProfile {
  final String id;
  final int reviewCount;
  final double averageRating;
  final bool isApproved;
  final int totalRatingSum;

  SenderGarageProfile({
    required this.id,
    this.isApproved=false,
    required this.reviewCount,
    required this.averageRating,
    required this.totalRatingSum,
  });

  factory SenderGarageProfile.fromJson(Map<String, dynamic> json) {
    return SenderGarageProfile(
      id: json["_id"] is String ? json["_id"] as String : '',
      reviewCount: json["reviewCount"] is int ? json["reviewCount"] as int : 0,
      isApproved: json["isApproved"] ,
      averageRating: json["averageRating"] is num ? (json["averageRating"] as num).toDouble() : 0.0,
      totalRatingSum: json["totalRatingSum"] is int ? json["totalRatingSum"] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "reviewCount": reviewCount,
    "isApproved": isApproved,
    "averageRating": averageRating,
    "totalRatingSum": totalRatingSum,
  };

  SenderGarageProfile copyWith({
    String? id,
    int? reviewCount,
    double? averageRating,
    int? totalRatingSum,
  }) {
    return SenderGarageProfile(
      id: id ?? this.id,
      reviewCount: reviewCount ?? this.reviewCount,
      averageRating: averageRating ?? this.averageRating,
      totalRatingSum: totalRatingSum ?? this.totalRatingSum,
    );
  }
}
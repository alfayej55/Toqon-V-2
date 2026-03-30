import 'package:car_care/models/service_model.dart';

class GarageProfile {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String authProvider;
  final String googleId;
  final String image;
  final String role;
  final String callingCode;
  final String phoneNumber;
  final int myWallet;
  final int mySaving;
  final DateTime dateOfBirth;
  final String address;
  final GarageLocation myLocation;
  final GarageProfileDetails? garageProfile;
  final bool isEmailVerified;
  final bool isGarageAproved;
  final bool isMacanicAproved;
  final bool isProfileCompleted;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<ServiceModel> services;
  final List<dynamic> activeOffers;

  GarageProfile({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.authProvider,
    required this.googleId,
    required this.image,
    required this.role,
    required this.callingCode,
    required this.phoneNumber,
    required this.myWallet,
    required this.mySaving,
    required this.dateOfBirth,
    required this.address,
    required this.myLocation,
    this.garageProfile,
    required this.isEmailVerified,
    required this.isGarageAproved,
    required this.isMacanicAproved,
    required this.isProfileCompleted,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.services,
    required this.activeOffers,
  });

  factory GarageProfile.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return GarageProfile(
      id: json["_id"] is String ? json["_id"] as String : '',
      fullName: json["fullName"] is String ? json["fullName"] as String : '',
      userName: json["userName"] is String ? json["userName"] as String : '',
      email: json["email"] is String ? json["email"] as String : '',
      authProvider: json["authProvider"] is String ? json["authProvider"] as String : '',
      googleId: json["googleId"]?.toString() ?? '',
      image: json["image"] is String ? json["image"] as String : '',
      role: json["role"] is String ? json["role"] as String : '',
      callingCode: json["callingCode"] is String ? json["callingCode"] as String : '',
      phoneNumber: json["phoneNumber"] is String ? json["phoneNumber"] as String : '',
      myWallet: json["myWallet"] is int ? json["myWallet"] as int : 0,
      mySaving: json["mySaving"] is int ? json["mySaving"] as int : 0,
      dateOfBirth: json["dateOfBirth"] is String
          ? DateTime.tryParse(json["dateOfBirth"]) ?? now
          : now,
      address: json["address"] is String ? json["address"] as String : '',
      myLocation: json["myLocation"] is Map<String, dynamic>
          ? GarageLocation.fromJson(json["myLocation"] as Map<String, dynamic>)
          : GarageLocation(type: 'Point', coordinates: const [0.0, 0.0]),
      garageProfile: json["garageProfile"] is Map<String, dynamic>
          ? GarageProfileDetails.fromJson(json["garageProfile"] as Map<String, dynamic>)
          : null,
      isEmailVerified: json["isEmailVerified"] == true,
      isGarageAproved: json["isGarageAproved"] == true,
      isMacanicAproved: json["isMacanicAproved"] == true,
      isProfileCompleted: json["isProfileCompleted"] == true,
      isDeleted: json["isDeleted"] == true,
      createdAt: json["createdAt"] is String
          ? DateTime.tryParse(json["createdAt"]) ?? now
          : now,
      updatedAt: json["updatedAt"] is String
          ? DateTime.tryParse(json["updatedAt"]) ?? now
          : now,
      v: json["__v"] is int ? json["__v"] as int : 0,
      services: json["services"] is List
          ? List<ServiceModel>.from((json["services"] as List)
              .map((x) => ServiceModel.fromJson(x as Map<String, dynamic>)))
          : const [],
      activeOffers: json["activeOffers"] is List
          ? List<dynamic>.from(json["activeOffers"] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "userName": userName,
    "email": email,
    "authProvider": authProvider,
    "googleId": googleId,
    "image": image,
    "role": role,
    "callingCode": callingCode,
    "phoneNumber": phoneNumber,
    "myWallet": myWallet,
    "mySaving": mySaving,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "address": address,
    "myLocation": myLocation.toJson(),
    "garageProfile": garageProfile?.toJson(),
    "isEmailVerified": isEmailVerified,
    "isGarageAproved": isGarageAproved,
    "isMacanicAproved": isMacanicAproved,
    "isProfileCompleted": isProfileCompleted,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "activeOffers": List<dynamic>.from(activeOffers.map((x) => x)),
  };



  // Helper getters for accessing nested garageProfile data

  List<OpeningHour> get openingHours => garageProfile?.openingHours ?? [];
  int get averageRating => garageProfile?.averageRating ?? 0;
  int get reviewCount => garageProfile?.reviewCount ?? 0;
  int get totalRatingSum => garageProfile?.totalRatingSum ?? 0;
}

// Nested garage profile details
class GarageProfileDetails {
  final String id;
  final int reviewCount;
  final int averageRating;
  final int totalRatingSum;
  final List<OpeningHour> openingHours;

  GarageProfileDetails({
    required this.id,
    required this.reviewCount,
    required this.averageRating,
    required this.totalRatingSum,
    required this.openingHours,
  });

  factory GarageProfileDetails.fromJson(Map<String, dynamic> json) {
    return GarageProfileDetails(
      id: json["_id"] is String ? json["_id"] as String : '',
      reviewCount: json["reviewCount"] is int ? json["reviewCount"] as int : 0,
      averageRating: json["averageRating"] is int ? json["averageRating"] as int : 0,
      totalRatingSum: json["totalRatingSum"] is int ? json["totalRatingSum"] as int : 0,
      openingHours: json["openingHours"] is List
          ? List<OpeningHour>.from((json["openingHours"] as List)
              .map((x) => OpeningHour.fromJson(x as Map<String, dynamic>)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "reviewCount": reviewCount,
    "averageRating": averageRating,
    "totalRatingSum": totalRatingSum,
    "openingHours": List<dynamic>.from(openingHours.map((x) => x.toJson())),
  };

  GarageProfileDetails copyWith({
    String? id,
    int? reviewCount,
    int? averageRating,
    int? totalRatingSum,
    List<OpeningHour>? openingHours,
  }) {
    return GarageProfileDetails(
      id: id ?? this.id,
      reviewCount: reviewCount ?? this.reviewCount,
      averageRating: averageRating ?? this.averageRating,
      totalRatingSum: totalRatingSum ?? this.totalRatingSum,
      openingHours: openingHours ?? this.openingHours,
    );
  }
}

class GarageLocation {
  final String type;
  final List<double> coordinates;

  GarageLocation({
    required this.type,
    required this.coordinates,
  });

  factory GarageLocation.fromJson(Map<String, dynamic> json) {
    return GarageLocation(
      type: json["type"] is String ? json["type"] as String : 'Point',
      coordinates: json["coordinates"] is List && json["coordinates"].length >= 2
          ? List<double>.from((json["coordinates"] as List).map((x) => (x as num).toDouble()))
          : const [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };

  GarageLocation copyWith({
    String? type,
    List<double>? coordinates,
  }) {
    return GarageLocation(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

class OpeningHour {
  final String day;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final String id;

  OpeningHour({
    required this.day,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    required this.id,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      day: json["day"] is String ? json["day"] as String : '',
      isOpen: json["isOpen"] == true,
      openTime: json["openTime"]?.toString() ?? '',
      closeTime: json["closeTime"]?.toString() ?? '',
      id: json["_id"] is String ? json["_id"] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
    "day": day,
    "isOpen": isOpen,
    "openTime": openTime,
    "closeTime": closeTime,
    "_id": id,
  };

  OpeningHour copyWith({
    String? day,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    String? id,
  }) {
    return OpeningHour(
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      id: id ?? this.id,
    );
  }
}
class ProfileModel {
  final MyLocation myLocation;
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
  final DateTime oneTimeCodeExpiry;
  final bool isGarageAproved;
  final bool isMacanicAproved;
  final bool isVerified;
  final bool isProfileCompleted;
  final DateTime createdAt;
  final String stripeCustomerId;
  final String id;

  ProfileModel({
    required this.myLocation,
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
    required this.oneTimeCodeExpiry,
    required this.isGarageAproved,
    required this.isMacanicAproved,
    required this.isVerified,
    required this.isProfileCompleted,
    required this.createdAt,
    required this.stripeCustomerId,
    required this.id,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return ProfileModel(
      myLocation: MyLocation.fromJson(
        json['myLocation'] as Map<String, dynamic>?,
      ),
      fullName: json['fullName'] is String ? json['fullName'] as String : '',
      userName: json['userName'] is String ? json['userName'] as String : '',
      email: json['email'] is String ? json['email'] as String : '',
      authProvider:
          json['authProvider'] is String ? json['authProvider'] as String : '',
      googleId: json['googleId'] is String ? json['googleId'] as String : '',
      image: json['image'] is String ? json['image'] as String : '',
      role: json['role'] is String ? json['role'] as String : '',
      callingCode:
          json['callingCode'] is String ? json['callingCode'] as String : '',
      phoneNumber:
          json['phoneNumber'] is String ? json['phoneNumber'] as String : '',
      myWallet: json['myWallet'] is int ? json['myWallet'] as int : 0,
      mySaving: json['mySaving'] is int ? json['mySaving'] as int : 0,
      dateOfBirth:
          json['dateOfBirth'] is String
              ? DateTime.tryParse(json['dateOfBirth']) ?? now
              : now,
      address: json['address'] is String ? json['address'] as String : '',
      oneTimeCodeExpiry:
          json['oneTimeCodeExpiry'] is String
              ? DateTime.tryParse(json['oneTimeCodeExpiry']) ?? now
              : now,
      isGarageAproved: json['isGarageAproved'] == true,
      isMacanicAproved: json['isMacanicAproved'] == true,
      isVerified:
          json['isVerified'] == true ||
          json['isGarageAproved'] == true ||
          json['isMacanicAproved'] == true,
      isProfileCompleted: json['isProfileCompleted'] == true,
      createdAt:
          json['createdAt'] is String
              ? DateTime.tryParse(json['createdAt']) ?? now
              : now,
      stripeCustomerId:
          json['stripeCustomerId'] is String
              ? json['stripeCustomerId'] as String
              : '',
      id: json['id'] is String ? json['id'] as String : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myLocation': myLocation.toJson(),
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'authProvider': authProvider,
      'googleId': googleId,
      'image': image,
      'role': role,
      'callingCode': callingCode,
      'phoneNumber': phoneNumber,
      'myWallet': myWallet,
      'mySaving': mySaving,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'oneTimeCodeExpiry': oneTimeCodeExpiry.toIso8601String(),
      'isGarageAproved': isGarageAproved,
      'isMacanicAproved': isMacanicAproved,
      'isVerified': isVerified,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': createdAt.toIso8601String(),
      'stripeCustomerId': stripeCustomerId,
      'id': id,
    };
  }

  ProfileModel copyWith({
    MyLocation? myLocation,
    String? fullName,
    String? userName,
    String? email,
    String? authProvider,
    String? googleId,
    String? image,
    String? role,
    String? callingCode,
    String? phoneNumber,
    int? myWallet,
    Map<String, dynamic>? garageProfile,
    Map<String, dynamic>? mechanicProfile,
    int? mySaving,
    DateTime? dateOfBirth,
    String? address,
    DateTime? oneTimeCodeExpiry,
    bool? isGarageAproved,
    bool? isMacanicAproved,
    bool? isVerified,
    bool? isProfileCompleted,
    DateTime? createdAt,
    String? stripeCustomerId,
    String? id,
  }) {
    return ProfileModel(
      myLocation: myLocation ?? this.myLocation,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      authProvider: authProvider ?? this.authProvider,
      googleId: googleId ?? this.googleId,
      image: image ?? this.image,
      role: role ?? this.role,
      callingCode: callingCode ?? this.callingCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      myWallet: myWallet ?? this.myWallet,
      mySaving: mySaving ?? this.mySaving,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      oneTimeCodeExpiry: oneTimeCodeExpiry ?? this.oneTimeCodeExpiry,
      isGarageAproved: isGarageAproved ?? this.isGarageAproved,
      isMacanicAproved: isMacanicAproved ?? this.isMacanicAproved,
      isVerified: isVerified ?? this.isVerified,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      createdAt: createdAt ?? this.createdAt,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      id: id ?? this.id,
    );
  }
}

class MyLocation {
  final String type;
  final List<double> coordinates;

  MyLocation({required this.type, required this.coordinates});

  factory MyLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MyLocation(type: 'Point', coordinates: const [0.0, 0.0]);
    }

    String parsedType = 'Point';
    List<double> parsedCoords = [0.0, 0.0];

    if (json['type'] is String) {
      parsedType = json['type'] as String;
    }

    if (json['coordinates'] is List && json['coordinates'].length >= 2) {
      final list = json['coordinates'] as List;
      final lon = (list[0] is num) ? (list[0] as num).toDouble() : 0.0;
      final lat = (list[1] is num) ? (list[1] as num).toDouble() : 0.0;
      parsedCoords = [lon, lat];
    }

    return MyLocation(type: parsedType, coordinates: parsedCoords);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  MyLocation copyWith({String? type, List<double>? coordinates}) {
    return MyLocation(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

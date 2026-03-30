
import 'package:car_care/models/profile_model.dart';
import 'package:car_care/models/service_model.dart';

class BookingModel {
  final String id;
  final ProfileModel? user;
  final ProfileModel? garage;
  final ServiceModel? service;
  final BookingVehicle? vehicle;
  final int servicePrice;
  final int discount;
  final int discountAmount;
  final int taxAmount;
  final int totalAmount;
  final String bookingType;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String? assignedMechanic;
  final String? cancellationReason;
  final String? cancelledBy;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  BookingModel({
    required this.id,
    this.user,
    this.garage,
    this.service,
    this.vehicle,
    required this.servicePrice,
    required this.discount,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.bookingType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.assignedMechanic,
    this.cancellationReason,
    this.cancelledBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return BookingModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      user: json['user'] is Map<String, dynamic>
          ? ProfileModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      garage: json['garage'] is Map<String, dynamic>
          ? ProfileModel.fromJson(json['garage'] as Map<String, dynamic>)
          : null,
      service: json['service'] is Map<String, dynamic>
          ? ServiceModel.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] is Map<String, dynamic>
          ? BookingVehicle.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      servicePrice: json['servicePrice'] is int ? json['servicePrice'] as int : 0,
      discount: json['discount'] is int ? json['discount'] as int : 0,
      discountAmount: json['discountAmount'] is int ? json['discountAmount'] as int : 0,
      taxAmount: json['taxAmount'] is int ? json['taxAmount'] as int : 0,
      totalAmount: json['totalAmount'] is int ? json['totalAmount'] as int : 0,
      bookingType: json['bookingType'] is String ? json['bookingType'] as String : '',
      scheduledDate: json['scheduledDate'] is String
          ? DateTime.tryParse(json['scheduledDate']) ?? now
          : now,
      scheduledTime: json['scheduledTime'] is String ? json['scheduledTime'] as String : '',
      status: json['status'] is String ? json['status'] as String : '',
      paymentStatus: json['paymentStatus'] is String ? json['paymentStatus'] as String : '',
      paymentMethod: json['paymentMethod'] is String ? json['paymentMethod'] as String : '',
      assignedMechanic: json['assignedMechanic'] is String ? json['assignedMechanic'] as String : null,
      cancellationReason: json['cancellationReason'] is String ? json['cancellationReason'] as String : null,
      cancelledBy: json['cancelledBy'] is String ? json['cancelledBy'] as String : null,
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
      v: json['__v'] is int ? json['__v'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user?.toJson(),
    'garage': garage?.toJson(),
    'service': service?.toJson(),
    'vehicle': vehicle?.toJson(),
    'servicePrice': servicePrice,
    'discount': discount,
    'discountAmount': discountAmount,
    'taxAmount': taxAmount,
    'totalAmount': totalAmount,
    'bookingType': bookingType,
    'scheduledDate': scheduledDate.toIso8601String(),
    'scheduledTime': scheduledTime,
    'status': status,
    'paymentStatus': paymentStatus,
    'paymentMethod': paymentMethod,
    'assignedMechanic': assignedMechanic,
    'cancellationReason': cancellationReason,
    'cancelledBy': cancelledBy,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };

  BookingModel copyWith({
    String? id,
    ProfileModel? user,
    ProfileModel? garage,
    ServiceModel? service,
    BookingVehicle? vehicle,
    int? servicePrice,
    int? discount,
    int? discountAmount,
    int? taxAmount,
    int? totalAmount,
    String? bookingType,
    DateTime? scheduledDate,
    String? scheduledTime,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? assignedMechanic,
    String? cancellationReason,
    String? cancelledBy,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return BookingModel(
      id: id ?? this.id,
      user: user ?? this.user,
      garage: garage ?? this.garage,
      service: service ?? this.service,
      vehicle: vehicle ?? this.vehicle,
      servicePrice: servicePrice ?? this.servicePrice,
      discount: discount ?? this.discount,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      bookingType: bookingType ?? this.bookingType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      assignedMechanic: assignedMechanic ?? this.assignedMechanic,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}

class BookingServiceImage {
  final String url;
  final String id;

  BookingServiceImage({
    required this.url,
    required this.id,
  });

  factory BookingServiceImage.fromJson(Map<String, dynamic> json) {
    return BookingServiceImage(
      url: json['url'] is String ? json['url'] as String : '',
      id: json['_id'] is String ? json['_id'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    '_id': id,
  };

  BookingServiceImage copyWith({
    String? url,
    String? id,
  }) {
    return BookingServiceImage(
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}

class BookingVehicle {
  final String id;
  final String user;
  final String vehicleName;
  final String manufacturer;
  final String model;
  final int yearOfManufacture;
  final String vin;
  final String registrationNumber;
  final String primaryUsage;
  final String fuelType;
  final String transmission;
  final List<String> vehicleImages;
  final int nuumberOfService;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  BookingVehicle({
    required this.id,
    required this.user,
    required this.vehicleName,
    required this.manufacturer,
    required this.model,
    required this.yearOfManufacture,
    required this.vin,
    required this.registrationNumber,
    required this.primaryUsage,
    required this.fuelType,
    required this.transmission,
    required this.vehicleImages,
    required this.nuumberOfService,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BookingVehicle.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return BookingVehicle(
      id: json['_id'] is String ? json['_id'] as String : '',
      user: json['user'] is String ? json['user'] as String : '',
      vehicleName: json['vehicleName'] is String ? json['vehicleName'] as String : '',
      manufacturer: json['manufacturer'] is String ? json['manufacturer'] as String : '',
      model: json['model'] is String ? json['model'] as String : '',
      yearOfManufacture: json['yearOfManufacture'] is int ? json['yearOfManufacture'] as int : 0,
      vin: json['vin'] is String ? json['vin'] as String : '',
      registrationNumber: json['registrationNumber'] is String ? json['registrationNumber'] as String : '',
      primaryUsage: json['primaryUsage'] is String ? json['primaryUsage'] as String : '',
      fuelType: json['fuelType'] is String ? json['fuelType'] as String : '',
      transmission: json['transmission'] is String ? json['transmission'] as String : '',
      vehicleImages: json['vehicleImages'] is List
          ? List<String>.from((json['vehicleImages'] as List).map((x) => x.toString()))
          : const [],
      nuumberOfService: json['nuumberOfService'] is int ? json['nuumberOfService'] as int : 0,
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
      v: json['__v'] is int ? json['__v'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'vehicleName': vehicleName,
    'manufacturer': manufacturer,
    'model': model,
    'yearOfManufacture': yearOfManufacture,
    'vin': vin,
    'registrationNumber': registrationNumber,
    'primaryUsage': primaryUsage,
    'fuelType': fuelType,
    'transmission': transmission,
    'vehicleImages': vehicleImages,
    'nuumberOfService': nuumberOfService,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };

  BookingVehicle copyWith({
    String? id,
    String? user,
    String? vehicleName,
    String? manufacturer,
    String? model,
    int? yearOfManufacture,
    String? vin,
    String? registrationNumber,
    String? primaryUsage,
    String? fuelType,
    String? transmission,
    List<String>? vehicleImages,
    int? nuumberOfService,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return BookingVehicle(
      id: id ?? this.id,
      user: user ?? this.user,
      vehicleName: vehicleName ?? this.vehicleName,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      vin: vin ?? this.vin,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      primaryUsage: primaryUsage ?? this.primaryUsage,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      vehicleImages: vehicleImages ?? this.vehicleImages,
      nuumberOfService: nuumberOfService ?? this.nuumberOfService,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}


import 'package:car_care/models/profile_model.dart';

class VehiclesModel {
  final String id;
  final ProfileModel? user;
  final String vehicleName;
  final String manufacturer;
  final String model;
  final int yearOfManufacture;
  final String registrationNumber;
  final String licensePlateImage;
  final String color;
  final String primaryUsage;
  final String vehicleType;
  final String fuelType;
  final String transmission;
  final String engineSize;
  final int mileage;
  final String mileageUnit;
  final String insuranceProvider;
  final String insurancePolicyNumber;
  final String insuranceExpiryDate;
  final String lastServiceDate;
  final String nextServiceDue;
  final String nextServiceMileage;
  final List<String> vehicleImages;
  final dynamic nuumberOfService;
  final String notes;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehiclesModel({
    required this.id,
    this.user,
    required this.vehicleName,
    required this.manufacturer,
    required this.model,
    required this.yearOfManufacture,
    required this.registrationNumber,
    required this.licensePlateImage,
    required this.color,
    required this.primaryUsage,
    required this.vehicleType,
    required this.fuelType,
    required this.transmission,
    required this.engineSize,
    required this.mileage,
    required this.mileageUnit,
    required this.insuranceProvider,
    required this.insurancePolicyNumber,
    required this.insuranceExpiryDate,
    required this.lastServiceDate,
    required this.nextServiceDue,
    required this.nextServiceMileage,
    required this.vehicleImages,
    required this.nuumberOfService,
    required this.notes,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehiclesModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return VehiclesModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      user: json['user'] is Map<String, dynamic> ? ProfileModel.fromJson(json['user'] as Map<String, dynamic>) : null,
      vehicleName: json['vehicleName'] is String ? json['vehicleName'] as String : '',
      manufacturer: json['manufacturer'] is String ? json['manufacturer'] as String : '',
      model: json['model'] is String ? json['model'] as String : '',
      yearOfManufacture: json['yearOfManufacture'] is int ? json['yearOfManufacture'] as int : 0,
      registrationNumber: json['registrationNumber'] is String ? json['registrationNumber'] as String : '',
      licensePlateImage: json['licensePlateImage'] is String ? json['licensePlateImage'] as String : '',
      color: json['color'] is String ? json['color'] as String : '',
      primaryUsage: json['primaryUsage'] is String ? json['primaryUsage'] as String : '',
      vehicleType: json['vehicleType'] is String ? json['vehicleType'] as String : '',
      fuelType: json['fuelType'] is String ? json['fuelType'] as String : '',
      transmission: json['transmission'] is String ? json['transmission'] as String : '',
      engineSize: json['engineSize'] is String ? json['engineSize'] as String : json['engineSize']?.toString() ?? '',
      mileage: json['mileage'] is int ? json['mileage'] as int : 0,
      mileageUnit: json['mileageUnit'] is String ? json['mileageUnit'] as String : '',
      insuranceProvider: json['insuranceProvider'] is String ? json['insuranceProvider'] as String : '',
      insurancePolicyNumber: json['insurancePolicyNumber'] is String ? json['insurancePolicyNumber'] as String : '',
      insuranceExpiryDate: json['insuranceExpiryDate'] is String ? json['insuranceExpiryDate'] as String : '',
      lastServiceDate: json['lastServiceDate'] is String ? json['lastServiceDate'] as String : '',
      nextServiceDue: json['nextServiceDue'] is String ? json['nextServiceDue'] as String : '',
      nextServiceMileage: json['nextServiceMileage'] is String ? json['nextServiceMileage'] as String : '',
      vehicleImages: json['vehicleImages'] is List
          ? List<String>.from((json['vehicleImages'] as List).map((x) => x.toString()))
          : const [],
      nuumberOfService: json['nuumberOfService'] is int ? json['nuumberOfService'] as int : 0,
      notes: json['notes'] is String ? json['notes'] as String : json['notes']?.toString() ?? '',
      isActive: json['isActive'] == true,
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
      'user': user,
      'vehicleName': vehicleName,
      'manufacturer': manufacturer,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'registrationNumber': registrationNumber,
      'licensePlateImage': licensePlateImage,
      'color': color,
      'primaryUsage': primaryUsage,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'transmission': transmission,
      'engineSize': engineSize,
      'mileage': mileage,
      'mileageUnit': mileageUnit,
      'insuranceProvider': insuranceProvider,
      'insurancePolicyNumber': insurancePolicyNumber,
      'insuranceExpiryDate': insuranceExpiryDate,
      'lastServiceDate': lastServiceDate,
      'nextServiceDue': nextServiceDue,
      'nextServiceMileage': nextServiceMileage,
      'vehicleImages': vehicleImages,
      'nuumberOfService': nuumberOfService,
      'notes': notes,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  VehiclesModel copyWith({
    String? id,
    ProfileModel? user,
    String? vehicleName,
    String? manufacturer,
    String? model,
    int? yearOfManufacture,
    String? registrationNumber,
    String? licensePlateImage,
    String? color,
    String? primaryUsage,
    String? vehicleType,
    String? fuelType,
    String? transmission,
    String? engineSize,
    int? mileage,
    String? mileageUnit,
    String? insuranceProvider,
    String? insurancePolicyNumber,
    String? insuranceExpiryDate,
    String? lastServiceDate,
    String? nextServiceDue,
    String? nextServiceMileage,
    List<String>? vehicleImages,
    int? nuumberOfService,
    String? notes,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehiclesModel(
      id: id ?? this.id,
      user: user ?? this.user,
      vehicleName: vehicleName ?? this.vehicleName,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      licensePlateImage: licensePlateImage ?? this.licensePlateImage,
      color: color ?? this.color,
      primaryUsage: primaryUsage ?? this.primaryUsage,
      vehicleType: vehicleType ?? this.vehicleType,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      engineSize: engineSize ?? this.engineSize,
      mileage: mileage ?? this.mileage,
      mileageUnit: mileageUnit ?? this.mileageUnit,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDue: nextServiceDue ?? this.nextServiceDue,
      nextServiceMileage: nextServiceMileage ?? this.nextServiceMileage,
      vehicleImages: vehicleImages ?? this.vehicleImages,
      nuumberOfService: nuumberOfService ?? this.nuumberOfService,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}


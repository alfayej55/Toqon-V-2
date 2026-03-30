

import 'package:car_care/models/profile_model.dart';
import 'package:car_care/models/service_model.dart';
import 'package:car_care/models/vahical_model.dart';

class CareGraphDetailsModel {
  final VehiclesModel? vehicle;
  final List<CareGraphResultModel> results;
  final int currentPage;
  final int? previousPage;
  final int? nextPage;
  final int totalPages;
  final int totalItems;
  final String pdfDownloadUrl;

  CareGraphDetailsModel({
    this.vehicle,
    required this.results,
    required this.currentPage,
    this.previousPage,
    this.nextPage,
    required this.totalPages,
    required this.totalItems,
    required this.pdfDownloadUrl,
  });

  factory CareGraphDetailsModel.fromJson(Map<String, dynamic> json) {
    return CareGraphDetailsModel(
      vehicle: json['vehicle'] is Map<String, dynamic>
          ? VehiclesModel.fromJson(
              json['vehicle'] as Map<String, dynamic>)
          : null,
      results: json['results'] is List
          ? List<CareGraphResultModel>.from((json['results'] as List)
              .map((x) => CareGraphResultModel.fromJson(x as Map<String, dynamic>)))
          : const [],
      currentPage: json['currentPage'] is int ? json['currentPage'] as int : 1,
      previousPage: json['previousPage'] is int ? json['previousPage'] as int : null,
      nextPage: json['nextPage'] is int ? json['nextPage'] as int : null,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : 1,
      totalItems: json['totalItems'] is int ? json['totalItems'] as int : 0,
      pdfDownloadUrl: json['pdfDownloadUrl'] is String ? json['pdfDownloadUrl'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicle': vehicle?.toJson(),
    'results': List<dynamic>.from(results.map((x) => x.toJson())),
    'currentPage': currentPage,
    'previousPage': previousPage,
    'nextPage': nextPage,
    'totalPages': totalPages,
    'totalItems': totalItems,
    'pdfDownloadUrl': pdfDownloadUrl,
  };

  CareGraphDetailsModel copyWith({
    VehiclesModel? vehicle,
    List<CareGraphResultModel>? results,
    int? currentPage,
    int? previousPage,
    int? nextPage,
    int? totalPages,
    int? totalItems,
    String? pdfUrl,
  }) {
    return CareGraphDetailsModel(
      vehicle: vehicle ?? this.vehicle,
      results: results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      previousPage: previousPage ?? this.previousPage,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pdfDownloadUrl: pdfUrl ?? pdfDownloadUrl,
    );
  }
}


class CareGraphResultModel {
  final String id;
  final String vehicle;
  final String user;
  final String source;
  final ServiceModel? booking;
  final String serviceName;
  final String serviceDescription;
  final String serviceCategory;
  final ProfileModel? garage;
  final String garageName;
  final String garageAddress;
  final String mechanicName;
  final DateTime? serviceDate;
  final num cost;
  final String currency;
  final int? mileage;
  final String mileageUnit;
  final List<String> documents;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CareGraphResultModel({
    required this.id,
    required this.vehicle,
    required this.user,
    required this.source,
    this.booking,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceCategory,
    this.garage,
    required this.garageName,
    required this.garageAddress,
    required this.mechanicName,
    this.serviceDate,
    required this.cost,
    required this.currency,
    this.mileage,
    required this.mileageUnit,
    required this.documents,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CareGraphResultModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    return CareGraphResultModel(
      id: json['_id'] is String ? json['_id'] as String : '',
      vehicle: json['vehicle'] is String ? json['vehicle'] as String : '',
      user: json['user'] is String ? json['user'] as String : '',
      source: json['source'] is String ? json['source'] as String : '',
      booking: json['booking'] is Map<String, dynamic>
          ? ServiceModel.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
      serviceName: json['serviceName'] is String ? json['serviceName'] as String : '',
      serviceDescription: json['serviceDescription'] is String
          ? json['serviceDescription'] as String
          : '',
      serviceCategory: json['serviceCategory'] is String
          ? json['serviceCategory'] as String
          : '',
      garage: json['garage'] is Map<String, dynamic>
          ? ProfileModel.fromJson(json['garage'] as Map<String, dynamic>)
          : null,
      garageName: json['garageName'] is String ? json['garageName'] as String : '',
      garageAddress: json['garageAddress'] is String ? json['garageAddress'] as String : '',
      mechanicName: json['mechanicName'] is String ? json['mechanicName'] as String : '',
      serviceDate: json['serviceDate'] is String
          ? DateTime.tryParse(json['serviceDate'])
          : null,
      cost: json['cost'] is num ? json['cost'] as num : 0,
      currency: json['currency'] is String ? json['currency'] as String : '',
      mileage: json['mileage'] is int ? json['mileage'] as int : null,
      mileageUnit: json['mileageUnit'] is String ? json['mileageUnit'] as String : '',
      documents: json['documents'] is List
          ? List<String>.from((json['documents'] as List).map((x) => x.toString()))
          : const [],
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt']) ?? now
          : now,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt']) ?? now
          : now,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'vehicle': vehicle,
    'user': user,
    'source': source,
    'booking': booking?.toJson(),
    'serviceName': serviceName,
    'serviceDescription': serviceDescription,
    'serviceCategory': serviceCategory,
    'garage': garage?.toJson(),
    'garageName': garageName,
    'garageAddress': garageAddress,
    'mechanicName': mechanicName,
    'serviceDate': serviceDate?.toIso8601String(),
    'cost': cost,
    'currency': currency,
    'mileage': mileage,
    'mileageUnit': mileageUnit,
    'documents': List<dynamic>.from(documents.map((x) => x)),
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  CareGraphResultModel copyWith({
    String? id,
    String? vehicle,
    String? user,
    String? source,
    ServiceModel? booking,
    String? serviceName,
    String? serviceDescription,
    String? serviceCategory,
    ProfileModel? garage,
    String? garageName,
    String? garageAddress,
    String? mechanicName,
    DateTime? serviceDate,
    num? cost,
    String? currency,
    int? mileage,
    String? mileageUnit,
    List<String>? documents,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CareGraphResultModel(
      id: id ?? this.id,
      vehicle: vehicle ?? this.vehicle,
      user: user ?? this.user,
      source: source ?? this.source,
      booking: booking ?? this.booking,
      serviceName: serviceName ?? this.serviceName,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      garage: garage ?? this.garage,
      garageName: garageName ?? this.garageName,
      garageAddress: garageAddress ?? this.garageAddress,
      mechanicName: mechanicName ?? this.mechanicName,
      serviceDate: serviceDate ?? this.serviceDate,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      mileage: mileage ?? this.mileage,
      mileageUnit: mileageUnit ?? this.mileageUnit,
      documents: documents ?? this.documents,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}



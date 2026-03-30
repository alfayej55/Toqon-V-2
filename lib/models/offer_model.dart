
import 'package:car_care/models/profile_model.dart';
import 'package:car_care/models/service_model.dart';

class OfferModel {
  String? id;
  ProfileModel? garageId;
  ServiceModel? service;
  dynamic offerPercent;
  dynamic offerPrice;
  DateTime? offerExpiresAt;
  String? offerDescription;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic distance;
  dynamic distanceInKm;

  OfferModel({
    this.id,
    this.garageId,
    this.service,
    this.offerPercent,
    this.offerPrice,
    this.offerExpiresAt,
    this.offerDescription,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.distanceInKm,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    id: json["_id"],
    garageId: json["garageId"] == null ? null : ProfileModel.fromJson(json["garageId"]),
    service: json["service"] == null ? null : ServiceModel.fromJson(json["service"]),
    offerPercent: json["offerPercent"],
    offerPrice: json["offerPrice"],
    offerExpiresAt: json["offerExpiresAt"] == null ? null : DateTime.parse(json["offerExpiresAt"]),
    offerDescription: json["offerDescription"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    distance: json["distance"],
    distanceInKm: json["distanceInKm"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "garageId": garageId?.toJson(),
    "service": service?.toJson(),
    "offerPercent": offerPercent,
    "offerPrice": offerPrice,
    "offerExpiresAt": offerExpiresAt?.toIso8601String(),
    "offerDescription": offerDescription,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "distance": distance,
    "distanceInKm": distanceInKm,
  };
}



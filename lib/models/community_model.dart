import 'package:car_care/models/profile_model.dart';

class CommunityModel {
  String? id;
  ProfileModel? user;
  String? postType;
  String? postDescription;
  String? postImage;
  String? hasTag;
  dynamic issueType;
  bool? isOpen;
  dynamic carType;
  dynamic budget;
  String? urgencyType;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distance;
  double? distanceInKm;
  int likeCount;
  int commentCount;
  bool isLiked;
  bool isSaved;
  bool isSolved;
  int offerSend;

  CommunityModel({
    this.id,
    this.user,
    this.postType,
    this.postDescription,
    this.postImage,
    this.hasTag,
    this.issueType,
    this.isOpen,
    this.isLiked = false,
    this.carType,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isSaved = false,
    this.isSolved = false,
    this.offerSend = 1,
    this.budget,
    this.urgencyType,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.distanceInKm,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
    id: json["_id"],
    user: json["user"] == null ? null : ProfileModel.fromJson(json["user"]),
    postType: json["postType"],
    postDescription: json["postDescription"],
    postImage: json["postImage"],
    hasTag: json["hasTag"],
    issueType: json["issueType"],
    isOpen: json["isOpen"],
    isLiked: json["isLiked"] ?? false,
    carType: json["carType"],
    budget: json["budget"],
    urgencyType: json["urgencyType"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    distance: json["distance"]?.toDouble(),
    likeCount: json["likeCount"]?.toInt() ?? 0,
    commentCount: json["commentCount"]?.toInt() ?? 0,
    isSaved: json["isSaved"] == true,
    isSolved: json["isSolved"] == true,
    offerSend: json["offerSend"]?.toInt() ?? 1,
    distanceInKm: json["distanceInKm"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "postType": postType,
    "postDescription": postDescription,
    "postImage": postImage,
    "hasTag": hasTag,
    "issueType": issueType,
    "isOpen": isOpen,
    "isLiked": isLiked,
    "carType": carType,
    "budget": budget,
    "likeCount": likeCount,
    "commentCount": commentCount,
    "isSaved": isSaved,
    "isSolved": isSolved,
    "offerSend": offerSend,
    "urgencyType": urgencyType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "distance": distance,
    "distanceInKm": distanceInKm,
  };
}

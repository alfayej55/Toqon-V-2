import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class HomeController extends GetxController {
  final apiClient = Get.put(ApiClient());
  var item=5.obs;
  String title="Home Screen";

  File? selectedImage;
  RxString imagesPath=''.obs;

  @override
  void onInit() {

    //debugPrint("On Init  $title");

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
  //  debugPrint("On onReady  $title");
    super.onReady();
  }

  Future pickImages(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage = File(returnImage.path);
    imagesPath.value = returnImage.path;
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    debugPrint('ImagesPath===========================>:${imagesPath.value}');
   // Get.back(); //
  }



  void startTrackingLocation() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {

      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10000, // 10 km
    );

     Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(
          (Position position) {
        debugPrint('📍 নতুন লোকেশন: ${position.latitude}, ${position.longitude}');

        // Update location to server
        updateLocation(
          longitude: position.longitude,
          latitude: position.latitude,
          address: "Current Location", // TODO: Add reverse geocoding for actual address
        );

        // 📌 এখানে আপনি কাছাকাছি গ্যারেজ লোড করতে পারেন
        // loadNearbyGarages(position.latitude, position.longitude);
      },
      onError: (Object error) {

      },
    );
  }

  Future<void> updateLocation({
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    try {


      final body = {
        "longitude": longitude,
        "latitude": latitude,
        "address": address,
      };

      debugPrint('Updating location: $body');

      final response = await apiClient.patchData(
        ApiConstants.updateEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        debugPrint('Location updated successfully: ${response.data}');
      } else {
        debugPrint('Failed to update location: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  /// Get Garage
  /// Get Garage User
  var garageLoading = false.obs;
  RxList<ProfileModel> garageList=<ProfileModel>[].obs;

  getGarage()async{
    garageLoading(true);
    try {
      // API Call
      final response = await apiClient.getData(ApiConstants.homeGarageProfileEndPoint);
      // Handle response
      if (response.isSuccess) {
        // Assign categories to serviceList
        garageList.value = List<ProfileModel>.from(response.data['data']['attributes']['results'].map((x) => ProfileModel.fromJson(x))
        );

      }
    } catch (e) {
      debugPrint('Get Active Offer Error: $e');
    } finally {
      garageLoading.value = false;
    }
  }

}
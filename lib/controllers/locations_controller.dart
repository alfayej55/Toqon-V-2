import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/profile_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';


class LocationController extends GetxController{

  final ApiClient _apiClient = Get.find<ApiClient>();

  // User's current location
  Rx<LatLng> currentLocation = LatLng(23.803292583341523, 90.415693934826).obs;
  var locationLoading = true.obs;

  // @override
  // void onInit() {
  //   getCurrentLocation();
  //   getGarage();
  //   super.onInit();
  // }

  RxList<Marker> markerList = <Marker>[].obs;

  /// Get User's Current Location
  Future<void> getCurrentLocation() async {
    try {
      locationLoading.value = true;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);
      debugPrint('Current Location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('Error getting current location: $e');
    } finally {
      locationLoading.value = false;
    }
  }


  /// Get Garage User
  var garageLoading = false.obs;
  RxList<ProfileModel> garageList=<ProfileModel>[].obs;
  getGarage()async{
    print('Garage Show>>>>>>>>>');
    garageLoading(true);
    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.nearbyGarageEndPoint);
      // Handle response
      if (response.isSuccess) {
        // Assign categories to serviceList
        garageList.value = List<ProfileModel>.from(response.data['data']['attributes'].map((x) => ProfileModel.fromJson(x))
        );
        addMarkers();
      }
    } catch (e) {
      debugPrint('Get Active Offer Error: $e');
    } finally {
      garageLoading.value = false;
    }
  }



  Future<void> addMarkers() async {
    try {
      garageList.refresh();
      markerList.clear();

      List<List<int>> groupedIndices = [];

      const double distanceThresholdMeters = 30.0;

      for (int i = 0; i < garageList.length; i++) {
        bool added = false;
        final userI = garageList[i];
        final latI = userI.myLocation.coordinates[1];
        final lngI = userI.myLocation.coordinates[0];

        for (List<int> group in groupedIndices) {
          final firstIndex = group[0];
          final userJ = garageList[firstIndex];
          final latJ = userJ.myLocation.coordinates[1];
          final lngJ = userJ.myLocation.coordinates[0];

          double distance = Geolocator.distanceBetween(latI, lngI, latJ, lngJ);

          if (distance < distanceThresholdMeters) {
            group.add(i);
            added = true;
            break;
          }
        }

        if (!added) {
          groupedIndices.add([i]);
        }
      }

      // Now place each group with circular spread
      for (List<int> group in groupedIndices) {
        int count = group.length;

        for (int i = 0; i < count; i++) {
          final index = group[i];
          final user = garageList[index];

          final baseLat = user.myLocation.coordinates[1];
          final baseLng = user.myLocation.coordinates[0];

          double adjustedLat = baseLat;
          double adjustedLng = baseLng;

          if (count > 1) {

            const double radius = 0.00008;
            double angle = (2 * math.pi * i) / count;
            adjustedLat += radius * math.cos(angle);
            adjustedLng += radius * math.sin(angle);

          }

          final customIcon = await getBytesFromNetworkImage(
            user.image,
            35,
            35,
          );

          final marker = Marker(
            markerId: MarkerId('marker_$index'),
            position: LatLng(adjustedLat, adjustedLng),
            onTap: (){
              Get.toNamed(AppRoutes.garageDetailsScreen,arguments: {'serviceId':'', 'garageID': user.id, 'serviceName': 'Garage Details'});
            },
            icon: BitmapDescriptor.bytes(customIcon),
          );

          markerList.add(marker);
        }
      }

      markerList.refresh();
    } catch (e) {
      debugPrint('❌ Error adding markers: $e');
      update();
    }
  }




  Future<Uint8List> getBytesFromNetworkImage(String url, int width, int height, {double borderWidth = 5.0, Color borderColor = Colors.transparent}) async {
    try {
      final ImageStream imageStream = NetworkImage(url).resolve(ImageConfiguration());
      final Completer<ui.Image> completer = Completer<ui.Image>();

      imageStream.addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(info.image);
        }, onError: (dynamic error, StackTrace? stackTrace) {
          completer.completeError(error, stackTrace);
        }),
      );

      final ui.Image originalImage = await completer.future;

      // Resize the image to the specified width and height with a circular mask
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      // Define the destination rectangle for resizing
      final Rect dstRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

      // Create a circular clip path
      final Path clipPath = Path()..addOval(dstRect);
      canvas.clipPath(clipPath);

      // Draw the original image into the circular clip region
      canvas.drawImageRect(
        originalImage,
        Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble()),
        dstRect,
        Paint(),
      );


      final ui.Picture picture = recorder.endRecording();
      final ui.Image circularImage = await picture.toImage(width, height);

      // Convert the circular image to byte data
      final ByteData? byteData = await circularImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return byteData.buffer.asUint8List();
      } else {
        throw Exception('Failed to convert circular image to byte data');
      }
    } catch (e) {
      debugPrint('Error processing network image: $e');
      throw Exception('Failed to load or process network image: $e');
    }
  }


}
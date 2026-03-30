import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';
import 'package:dio/dio.dart' as dio;

class UploadImageController extends GetxController {
  // Inject ApiClient
  final ApiClient _apiClient = Get.find<ApiClient>();

  var imagePath = ''.obs;
  var uploadUrl = ''.obs;
  var fileUrl = ''.obs;
  var isUploading = false.obs;
  var uploadComplete = false.obs;
  var uploadProgress = 0.0.obs;
  String fileType = '';
  File? selectedImage;

  // Pick Image from Gallery or Camera
  Future<void> pickImage(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage = File(returnImage.path);
    imagePath.value = returnImage.path;
    fileType = returnImage.path.split('.').last.toLowerCase();
    debugPrint('File type: $fileType');
    await uploadImage();
    update();
  }

  // Add New Service
  Future<void> uploadImage() async {
    isUploading.value = true;
    uploadComplete.value = false;

    try {
      // Prepare request body
      final String fileName = imagePath.value.split('/').last;
      var body = {
        "fileName": fileName,
        "fileType": 'image/$fileType',
        "folder": "images",
      };

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.uploadImage,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        uploadUrl.value = response.data['data']['attributes']['uploadUrl'];
        fileUrl.value = response.data['data']['attributes']['fileUrl'];
        await uploadPut();
        update();
      } else {
        isUploading.value = false;
      }
    } catch (e) {
      isUploading.value = false;
      Get.snackbar('Error', 'Failed to add service: $e');
    }
  }

  Future<void> uploadPut() async {
    try {
      uploadProgress.value = 0.0;

      final file = File(imagePath.value);
      final bytes = await file.readAsBytes();

      // API Call - PUT request with binary body
      final response = await _apiClient.putDataWithoutAuth(
        uploadUrl.value,
        data: bytes,
        options: dio.Options(contentType: 'image/$fileType'),
        onSendProgress: (sent, total) {
          if (total != -1) {
            uploadProgress.value = (sent / total);
          }
        },
      );

      if (response.isSuccess) {
        uploadProgress.value = 1.0;
        isUploading.value = false;
        uploadComplete.value = true;
        debugPrint('Image uploaded successfully to S3!');
        update();
      } else {
        isUploading.value = false;
        Get.snackbar(
          'Upload Failed',
          'Server returned error: ${response.message}',
        );
      }
    } catch (e) {
      isUploading.value = false;
      Get.snackbar('Error', 'Failed to upload image: $e');
    }
  }
}

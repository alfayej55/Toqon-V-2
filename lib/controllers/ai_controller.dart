
import 'dart:io';

import 'package:car_care/all_export.dart';
import 'package:car_care/models/damage_ai_model.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:car_care/service/dio_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AiDamageController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());

  var aiDamageLoading = false.obs;
  RxList<DamageConversation> conversationList = <DamageConversation>[].obs;

  File? selectedImage;
  RxString imagesPath=''.obs;

  TextEditingController aiDamageTextCtrl=TextEditingController();

  Future<void> postAiDamage() async {
    aiDamageLoading.value = true;

    try {
      List<MultipartFileData>? files;

      /// If image is selected, add to files
      if (selectedImage != null && imagesPath.value.isNotEmpty) {
        files = [

          MultipartFileData(
            key: 'image',
            filePath: imagesPath.value,
          ),

        ];

        debugPrint('Image added to request: ${imagesPath.value}');

      }
      else {

        debugPrint('No image selected - selectedImage: $selectedImage, path: ${imagesPath.value}');

      }

      final response = await _apiClient.postMultipartData(
        ApiConstants.aiDamageEndpoint,
        fields: {
          'description': aiDamageTextCtrl.text.trim(),
        },
        files: files,
      );

      if (response.isSuccess) {
        final List<dynamic> conversations =
            response.data['data']['attributes']['conversations'];
        conversationList.value = conversations
            .map((e) => DamageConversation.fromJson(e as Map<String, dynamic>))
            .toList();

        /// Clear after success
        aiDamageTextCtrl.clear();
        selectedImage = null;
        imagesPath.value = '';
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to post AI damage: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      aiDamageLoading.value = false;
    }
  }


  Future pickImages(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage = File(returnImage.path);
    imagesPath.value = returnImage.path;
    update();
  }
}
// import 'dart:io';
// import 'package:car_care/all_export.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProfileController extends GetxController {
//
//   File? selectedImage;
//   var imagePath=''.obs;
//
//
//
//   TextEditingController nameTextCtrl=TextEditingController();
//   TextEditingController phoneTextCtrl=TextEditingController();
//   TextEditingController  addressTextCtrl=TextEditingController();
//   TextEditingController referredGarageTextCtrl=TextEditingController();
//
//
//   Future pickImages(ImageSource source) async {
//     final returnImage = await ImagePicker().pickImage(source: source);
//     if (returnImage == null) return;
//     selectedImage = File(returnImage.path);
//     imagePath.value = returnImage.path;
//     //  image = File(returnImage.path).readAsBytesSync();
//     update();
//     debugPrint('ImagesPath===========================>:${imagePath.value}');
//     // Get.back(); //
//   }
//
//   @override
//   void onClose() {
//     nameTextCtrl.dispose();
//     phoneTextCtrl.dispose();
//     addressTextCtrl.dispose();
//     referredGarageTextCtrl.dispose();
//     super.onClose();
//   }
//
// }
//

import 'dart:convert';

import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';
import 'package:car_care/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/policy_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class ProfileController extends GetxController {
  static const String _profileCacheKey = 'profile_cache_v1';
  final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

  @override
  void onInit() {
    _hydrateProfileFromCacheOrDefault();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileInfoGet();
      await privacyPolicyGet();
      await termAndConditionGet();
    });
    super.onInit();
    // Initialize or fetch services
  }

  // Inject ApiClient
  final ApiClient _apiClient = Get.put(ApiClient());

  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController phoneTextCtrl = TextEditingController();
  TextEditingController addressTextCtrl = TextEditingController();
  TextEditingController referredGarageTextCtrl = TextEditingController();

  /// Get Profile Info
  var profileLoading = false.obs;

  Rx<ProfileModel> profileModel = ProfileModel.fromJson({}).obs;

  ProfileModel get effectiveProfile {
    final current = profileModel.value;
    final fallback = _defaultMrShamProfile();
    final bool isEmpty =
        current.fullName.trim().isEmpty &&
        current.email.trim().isEmpty &&
        current.address.trim().isEmpty &&
        current.id.trim().isEmpty;

    if (isEmpty) return fallback;

    return current.copyWith(
      fullName:
          current.fullName.trim().isEmpty
              ? fallback.fullName
              : current.fullName,
      email: current.email.trim().isEmpty ? fallback.email : current.email,
      address:
          current.address.trim().isEmpty ? fallback.address : current.address,
      dateOfBirth:
          current.dateOfBirth.year < 1901
              ? fallback.dateOfBirth
              : current.dateOfBirth,
    );
  }

  Future<void> _hydrateProfileFromCacheOrDefault() async {
    try {
      final raw = _sharedPreferences.getString(_profileCacheKey);
      if (raw != null && raw.trim().isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(raw);
        profileModel.value = ProfileModel.fromJson(decoded);
        return;
      }
    } catch (_) {}
    profileModel.value = _defaultMrShamProfile();
  }

  Future<void> _cacheProfile() async {
    await _sharedPreferences.setString(
      _profileCacheKey,
      jsonEncode(profileModel.value.toJson()),
    );
  }

  ProfileModel _defaultMrShamProfile() {
    return ProfileModel(
      myLocation: MyLocation(type: 'Point', coordinates: const [0.0, 0.0]),
      fullName: 'Mr. Sham',
      userName: 'mrsham',
      email: 'amishamimbd@gmail.com',
      authProvider: '',
      googleId: '',
      image: '',
      role: 'user',
      callingCode: '+1',
      phoneNumber: '',
      myWallet: 0,
      mySaving: 0,
      dateOfBirth: DateTime(2000, 3, 1),
      address: '140 Cleanside Road, Scarborough, M1L0J3',
      oneTimeCodeExpiry: DateTime.now(),
      isGarageAproved: false,
      isMacanicAproved: false,
      isVerified: true,
      isProfileCompleted: true,
      createdAt: DateTime.now(),
      stripeCustomerId: '',
      id: 'self_mr_sham',
    );
  }

  Future<void> profileInfoGet() async {
    profileLoading.value = true;
    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.profileEndPoint);
      // Handle response
      if (response.isSuccess) {
        profileModel.value = ProfileModel.fromJson(
          response.data['data']['attributes']['user'],
        );
        await _cacheProfile();
      }
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
    } finally {
      profileLoading.value = false;
    }
  }

  /// Privacy Model

  Rx<PrivacyModel> privacyModel = PrivacyModel.fromJson({}).obs;

  Future<void> privacyPolicyGet() async {
    profileLoading.value = true;
    try {
      // API Call
      final response = await _apiClient.getData(
        ApiConstants.privacyPolicyEndPoint,
      );
      // Handle response
      if (response.isSuccess) {
        privacyModel.value = PrivacyModel.fromJson(
          response.data['data']['attributes'],
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> termAndConditionGet() async {
    profileLoading.value = true;
    try {
      // API Call
      final response = await _apiClient.getData(
        ApiConstants.termAndConditionEndPoint,
      );
      // Handle response
      if (response.isSuccess) {
        privacyModel.value = PrivacyModel.fromJson(
          response.data['data']['attributes'],
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
    } finally {
      profileLoading.value = false;
    }
  }

  /// changePassword Function

  // Loading state
  RxBool isLoading = false.obs;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future changePassword() async {
    // Start loading
    isLoading.value = true;

    try {
      // Prepare body
      var body = {
        "oldPassword": currentPasswordController.text.trim(),
        "newPassword": newPasswordController.text,
      };
      // API Call
      final response = await _apiClient.postData(
        ApiConstants.changePasswordEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        await PrefsHelper.remove(AppConstants.bearerToken);
        currentPasswordController.clear();
        newPasswordController.clear();
        Get.toNamed(AppRoutes.signInScreen);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  /// Profile Update

  /// Update Profile Function
  Future<void> updateProfile(String imageUrl) async {
    isLoading.value = true;

    try {
      // Use uploaded image URL or existing profile image
      String finalImageUrl =
          imageUrl.isNotEmpty ? imageUrl : profileModel.value.image;

      // Prepare body with updated data
      var body = {
        "fullName": nameTextCtrl.text.trim(),
        "phoneNumber": phoneTextCtrl.text.trim(),
        "address": addressTextCtrl.text.trim(),
        "image": finalImageUrl,
      };

      // API Call
      final response = await _apiClient.patchData(
        ApiConstants.updateProfileEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        // Update the profile model using copyWith
        profileModel.value = profileModel.value.copyWith(
          fullName: nameTextCtrl.text.trim(),
          phoneNumber: phoneTextCtrl.text.trim(),
          address: addressTextCtrl.text.trim(),
          image: finalImageUrl,
        );
        await _cacheProfile();

        Get.snackbar('Success', 'Profile updated successfully');
        Get.back();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update only profile image from quick upload points (drawer/header camera)
  Future<void> updateProfileImageOnly(String imageUrl) async {
    if (imageUrl.trim().isEmpty) return;
    isLoading.value = true;

    try {
      final response = await _apiClient.patchData(
        ApiConstants.updateProfileEndPoint,
        data: {"image": imageUrl.trim()},
      );

      if (response.isSuccess) {
        profileModel.value = profileModel.value.copyWith(
          image: imageUrl.trim(),
        );
        await _cacheProfile();
        Get.snackbar('Success', 'Profile photo updated.');
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile photo.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Initialize edit profile with existing data
  void initEditProfile() {
    nameTextCtrl.text = profileModel.value.fullName;
    phoneTextCtrl.text = profileModel.value.phoneNumber;
    addressTextCtrl.text = profileModel.value.address;
    referredGarageTextCtrl.text = '';
  }
}

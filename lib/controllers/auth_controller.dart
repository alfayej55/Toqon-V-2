import 'dart:async';

import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:flutter/cupertino.dart';
import '../service/dio_api_client.dart';
import '../service/socket_service.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());

  // Sign In Controllers
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  // Sign Up Controllers
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  TextEditingController referralCodeCtrl = TextEditingController();

  // Forgot Password Controllers
  TextEditingController forgotEmailCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();

  // OTP Controller
  TextEditingController otpCtrl = TextEditingController();

  var signInLoading = false.obs;
  var signUpLoading = false.obs;
  var otpLoading = false.obs;
  var forgotEmailLoading = false.obs;

  // OTP Timer
  Timer? _otpTimer;
  var otpTimerSeconds = 0.obs;
  var canResendOtp = false.obs;

  void startOtpTimer() {
    otpTimerSeconds.value = 180; // 3 minutes
    canResendOtp.value = false;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds.value > 0) {
        otpTimerSeconds.value--;
      } else {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    int minutes = otpTimerSeconds.value ~/ 60;
    int seconds = otpTimerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // void stopOtpTimer() {
  //   _otpTimer?.cancel();
  //   _otpTimer = null;
  // }

  /// Login Function
  //
  // Future<void> singIn() async {
  //   // BYPASS LOGIN FOR TESTING:
  //   signInLoading.value = true;
  //   try {
  //     await PrefsHelper.setString(
  //       AppConstants.bearerToken,
  //       'fake_token_for_testing',
  //     );
  //     await PrefsHelper.setString(AppConstants.userID, 'self_mr_sham');
  //
  //     emailCtrl.clear();
  //     passwordCtrl.clear();
  //
  //     Get.offAllNamed(AppRoutes.homeScreen);
  //   } catch (e) {
  //     Get.snackbar('Error', 'Something went wrong. Please try again.');
  //   } finally {
  //     signInLoading.value = false;
  //   }
  // }

  /// Register Function
  Future<void> singIn() async {

    // Start loading
    signInLoading.value = true;

    try {
      // Prepare body
      var body = {
        "email": emailCtrl.text.trim(),
        "password": passwordCtrl.text,
        "fcmToken":"sdfsdfdsfdsfdsf"
      };
      // API Call
      final response = await _apiClient.postData(
        ApiConstants.signIn,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        final token = response.data['data']['attributes']['tokens']['access']['token'];
        final userId = response.data['data']['attributes']['user']['id'] ?? '';

        await PrefsHelper.setString(AppConstants.bearerToken, token);
        await PrefsHelper.setString(AppConstants.userID, userId);

        // Connect Socket with auth
        await SocketService.instance.initialize();
        await SocketService.instance.connect();

        // Clear text fields
        emailCtrl.clear();
        passwordCtrl.clear();

        // Fetch profile data before navigating
        final profileController = Get.put(ProfileController(), permanent: true);
        profileController.profileInfoGet();

        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      signInLoading.value = false;
    }
  }
  Future<void> signUp() async {
    // Start loading
    signUpLoading(true);

    try {
      // Prepare body
      var body = {
        "fullName": fullNameCtrl.text,
        "email": emailCtrl.text,
        "phoneNumber": phoneCtrl.text,
        "address": locationCtrl.text,
        "password": passwordCtrl.text,
        "role": "user",
        if (referralCodeCtrl.text.trim().isNotEmpty)
          "referralCode": referralCodeCtrl.text.trim(),
      };

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.sigUpEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        // Success - Navigate to home or login
        Get.snackbar('Success', 'Registration successful');

        await PrefsHelper.setString(
          AppConstants.bearerToken,
          response.data['data']['attributes']['access']['token'],
        );

        signUpLoading(false);

        // Save email before clearing
        final userEmail = emailCtrl.text.trim();

        // Clear text fields
        fullNameCtrl.clear();
        phoneCtrl.clear();
        locationCtrl.clear();
        passwordCtrl.clear();
        confirmPasswordCtrl.clear();
        referralCodeCtrl.clear();

        startOtpTimer();
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: {'type': 'register', 'email': userEmail},
        );
      } else {
        // Error - Show message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      signUpLoading(false);
    }
  }

  /// OTP Verification Function

  Future<void> verifyOtp(String type) async {
    // Start loading
    otpLoading.value = true;

    try {
      // Prepare body
      var body = {"code": otpCtrl.text.trim()};

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.otpVerifyEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        // Success - Navigate to home
        Get.snackbar('Success', 'OTP verified successfully');

        otpCtrl.clear();

        if (type == 'forgot') {
          Get.offAllNamed(AppRoutes.forgotPasswordScreen);
        } else {
          Get.offAllNamed(AppRoutes.signInScreen);
        }
      } else {
        // Error - Show message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      otpLoading.value = false;
    }
  }

  /// Forgot Email Function
  Future<void> forgotEmail() async {
    forgotEmailLoading.value = true;

    try {
      var body = {"email": forgotEmailCtrl.text.trim()};

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.forgotEmailEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        await PrefsHelper.setString(
          AppConstants.bearerToken,
          response.data['data']['attributes']['access']['token'],
        );

        Get.snackbar('Success', 'OTP sent to your email!');

        startOtpTimer();
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: {'type': 'forgot', 'email': forgotEmailCtrl.text.trim()},
        );
      } else {
        // Error - Show message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      forgotEmailLoading.value = false;
    }
  }

  /// Resend OTP Function
  var resendOtpLoading = false.obs;

  Future<void> resendOtp(String email) async {
    resendOtpLoading.value = true;

    try {
      var body = {"email": email.trim()};

      final response = await _apiClient.postData(
        ApiConstants.forgotEmailEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        Get.snackbar('Success', 'OTP resent to your email!');
        startOtpTimer();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      resendOtpLoading.value = false;
    }
  }

  /// Reset Password

  Future<void> resetPassword() async {
    // Start loading
    otpLoading.value = true;

    try {
      // Prepare body
      var body = {"password": newPasswordCtrl.text.trim()};

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.resetEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        newPasswordCtrl.clear();

        Get.offAllNamed(AppRoutes.signInScreen);
      } else {
        // Error - Show message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Unexpected error
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading
      otpLoading.value = false;
    }
  }
}

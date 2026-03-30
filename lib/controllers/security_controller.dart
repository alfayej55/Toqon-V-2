import 'dart:io';

import 'package:car_care/all_export.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:car_care/service/dio_api_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySession {
  final String id;
  final String deviceName;
  final String location;
  final String lastActiveText;
  final bool isCurrent;

  const SecuritySession({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActiveText,
    required this.isCurrent,
  });
}

class SecurityController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());
  final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

  static const String _biometricKey = 'security_biometric_enabled_v1';
  static const String _twoFaKey = 'security_2fa_enabled_v1';
  static const String _pinLockKey = 'security_pin_lock_enabled_v1';

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool updatingPassword = false.obs;
  final RxBool savingPreferences = false.obs;
  final RxBool loadingSessions = false.obs;

  final RxBool biometricEnabled = false.obs;
  final RxBool twoFactorEnabled = false.obs;
  final RxBool pinLockEnabled = false.obs;

  final RxList<SecuritySession> sessions = <SecuritySession>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalPrefs();
    fetchSessions();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _loadLocalPrefs() {
    biometricEnabled.value = _sharedPreferences.getBool(_biometricKey) ?? false;
    twoFactorEnabled.value = _sharedPreferences.getBool(_twoFaKey) ?? false;
    pinLockEnabled.value = _sharedPreferences.getBool(_pinLockKey) ?? false;
  }

  Future<void> _persistLocalPrefs() async {
    await _sharedPreferences.setBool(_biometricKey, biometricEnabled.value);
    await _sharedPreferences.setBool(_twoFaKey, twoFactorEnabled.value);
    await _sharedPreferences.setBool(_pinLockKey, pinLockEnabled.value);
  }

  Future<void> changePassword() async {
    final current = currentPasswordController.text.trim();
    final next = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      Get.snackbar('Missing fields', 'Please fill all password fields.');
      return;
    }
    if (next.length < 8) {
      Get.snackbar(
        'Weak password',
        'New password must be at least 8 characters.',
      );
      return;
    }
    if (next != confirm) {
      Get.snackbar('Mismatch', 'New password and confirm password must match.');
      return;
    }
    if (current == next) {
      Get.snackbar(
        'Same password',
        'New password must be different from current password.',
      );
      return;
    }

    updatingPassword.value = true;
    try {
      final response = await _apiClient.postData(
        ApiConstants.changePasswordEndPoint,
        data: {'oldPassword': current, 'newPassword': next},
      );

      if (response.isSuccess) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.snackbar('Success', 'Password updated successfully.');
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not update password right now.');
    } finally {
      updatingPassword.value = false;
    }
  }

  Future<void> setBiometric(bool enabled) async {
    biometricEnabled.value = enabled;
    await _persistAndSync();
  }

  Future<void> setTwoFactor(bool enabled) async {
    twoFactorEnabled.value = enabled;
    await _persistAndSync();
  }

  Future<void> setPinLock(bool enabled) async {
    pinLockEnabled.value = enabled;
    await _persistAndSync();
  }

  Future<void> _persistAndSync() async {
    savingPreferences.value = true;
    await _persistLocalPrefs();

    // Backend sync hook: if endpoint is unavailable, local preference still works.
    try {
      final response = await _apiClient.patchData(
        ApiConstants.securityPreferencesEndPoint,
        data: {
          'biometricEnabled': biometricEnabled.value,
          'twoFactorEnabled': twoFactorEnabled.value,
          'pinLockEnabled': pinLockEnabled.value,
        },
      );

      if (!response.isSuccess) {
        Get.snackbar(
          'Saved on device',
          'Preferences saved locally. Cloud sync will retry later.',
        );
      }
    } catch (_) {
      Get.snackbar(
        'Saved on device',
        'Preferences saved locally. Cloud sync is currently unavailable.',
      );
    } finally {
      savingPreferences.value = false;
    }
  }

  Future<void> fetchSessions() async {
    loadingSessions.value = true;
    try {
      final response = await _apiClient.getData(
        ApiConstants.activeSessionsEndPoint,
      );
      if (response.isSuccess) {
        final dynamic list = response.data['data']?['attributes']?['results'];
        if (list is List) {
          sessions.assignAll(
            list.map((item) {
              final map =
                  item is Map<String, dynamic> ? item : <String, dynamic>{};
              return SecuritySession(
                id: (map['_id'] ?? map['id'] ?? '').toString(),
                deviceName: (map['deviceName'] ?? 'Unknown Device').toString(),
                location: (map['location'] ?? 'Unknown').toString(),
                lastActiveText:
                    (map['lastActiveText'] ?? 'Recently active').toString(),
                isCurrent: map['isCurrent'] == true,
              );
            }).toList(),
          );
        } else {
          _setFallbackSession();
        }
      } else {
        _setFallbackSession();
      }
    } catch (_) {
      _setFallbackSession();
    } finally {
      loadingSessions.value = false;
    }
  }

  void _setFallbackSession() {
    final String deviceName =
        Platform.isIOS ? 'iPhone (Current)' : 'Android (Current)';
    sessions.value = [
      SecuritySession(
        id: 'current',
        deviceName: deviceName,
        location: 'Toronto, ON',
        lastActiveText: 'Last active: 2 min ago',
        isCurrent: true,
      ),
    ];
  }
}

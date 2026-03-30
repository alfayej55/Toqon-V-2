import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class NotificationController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());

  /// Get Notifications
  var notificationLoading = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  Future<void> getNotifications() async {
    notificationLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.notificationEndPoint);
      // Handle response
      if (response.isSuccess) {
        final List<dynamic> notificationData = response.data['data']['results'];
        notificationList.value = notificationData
            .map((notification) => NotificationModel.fromJson(notification as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch notifications: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      notificationLoading.value = false;
    }
  }

  /// Get unread notification count
  int get unreadCount => notificationList.where((n) => n.isUnread).length;

  /// Check if there are unread notifications
  bool get hasUnread => unreadCount > 0;
}
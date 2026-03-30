import 'dart:async';

import 'package:car_care/all_export.dart';
import 'package:car_care/models/conversation_model.dart';
import 'package:car_care/models/message_model.dart';
import 'package:car_care/models/profile_model.dart';
import 'package:car_care/service/socket_service.dart';
import 'package:flutter/material.dart';

import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class ChatController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());

  // Always get current instance (not cached) to avoid stale reference after logout/login
  SocketService get _socketService => SocketService.instance;

  TextEditingController chatTextCtrl = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Stream subscription for messages
  StreamSubscription? _messageSubscription;
  String? _currentConversationId;

  var conversionLoading = false.obs;
  var messageLoading = false.obs;

  RxList<ConversationModel> conversionModel = <ConversationModel>[].obs;
  List<MessageModel> messageList = [];

  /// Get all conversations
  conversionsGet() async {
    conversionLoading(true);
    try {
      final response = await _apiClient.getData(
        ApiConstants.conversationsEndPoint,
      );
      if (response.isSuccess) {

        conversionModel.value = List<ConversationModel>.from(
          response.data['data']['attributes']['results'].map((x) => ConversationModel.fromJson(x),
          ),
        );
      }


    } catch (e) {
      debugPrint('Get Conversations Error: $e');
    } finally {
      conversionLoading.value = false;
    }
  }

  /// Get all messages for a conversation
  Future<void> getAllMessage(String conversationId) async {
    messageLoading(true);
    update();
    try {
      final response = await _apiClient.getData(
        ApiConstants.inboxEndPoint(conversationId),
      );
      if (response.isSuccess) {
        messageList = List<MessageModel>.from(
          response.data['data']['attributes']['results'].map(
            (x) => MessageModel.fromJson(x),
          ),
        );
      }
    } catch (e) {
      debugPrint('Get All Messages Error: $e');
    } finally {
      messageLoading.value = false;
      update();
    }
  }

  /// Listen for new messages - call this once when entering chat screen
  void listenMessage(String conversationId) {
    // Prevent duplicate listeners
    if (_currentConversationId == conversationId &&
        _messageSubscription != null) {
      debugPrint("Already listening to conversation: $conversationId");
      return;
    }

    // Cancel any existing subscription first
    stopListenMessage();

    _currentConversationId = conversationId;

    _messageSubscription = _socketService.messageStream.listen((data) {

      final msgConversationId = data['conversation']?.toString() ?? '';
      if (msgConversationId == _currentConversationId) {
        MessageModel newMessage = MessageModel.fromJson(data);
        messageList.insert(0, newMessage);
        update(); // This will rebuild GetBuilder
      }
    });

    debugPrint("Started listening to conversation: $conversationId");
  }

  /// Stop listening to messages - call this when leaving chat screen
  void stopListenMessage() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
    _currentConversationId = null;
    debugPrint("Stopped listening to messages");
  }

  /// Send message via socket
  Future<bool> sendMessage({
    required String conversationId,
    required String receiverId,
  }) async {
    final message = chatTextCtrl.text.trim();
    if (message.isEmpty) return false;

    final success = await _socketService.sendMessage(
      conversationId: conversationId,
      receiverId: receiverId,
      message: message,
      messageType: 'text',
    );

    if (success) {
      chatTextCtrl.clear();
    }
    else{
      debugPrint('error>>>>$success');
    }
    return success;
  }

  Future<bool> sendMessagePayload({
    required String conversationId,
    required String receiverId,
    required String content,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    final String trimmed = content.trim();
    if (trimmed.isEmpty) return false;

    final success = await _socketService.sendMessage(
      conversationId: conversationId,
      receiverId: receiverId,
      message: trimmed,
      messageType: messageType,
      metadata: metadata,
    );

    if (success && messageType == 'text') {
      chatTextCtrl.clear();
    }
    return success;
  }

  /// Clear message list when leaving screen
  void clearMessages() {
    messageList.clear();
    update();
  }

  /// Create Conversation via POST API
  var createConversationLoading = false.obs;

  Future<void> createConversations({required String receiverId}) async {
    createConversationLoading(true);

    try {
      // Get current user ID
      final currentUserId = await PrefsHelper.getString(AppConstants.userID);

      final body = {
        "type": "direct",
        "participants": [receiverId],
      };

      final response = await _apiClient.postData(
        ApiConstants.conversationsEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        final data = response.data['data']['attributes'];

        // Get conversation ID
        final conversationId = data['id'] ?? '';

        final participants = data['participants'] as List;

        final chatPartnerData = participants.firstWhere(
          (p) => p['id'] != currentUserId,
          orElse: () => participants.first,
        );

        // Create ProfileModel from participant data
        final chatPartner = ProfileModel.fromJson(chatPartnerData);

        // Navigate to inbox with arguments
        Get.toNamed(
          AppRoutes.messageInboxScreen,
          arguments: {
            'conversationId': conversationId,
            'chatPartner': chatPartner,
          },
        );
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Create Conversation Error: $e');
      Get.snackbar('Error', 'Failed to create conversation');
    } finally {
      createConversationLoading(false);
    }
  }

  @override
  void onClose() {
    stopListenMessage();
    chatTextCtrl.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

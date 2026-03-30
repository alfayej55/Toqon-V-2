import 'dart:io';

import 'package:car_care/controllers/chat_controller.dart';
import 'package:car_care/controllers/upload_image_controller.dart';
import 'package:car_care/models/message_model.dart';
import 'package:car_care/models/profile_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../service/socket_service.dart';
import '../../base/image_picar_bottomsheet.dart';

class MessageInboxScreen extends StatefulWidget {
  const MessageInboxScreen({super.key});

  @override
  State<MessageInboxScreen> createState() => _MessageInboxScreenState();
}

class _MessageInboxScreenState extends State<MessageInboxScreen> {
  final ChatController _chatCtrl = Get.put(ChatController());
  final UploadImageController _uploadImageCtrl =
      Get.isRegistered<UploadImageController>()
          ? Get.find<UploadImageController>()
          : Get.put(UploadImageController());
  final SpeechToText _speech = SpeechToText();

  late String conversationId;
  late ProfileModel? chatPartner;
  String currentUserId = '';
  bool _isListening = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    conversationId = args?['conversationId'] ?? '';
    chatPartner = args?['chatPartner'] as ProfileModel?;

    _initChat();
  }

  Future<void> _initChat() async {

    currentUserId = await PrefsHelper.getString(AppConstants.userID);

    // Connect socket if not connected
    if (!SocketService.instance.isConnected) {
      await SocketService.instance.initialize();
      await SocketService.instance.connect();
    }

    // Get all messages first
    await _chatCtrl.getAllMessage(conversationId);

    // Then start listening for new messages
    _chatCtrl.listenMessage(conversationId);
  }

  @override
  void dispose() {
    // Stop listening when leaving screen
    _speech.stop();
    _chatCtrl.stopListenMessage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        toolbarHeight: 80,
        titleSpacing: 6,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CustomNetworkImage(
              imageUrl: chatPartner?.image ?? '',
              height: 48,
              width: 48,
              boxShape: BoxShape.circle,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatPartner?.fullName ?? 'Unknown',
                  style: AppStyles.h4(color: Get.theme.textTheme.bodyLarge!.color),
                ),
                Text(
                  'Direct message',
                  style: AppStyles.h6(color: Get.theme.textTheme.bodyMedium!.color),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Message List with GetBuilder
            Expanded(
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  if (controller.messageLoading.value) {
                    return const Center(child: CustomPageLoading());
                  }

                  return GroupedListView<MessageModel, DateTime>(
                    elements: controller.messageList,
                    controller: controller.scrollController,
                    order: GroupedListOrder.DESC,
                    itemComparator: (item1, item2) =>
                        item1.createdAt.compareTo(item2.createdAt),
                    groupBy: (MessageModel message) => DateTime(
                      message.createdAt.year,
                      message.createdAt.month,
                      message.createdAt.day,
                    ),
                    reverse: true,
                    shrinkWrap: true,
                    groupSeparatorBuilder: (DateTime date) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(TimeFormatHelper.formatDate(date)),
                        ),
                      );
                    },
                    itemBuilder: (context, MessageModel message) {
                      if (message.sender?.id == currentUserId) {
                        return senderBubble(context, message);
                      } else {
                        return receiverBubble(context, message);
                      }
                    },
                  );
                },
              ),
            ),

            // Message Input
            Obx(() {
              if (_uploadImageCtrl.imagePath.value.trim().isEmpty) {
                return const SizedBox.shrink();
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.file(
                                File(_uploadImageCtrl.imagePath.value),
                                width: 110,
                                height: 86,
                                fit: BoxFit.cover,
                              ),
                              if (_uploadImageCtrl.isUploading.value)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    alignment: Alignment.center,
                                    child: Obx(
                                      () => Text(
                                        '${(_uploadImageCtrl.uploadProgress.value * 100).toInt()}%',
                                        style: AppStyles.h6(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: InkWell(
                          onTap: () {
                            _uploadImageCtrl.imagePath.value = '';
                            _uploadImageCtrl.fileUrl.value = '';
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE44747),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: _openImagePickerSheet,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppIcons.fileIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      hintText:
                          _isListening
                              ? 'Listening... speak now'
                              : 'Write message',
                      contenpaddingHorizontal: 12,
                      contenpaddingVertical: 12,
                      maxLines: null,
                      textStyle: TextStyle(color:  Theme.of(context).textTheme.bodyLarge!.color,),
                      minLines: 1,
                      controller: _chatCtrl.chatTextCtrl,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _toggleSpeechToText,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: AppColors.brandGradient,
                        ),
                        boxShadow:
                            _isListening
                                ? [
                                  BoxShadow(
                                    color: AppColors.brandPrimary.withValues(
                                      alpha: 0.32,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Icon(
                          _isListening
                              ? Icons.stop_rounded
                              : Icons.mic_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendCurrentMessage,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child:
                            _isSending
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : SvgPicture.asset(AppIcons.sentIcon),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ImagePicarBottomsheet(
          onGalleryTap: () => _handleImagePick(ImageSource.gallery),
          onCameraTap: () => _handleImagePick(ImageSource.camera),
        );
      },
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    _uploadImageCtrl.fileUrl.value = '';
    _uploadImageCtrl.uploadComplete.value = false;
    await _uploadImageCtrl.pickImage(source);
  }

  Future<void> _sendCurrentMessage() async {
    if (_isSending) return;
    final String receiver = chatPartner?.id ?? '';
    if (receiver.isEmpty) return;

    if (_uploadImageCtrl.isUploading.value) {
      Get.snackbar(
        'Uploading',
        'Please wait until the image upload is finished.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final bool hasImage = _uploadImageCtrl.fileUrl.value.trim().isNotEmpty;
    final bool hasText = _chatCtrl.chatTextCtrl.text.trim().isNotEmpty;
    if (!hasImage && !hasText) return;

    setState(() => _isSending = true);

    try {
      if (hasImage) {
        final String url = _uploadImageCtrl.fileUrl.value.trim();
        final bool sentImage = await _chatCtrl.sendMessagePayload(
          conversationId: conversationId,
          receiverId: receiver,
          content: url,
          messageType: 'image',
          metadata: {'attachments': [url]},
        );
        if (sentImage) {
          _uploadImageCtrl.imagePath.value = '';
          _uploadImageCtrl.fileUrl.value = '';
        }
      }

      if (hasText) {
        await _chatCtrl.sendMessagePayload(
          conversationId: conversationId,
          receiverId: receiver,
          content: _chatCtrl.chatTextCtrl.text,
          messageType: 'text',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _toggleSpeechToText() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );

    if (!available) {
      Get.snackbar(
        'Voice Unavailable',
        'Microphone permission or speech service is unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        final String spoken = result.recognizedWords.trim();
        if (spoken.isEmpty) return;
        final String existing = _chatCtrl.chatTextCtrl.text.trim();
        _chatCtrl.chatTextCtrl.text =
            existing.isEmpty ? spoken : '$existing $spoken';
        _chatCtrl.chatTextCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: _chatCtrl.chatTextCtrl.text.length),
        );
      },
    );
  }

  Widget receiverBubble(BuildContext context, MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(
          imageUrl: message.sender?.image ?? '',
          boxShape: BoxShape.circle,
          height: 30,
          width: 30,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
            backGroundColor: Colors.white,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.57,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.messageType == 'image'
                      ? CustomNetworkImage(
                          imageUrl:
                              message.attachments.isNotEmpty
                                  ? message.attachments.first
                                  : message.content,
                          borderRadius: BorderRadius.circular(8),
                          height: 140,
                          width: 155,
                        )
                      : Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                  Text(
                    TimeFormatHelper.timeFormat(message.createdAt.toLocal()),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget senderBubble(BuildContext context, MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            backGroundColor: AppColors.fillColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.messageType == 'image'
                    ? CustomNetworkImage(
                        imageUrl:
                            message.attachments.isNotEmpty
                                ? message.attachments.first
                                : message.content,
                        borderRadius: BorderRadius.circular(8),
                        height: 140,
                        width: 155,
                      )
                    : Text(
                        message.content,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                Text(
                  TimeFormatHelper.timeFormat(message.createdAt.toLocal()),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.black54, fontSize: 8),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

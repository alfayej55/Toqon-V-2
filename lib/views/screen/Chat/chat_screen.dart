import 'package:car_care/controllers/chat_controller.dart';
import 'package:car_care/models/conversation_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final searchCtrl = TextEditingController();
  final ChatController _chatCtrl = Get.put(ChatController());
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    _chatCtrl.conversionsGet();
    super.initState();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Get.theme.textTheme.bodyMedium?.color,
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (_chatCtrl.conversionLoading.value) {
            return const Center(child: CustomPageLoading());
          }

          final String query = _searchQuery.value.trim().toLowerCase();
          final List<ConversationModel> conversations =
              _chatCtrl.conversionModel.where((item) {
                final String name =
                    item.chatPartner?.fullName.toLowerCase() ?? '';
                final String message = item.lastMessage.toLowerCase();
                return query.isEmpty ||
                    name.contains(query) ||
                    message.contains(query);
              }).toList();

          return Column(
            children: [

              CustomTextField(
                controller: searchCtrl,
                hintText: 'Search messages',
                contenpaddingVertical: 12,
                borderColor: AppColors.primaryColor.withValues(alpha: 0.4),
                onChanged: (value) => _searchQuery.value = value,
              ),
              const SizedBox(height: 14),
              Expanded(
                child:
                    conversations.isEmpty
                        ? Center(
                          child: Text(
                            'No conversations found',
                            style: AppStyles.h5(
                              color: AppColors.subTextColor,
                            ),
                          ),
                        )
                        : ListView.separated(
                          itemCount: conversations.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final info = conversations[index];
                            final partner = info.chatPartner;
                            final String fullName =
                                partner?.fullName.trim().isNotEmpty == true
                                    ? partner!.fullName
                                    : 'Unknown User';

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.messageInboxScreen,
                                  arguments: {
                                    'conversationId': info.id,
                                    'chatPartner': info.chatPartner,
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.cardColor.withValues(
                                            alpha: 0.6,
                                          )
                                          : Colors.white.withValues(
                                            alpha: 0.88,
                                          ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomNetworkImage(
                                      imageUrl: partner?.image ?? '',
                                      boxShape: BoxShape.circle,
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fullName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppStyles.h4(),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            info.lastMessage.isEmpty
                                                ? 'Start a conversation'
                                                : info.lastMessage,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppStyles.h6(
                                              color: AppColors.subTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          TimeFormatHelper.timeAgo(
                                            info.lastMessageAt,
                                          ),
                                          style: AppStyles.h6(
                                            color: AppColors.subTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (info.unreadCount > 0)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: AppColors.brandGradient,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              '${info.unreadCount}',
                                              style: AppStyles.h6(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),

            ],
          );
        }),
      ),
    );
  }
}

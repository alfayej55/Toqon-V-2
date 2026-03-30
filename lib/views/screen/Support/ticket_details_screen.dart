import 'package:car_care/controllers/get_help_controller.dart';
import 'package:car_care/models/support_ticket_model.dart';
import 'package:car_care/models/ticket_reply_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:grouped_list/grouped_list.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final GetHelpController _ctrl = Get.find<GetHelpController>();
  late SupportTicketModel ticket;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    ticket = args?['ticket'] as SupportTicketModel;
    _ctrl.getTicketReplies(ticket.id);
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
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: AppColors.brandGradient),
              ),
              child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.subject,
                    style: AppStyles.h4(color: Get.theme.textTheme.bodyLarge!.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ticket.status.toLowerCase() == 'open'
                              ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                              : const Color(0xFF6B7280).withValues(alpha: 0.15),
                        ),
                        child: Text(
                          ticket.status.toUpperCase(),
                          style: AppStyles.h6(
                            color: ticket.status.toLowerCase() == 'open'
                                ? const Color(0xFF22C55E)
                                : const Color(0xFF6B7280),
                            fontFamily: 'InterSemiBold',
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (ticket.referenceNo != null)
                        Text(
                          ticket.referenceNo!,
                          style: AppStyles.h6(color: AppColors.subTextColor),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_ctrl.repliesLoading.value) {
                  return const Center(child: CustomPageLoading());
                }

                final List<TicketReplyModel> replies = _ctrl.ticketReplies;

                if (replies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: AppColors.subTextColor.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No replies yet',
                          style: AppStyles.h5(color: AppColors.subTextColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Support team will respond soon',
                          style: AppStyles.h6(color: AppColors.subTextColor),
                        ),
                      ],
                    ),
                  );
                }

                return GroupedListView<TicketReplyModel, DateTime>(
                  elements: replies,
                  order: GroupedListOrder.DESC,
                  reverse: true,
                  shrinkWrap: true,
                  itemComparator: (item1, item2) => item1.createdAt.compareTo(item2.createdAt),
                  groupBy: (TicketReplyModel reply) => DateTime(
                    reply.createdAt.year,
                    reply.createdAt.month,
                    reply.createdAt.day,
                  ),
                  groupSeparatorBuilder: (DateTime date) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          TimeFormatHelper.formatDate(date),
                          style: AppStyles.h6(color: AppColors.subTextColor),
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, TicketReplyModel reply) {
                    if (reply.isFromSupport) {
                      return _supportBubble(context, reply);
                    } else {
                      return _userBubble(context, reply);
                    }
                  },
                );
              }),
            ),

            // Message Input
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Write your reply...',
                      contenpaddingHorizontal: 14,
                      contenpaddingVertical: 12,
                      maxLines: null,
                      minLines: 1,
                      controller: _ctrl.replyMessageCtrl,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => InkWell(
                      onTap: _ctrl.sendingReply.value
                          ? null
                          : () => _ctrl.sendTicketReply(ticket.id),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: AppColors.brandGradient),
                        ),
                        child: Center(
                          child: _ctrl.sendingReply.value
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
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

  /// Support message bubble (Left side)
  Widget _supportBubble(BuildContext context, TicketReplyModel reply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: AppColors.brandGradient),
          ),
          child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
            backGroundColor: Colors.white,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply.senderName ?? 'Support Team',
                    style: AppStyles.h6(
                      color: AppColors.primaryColor,
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reply.message,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TimeFormatHelper.timeFormat(reply.createdAt.toLocal()),
                    style: const TextStyle(color: Colors.black45, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// User message bubble (Right side)
  Widget _userBubble(BuildContext context, TicketReplyModel reply) {
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
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    reply.message,
                    style: const TextStyle(color: Colors.black87),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TimeFormatHelper.timeFormat(reply.createdAt.toLocal()),
                    style: const TextStyle(color: Colors.black45, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
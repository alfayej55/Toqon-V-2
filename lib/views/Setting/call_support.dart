import 'package:car_care/controllers/get_help_controller.dart';
import 'package:car_care/models/support_ticket_model.dart';
import 'package:car_care/views/base/custom_gradiand_button.dart';
import 'package:car_care/views/base/custom_empty_state.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:intl/intl.dart';

class CallSupportScreen extends StatefulWidget {
  const CallSupportScreen({super.key});

  @override
  State<CallSupportScreen> createState() => _CallSupportScreenState();
}

class _CallSupportScreenState extends State<CallSupportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GetHelpController _ctrl =
      Get.isRegistered<GetHelpController>()
          ? Get.find<GetHelpController>()
          : Get.put(GetHelpController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Get Help'),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        child: Column(
          children: [
            _tabs(),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _liveChatTab(),
                  _emailTab(),
                  _ticketsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white,
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.35)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.subTextColor,
        labelStyle: AppStyles.h6(fontFamily: 'InterSemiBold'),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: AppColors.brandGradient),
        ),
        tabs: const [
          Tab(text: 'Live Chat'),
          Tab(text: 'Email'),
          Tab(text: 'Tickets'),
        ],
      ),
    );
  }

  Widget _liveChatTab() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        _heroCard(
          icon: Icons.support_agent_rounded,
          title: 'Live Chat Support',
          subtitle: 'Talk to our support team in real-time for instant assistance.',
          statusText: 'Agents online now',
        ),
        const SizedBox(height: 12),
        CustomGradientButton(
          onTap: _ctrl.startLiveChat,
          text: 'Start Live Chat',
          height: 46,
          borderRadius: BorderRadius.circular(14),
          showGlow: false,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Average response time: 2 minutes',
            style: AppStyles.h6(color: AppColors.subTextColor),
          ),
        ),
        const SizedBox(height: 14),
        _smallAction(
          icon: Icons.smart_toy_outlined,
          title: 'Need quick guidance first?',
          subtitle: 'Ask CARA AI to diagnose issues before chatting with an agent.',
          action: 'Open CARA',
          onTap: _ctrl.openCaraAi,
        ),
        const SizedBox(height: 10),
        _smallAction(
          icon: Icons.call_outlined,
          title: 'Emergency support line',
          subtitle: GetHelpController.supportPhone,
          action: 'Call Now',
          onTap: _ctrl.makeSupportCall,
        ),
      ],
    );
  }

  Widget _emailTab() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        _heroCard(
          icon: Icons.email_outlined,
          title: 'Email Support',
          subtitle: 'Share full issue details and screenshots through email support.',
          statusText: GetHelpController.supportEmail,
        ),
        const SizedBox(height: 12),
        CustomComponetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject', style: AppStyles.h5(fontFamily: 'InterSemiBold')),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _ctrl.emailSubjectCtrl,
                hintText: 'e.g. Payment not reflected',
                contenpaddingVertical: 12,
              ),
              const SizedBox(height: 10),
              Text('Message', style: AppStyles.h5(fontFamily: 'InterSemiBold')),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _ctrl.emailMessageCtrl,
                hintText: 'Please describe your issue...',
                maxLines: null,
                minLines: 4,
                contenpaddingVertical: 12,
              ),
              const SizedBox(height: 12),
              CustomGradientButton(
                onTap: _ctrl.sendSupportEmail,
                text: 'Send Email',
                showGlow: false,
                height: 44,
                borderRadius: BorderRadius.circular(14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ticketsTab() {
    return Obx(() {
      final List<SupportTicketModel> list = _ctrl.filteredTickets;
      return RefreshIndicator(
        onRefresh: _ctrl.fetchTickets,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            CustomComponetCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Ticket',
                    style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _ctrl.ticketSubjectCtrl,
                    hintText: 'Ticket subject',
                    contenpaddingVertical: 12,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _priorityChip('low'),
                      const SizedBox(width: 8),
                      _priorityChip('medium'),
                      const SizedBox(width: 8),
                      _priorityChip('high'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _ctrl.ticketMessageCtrl,
                    hintText: 'Describe your issue in detail',
                    maxLines: null,
                    minLines: 3,
                    contenpaddingVertical: 12,
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => CustomGradientButton(
                      onTap: () {
                        _ctrl.createTicket(
                          subject: _ctrl.ticketSubjectCtrl.text,
                          description: _ctrl.ticketMessageCtrl.text,
                          priority: _ctrl.selectedTicketPriority.value,
                          channel: 'app',
                        );
                      },
                      loading: _ctrl.creatingTicket.value,
                      text: 'Submit Ticket',
                      showGlow: false,
                      height: 44,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _ticketFilters(),
            const SizedBox(height: 8),
            if (_ctrl.loadingTickets.value)
              const Center(child: CustomPageLoading())
            else if (list.isEmpty)
              CustomEmptyState(
                icon: AppIcons.getHelpIcon,
                title: 'No Tickets Yet',
                subtitle: 'Your submitted support tickets will appear here.',
              )
            else
              ...list.map(_ticketCard),
          ],
        ),
      );
    });
  }

  Widget _ticketFilters() {
    final List<String> filters = ['all', 'open', 'resolved'];
    return Obx(
      () => Row(
        children:
            filters.map((f) {
              final bool selected = _ctrl.ticketFilter.value == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => _ctrl.ticketFilter.value = f,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient:
                          selected
                              ? const LinearGradient(
                                colors: AppColors.brandGradient,
                              )
                              : null,
                      color: selected ? null : Colors.transparent,
                      border: Border.all(
                        color:
                            selected
                                ? Colors.white.withValues(alpha: 0.24)
                                : AppColors.borderColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      f.toUpperCase(),
                      style: AppStyles.h6(
                        color: selected ? Colors.white : AppColors.subTextColor,
                        fontFamily: 'InterSemiBold',
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _priorityChip(String priority) {
    return Obx(() {
      final bool selected = _ctrl.selectedTicketPriority.value == priority;
      return InkWell(
        onTap: () => _ctrl.selectedTicketPriority.value = priority,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient:
                selected ? const LinearGradient(colors: AppColors.brandGradient) : null,
            color: selected ? null : Colors.transparent,
            border: Border.all(
              color:
                  selected
                      ? Colors.white.withValues(alpha: 0.24)
                      : AppColors.borderColor.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            priority.toUpperCase(),
            style: AppStyles.h6(
              fontFamily: 'InterSemiBold',
              color: selected ? Colors.white : AppColors.subTextColor,
            ),
          ),
        ),
      );
    });
  }

  Widget _heroCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusText,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: AppColors.brandGradient),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.h4(
                    color: Colors.white,
                    fontFamily: 'InterSemiBold',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: AppStyles.h6(color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, color: Color(0xFF22C55E), size: 10),
              const SizedBox(width: 6),
              Text(
                statusText,
                style: AppStyles.h6(
                  color: Colors.white.withValues(alpha: 0.94),
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onTap,
  }) {
    return CustomComponetCard(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor.withValues(alpha: 0.13),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.h5(fontFamily: 'InterSemiBold')),
                Text(subtitle, style: AppStyles.h6(color: AppColors.subTextColor)),
              ],
            ),
          ),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    );
  }

  Widget _ticketCard(SupportTicketModel ticket) {
    final bool open = ticket.status.toLowerCase() == 'open';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CustomComponetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color:
                        open
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFE5E7EB),
                  ),
                  child: Text(
                    ticket.status.toUpperCase(),
                    style: AppStyles.h6(
                      color:
                          open
                              ? const Color(0xFF166534)
                              : const Color(0xFF374151),
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.h6(color: AppColors.subTextColor),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Priority: ${ticket.priority.toUpperCase()}',
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat('MMM d, yyyy').format(ticket.createdAt),
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
                if (ticket.referenceNo != null && ticket.referenceNo!.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ticket.referenceNo!,
                      style: AppStyles.h6(
                        color: AppColors.primaryColor,
                        fontFamily: 'InterSemiBold',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

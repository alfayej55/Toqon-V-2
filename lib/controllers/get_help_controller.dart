import 'package:car_care/all_export.dart';
import 'package:car_care/models/support_ticket_model.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:car_care/service/dio_api_client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelpController extends GetxController {
  static const String supportPhone = '+1 (437) 973-1676';
  static const String supportPhoneDial = '+14379731676';
  static const String supportEmail = 'support@carcare24x7.com';

  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Email Controllers
  TextEditingController emailSubjectCtrl = TextEditingController();
  TextEditingController emailMessageCtrl = TextEditingController();

  /// Ticket Controllers
  TextEditingController ticketSubjectCtrl = TextEditingController();
  TextEditingController ticketMessageCtrl = TextEditingController();

  /// Loading States
  var sendEmailLoading = false.obs;
  var creatingTicket = false.obs;
  var loadingTickets = false.obs;

  /// Ticket Priority & Filter
  var selectedTicketPriority = 'medium'.obs;
  var ticketFilter = 'all'.obs;

  /// Tickets List
  RxList<SupportTicketModel> tickets = <SupportTicketModel>[].obs;

  /// Filtered Tickets
  List<SupportTicketModel> get filteredTickets {
    if (ticketFilter.value == 'all') return tickets;
    return tickets
        .where((e) => e.status.toLowerCase() == ticketFilter.value)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  /// Send Email Function
  Future<void> sendSupportEmail() async {
    sendEmailLoading.value = true;

    try {
      var body = {
        "subject": emailSubjectCtrl.text.trim(),
        "message": emailMessageCtrl.text.trim(),
      };

      final response = await _apiClient.postData(
        ApiConstants.sendEmailEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        Get.snackbar('Success', 'Email sent successfully');
        emailSubjectCtrl.clear();
        emailMessageCtrl.clear();
        Get.back();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Send Email Error: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      sendEmailLoading.value = false;
    }
  }

  /// Create Ticket Function
  Future<void> createTicket({
    required String subject,
    required String description,
    required String priority,
    required String channel,
  }) async {
    creatingTicket.value = true;

    try {
      var body = {
        "subject": subject.trim(),
        "message": description.trim(),
        "priority": priority,
      };

      final response = await _apiClient.postData(
        ApiConstants.supportTicketsEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        Get.snackbar('Success', 'Ticket submitted successfully');
        ticketSubjectCtrl.clear();
        ticketMessageCtrl.clear();
        selectedTicketPriority.value = 'medium';
        fetchTickets();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Create Ticket Error: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      creatingTicket.value = false;
    }
  }

  /// Fetch Tickets Function
  Future<void> fetchTickets() async {
    loadingTickets.value = true;

    try {
      final response = await _apiClient.getData(
        ApiConstants.supportTicketsEndPoint,
      );

      if (response.isSuccess) {
        final List<dynamic> ticketsData =
            response.data['data']['attributes']['results'];
        tickets.value = ticketsData
            .map((ticket) =>
                SupportTicketModel.fromJson(ticket as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Fetch Tickets Error: $e');
    } finally {
      loadingTickets.value = false;
    }
  }

  /// Start Live Chat
  void startLiveChat() {
    Get.toNamed(AppRoutes.chatScreen);
  }

  /// Open CARA AI
  void openCaraAi() {
    Get.toNamed(AppRoutes.aiDetection);
  }

  /// Make Support Call
  Future<void> makeSupportCall() async {
    final Uri uri = Uri.parse('tel:$supportPhoneDial');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not open dialer on this device.');
    }
  }

  @override
  void onClose() {
    emailSubjectCtrl.dispose();
    emailMessageCtrl.dispose();
    ticketSubjectCtrl.dispose();
    ticketMessageCtrl.dispose();
    super.onClose();
  }
}
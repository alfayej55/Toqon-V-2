import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../helpers/prefs_helpers.dart';
import '../utils/app_constants.dart';

/// Payment Result Status
enum PaymentStatus { success, cancelled, failed, pending }

/// Payment Result Model
class PaymentResult {
  final PaymentStatus status;
  final String? transactionId;
  final String? paymentIntentId;
  final String? message;
  final String? errorMessage;

  PaymentResult({
    required this.status,
    this.transactionId,
    this.paymentIntentId,
    this.message,
    this.errorMessage,
  });

  bool get isSuccess => status == PaymentStatus.success;
  bool get isCancelled => status == PaymentStatus.cancelled;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isPending => status == PaymentStatus.pending;
}

/// ==================== PROFESSIONAL PAYMENT SERVICE ====================
///
/// Architecture Flow:
/// 1. Frontend calls Backend to create PaymentIntent (Backend saves with "pending" status)
/// 2. Backend returns client_secret to Frontend
/// 3. User completes payment via Stripe Payment Sheet
/// 4. Stripe sends Webhook to Backend (payment confirmed)
/// 5. Backend updates payment status to "completed"
/// 6. Frontend polls/checks payment status from Backend
///
/// Why this is secure:
/// - Payment record is created BEFORE payment happens
/// - Webhook ensures Backend gets notified even if app crashes
/// - No money lost scenario possible
///
class PaymentService {
  // Backend base URL
  static const String _backendBaseUrl = 'https://arif-3.sobhoy.com/api/v1';

  /// Get headers with auth token from PrefsHelper
  Future<Map<String, String>> _getHeaders() async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// ========================= STEP 1: Create Payment Intent via Backend =========================
  /// Backend e payment intent create koro - ei step e backend payment record save kore "pending" status e
  Future<Map<String, dynamic>?> _createPaymentIntentFromBackend({
    required double amount,
    required String currency,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/payment/wallet/recharge'),
        headers: headers,
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
        }),
      );

      debugPrint('Create Intent Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      // Error response
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to create payment intent');
    } catch (e) {
      debugPrint('Create Payment Intent Error: $e');
      rethrow;
    }
  }

  /// ========================= STEP 2: Make Payment (Main Method) =========================
  Future<PaymentResult> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      // STEP 1: Backend e payment intent create koro
      // Backend ekhane Stripe e payment intent create korbe AND database e save korbe "pending" status e
      final intentResponse = await _createPaymentIntentFromBackend(
        amount: amount,
        currency: currency,

      );

      if (intentResponse == null) {
        return PaymentResult(
          status: PaymentStatus.failed,
          errorMessage: 'Could not create payment. Please try again.',
        );
      }

      // Backend response: { "data": { "clientSecret": "...", "paymentIntentId": "..." } }
      final data = intentResponse['data'];
      final String clientSecret = data['clientSecret'];
      final String paymentIntentId = data['paymentIntentId'];

      debugPrint('Payment Intent Created: $paymentIntentId');

      // STEP 2: Stripe Payment Sheet initialize koro
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'CarCare 24x7',
          paymentIntentClientSecret: clientSecret,
          allowsDelayedPaymentMethods: false, // Production e false rakhbe
          style: ThemeMode.light,
        ),
      );

      // STEP 3: Payment Sheet show koro
      await Stripe.instance.presentPaymentSheet();

      final verifyResult = await _verifyPaymentStatus(paymentIntentId);

      debugPrint('dfsdfasdlfdfasldkfasdf>>>>>>>>>$verifyResult');

      if (verifyResult) {
        return PaymentResult(
          status: PaymentStatus.success,
          paymentIntentId: paymentIntentId,
          message: 'Payment successful!',
        );
      } else {
        return PaymentResult(
          status: PaymentStatus.pending,
          paymentIntentId: paymentIntentId,
          message: 'Payment is being processed. You will be notified shortly.',
        );
      }

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        debugPrint('Payment Cancelled by user');
        return PaymentResult(
          status: PaymentStatus.cancelled,
          message: 'Payment cancelled',
        );
      }
      debugPrint('Stripe Error: ${e.error.localizedMessage}');
      return PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: e.error.localizedMessage ?? 'Payment failed',
      );
    } catch (e) {
      debugPrint('Payment Error: $e');
      return PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  /// ========================= STEP 3: Verify Payment Status from Backend =========================

  Future<bool> _verifyPaymentStatus(String paymentIntentId) async {
    try {
      // Small delay to allow webhook processing
      await Future.delayed(const Duration(seconds: 2));

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/payment/status/$paymentIntentId'),
        headers: headers,
      );
      final data = jsonDecode(response.body);
      debugPrint('Dataaaaddfsdf>>>>${data['data']['attributes']['status']}');

      if (response.statusCode == 200 || response.statusCode==201) {
        final data = jsonDecode(response.body);
         return data['data']['attributes']['status'] == 'completed' ;
      } else{
        return false;
      }

    } catch (e) {
      debugPrint('Verify Payment Error: $e');
      return false;
    }
  }

  /// ========================= Check Payment Status (Public) =========================
  //
  // Future<PaymentResult> checkPaymentStatus(String paymentIntentId) async {
  //   try {
  //     final headers = await _getHeaders();
  //     final response = await http.get(
  //       Uri.parse('$_backendBaseUrl/payment/status/$paymentIntentId'),
  //       headers: headers,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final status = data['status'];
  //
  //       print('Statusss>>>>>>>>>>>>>>>>>>$status');
  //
  //       switch (status) {
  //         case 'completed':
  //         case 'succeeded':
  //           return PaymentResult(
  //             status: PaymentStatus.success,
  //             paymentIntentId: paymentIntentId,
  //             transactionId: data['transaction_id'],
  //             message: 'Payment completed',
  //           );
  //         case 'pending':
  //         case 'processing':
  //           return PaymentResult(
  //             status: PaymentStatus.pending,
  //             paymentIntentId: paymentIntentId,
  //             message: 'Payment is being processed',
  //           );
  //         case 'cancelled':
  //           return PaymentResult(
  //             status: PaymentStatus.cancelled,
  //             paymentIntentId: paymentIntentId,
  //             message: 'Payment was cancelled',
  //           );
  //         default:
  //           return PaymentResult(
  //             status: PaymentStatus.failed,
  //             paymentIntentId: paymentIntentId,
  //             errorMessage: 'Payment failed',
  //           );
  //       }
  //     }
  //
  //     return PaymentResult(
  //       status: PaymentStatus.failed,
  //       errorMessage: 'Could not check payment status',
  //     );
  //   } catch (e) {
  //     return PaymentResult(
  //       status: PaymentStatus.failed,
  //       errorMessage: 'Network error. Please check your connection.',
  //     );
  //   }
  // }
}
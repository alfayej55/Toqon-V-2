import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

import '../models/more_earn_model.dart';
import '../models/redeem_model.dart';
import '../models/wallet_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';
import '../service/payment_mathod.dart';


class WalletController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    getBalance();
  }

  final ApiClient _apiClient = Get.put(ApiClient());

  final PaymentService _paymentService = PaymentService();

  TextEditingController amountTextCtrl=TextEditingController();
  var paymentLoading=false.obs;
  var balanceLoading=false.obs;

  Rx<WalletModel?> walletModel = WalletModel.fromJson({}).obs;

  var moreEarnLoading = false.obs;
  RxList<MoreEarnModel> moreEarnList = <MoreEarnModel>[].obs;

  /// Referral Code
  var referralCode = ''.obs;
  var referralPoints = 0.obs;

  /// My Earn Points
  var myPoints = 0.obs;

  /// Redeem
  var redeemLoading = false.obs;
  RxList<RedeemModel> redeemList = <RedeemModel>[].obs;

  /// ==================== GET BALANCE ====================

  Future<void> getBalance() async {
    balanceLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.walletBalance);
      if (response.isSuccess) {
        walletModel.value = WalletModel.fromJson(response.data['data']);
      }
    } catch (e) {
      debugPrint('Failed to fetch wallet balance: $e');
    } finally {
      balanceLoading.value = false;
    }
  }

  /// ==================== PAYMENT HANDLER ====================

  Future<void> handlePayment() async {

    paymentLoading(true);

    try {
      final result = await _paymentService.makePayment(
        amount: double.parse(amountTextCtrl.text),
        currency: 'CAD',
      );
      paymentLoading(false);

      if (result.isSuccess) {

        Get.snackbar(
          'Success',
          'Payment successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getBalance();
        amountTextCtrl.clear();
        Get.back();
        paymentLoading(false);
      } else if (result.isPending) {
        // ⏳ Payment processing
        Get.snackbar(
          'Processing',
          'Payment is being processed. Please wait...',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        paymentLoading(false);
      } else if (result.isCancelled) {
        // ❌ User cancelled
        Get.snackbar(
          'Cancelled',
          'Payment was cancelled',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );

      } else {
        // ❌ Payment failed
        Get.snackbar(
          'Error',
          result.errorMessage ?? 'Payment failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      paymentLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }
  }

  /// ==================== REFERRAL CODE ====================

  Future<void> getReferralCode() async {
    try {
      final response = await _apiClient.getData(ApiConstants.earnPointReferrCodeEndPoint);
      if (response.isSuccess) {
        final attributes = response.data['data']['attributes'];
        referralCode.value = attributes['referralCode'] ?? '';
        referralPoints.value = attributes['pointsValue'] ?? 0;
      }
    } catch (e) {
      debugPrint('Failed to fetch referral code: $e');
    }
  }

  /// ==================== MY EARN POINTS ====================

  Future<void> getMyEarnPoint() async {
    try {
      final response = await _apiClient.getData(ApiConstants.earnMyPointEndPoint);
      if (response.isSuccess) {
        myPoints.value = response.data['data']['attributes']['totalPoints'] ?? 0;
      }
    } catch (e) {
      debugPrint('Failed to fetch my earn points: $e');
    }
  }

  /// ==================== REDEEM ====================

  Future<void> getRedeem() async {
    redeemLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.redeemEndPoint);
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['attributes']['results'];
        redeemList.value = data
            .map((e) => RedeemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to fetch redeem: $e');
    } finally {
      redeemLoading.value = false;
    }
  }

  /// ==================== MORE EARN ====================

  Future<void> getMoreEarn() async {
    moreEarnLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.moreEarnEndPoint);
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['attributes']['results'];
        moreEarnList.value = data
            .map((e) => MoreEarnModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to fetch more earn: $e');
    } finally {
      moreEarnLoading.value = false;
    }
  }
}
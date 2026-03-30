
import 'package:car_care/all_export.dart';
import 'package:car_care/models/offer_model.dart';
import 'package:flutter/foundation.dart';

import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class OfferController extends GetxController{
  // Inject ApiClient
  final ApiClient _apiClient = Get.find<ApiClient>();


  /// Get My Al Service
  var offerLoading = false.obs;
  RxList<OfferModel> offerModelList=<OfferModel>[].obs;
  getActiveOffer()async{
    offerLoading(true);
    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.offerEndpoint);
      // Handle response
      if (response.isSuccess) {
        // Assign categories to serviceList
        offerModelList.value = List<OfferModel>.from(
            response.data['data']['results'].map((x) => OfferModel.fromJson(x))
        );
      }
    } catch (e) {
      debugPrint('Get Active Offer Error: $e');
    } finally {
      offerLoading.value = false;
    }
  }



  }
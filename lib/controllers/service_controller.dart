import 'package:car_care/models/booking_model.dart';
import 'package:car_care/models/catagori_model.dart';
import 'package:car_care/models/garage_profile_model.dart';
import 'package:car_care/models/service_model.dart';
import 'package:car_care/views/base/worning_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helpers/route.dart';
import '../models/vahical_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class ServiceController extends GetxController {
// Inject ApiClient
  final ApiClient _apiClient = Get.put(ApiClient());



  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await  getCategory();
    });
    super.onInit();
    // Initialize or fetch services
  }

  /// Get Category

  var catagoryLoading = false.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  Future<void> getCategory() async {
    catagoryLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.categoryEndPoint);
      // Handle response
      if (response.isSuccess) {
        final List<dynamic> vehiclesData = response.data['data']['attributes']['results'];
        final List<CategoryModel> parsed = vehiclesData
            .map((vehicle) => CategoryModel.fromJson(vehicle as Map<String, dynamic>))
            .toList();
        categoryList.value = parsed.isNotEmpty ? parsed : _fallbackCategories();
      } else {
        categoryList.value = _fallbackCategories();
        Get.snackbar('Notice', 'Showing curated service categories.');
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicles: $e');
      categoryList.value = _fallbackCategories();
      Get.snackbar('Notice', 'Unable to load server categories. Using defaults.');
    } finally {

      catagoryLoading.value = false;

    }
  }

  List<CategoryModel> _fallbackCategories() {
    final DateTime now = DateTime.now();
    return <CategoryModel>[
      CategoryModel(
        id: 'fallback_oil_change',
        categoryName: 'Oil Change & Fluid Service',
        categoryType: 'maintenance',
        categoryDescription: 'Engine oil, filter change, top-up and full fluid health check.',
        categoryImage: 'https://images.unsplash.com/photo-1486006920555-c77dcf18193c?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 34,
        averageRating: '4.8',
      ),
      CategoryModel(
        id: 'fallback_brake_service',
        categoryName: 'Brake Service',
        categoryType: 'safety',
        categoryDescription: 'Pads, rotors, calipers, brake fluid and safety diagnostics.',
        categoryImage: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: true,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 28,
        averageRating: '4.7',
      ),
      CategoryModel(
        id: 'fallback_battery',
        categoryName: 'Battery & Electrical',
        categoryType: 'electrical',
        categoryDescription: 'Battery test/replacement, alternator and electrical troubleshooting.',
        categoryImage: 'https://images.unsplash.com/photo-1632823471565-1ecdf8ad91a2?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: true,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 19,
        averageRating: '4.6',
      ),
      CategoryModel(
        id: 'fallback_tire',
        categoryName: 'Tires & Wheel Alignment',
        categoryType: 'maintenance',
        categoryDescription: 'Rotation, balancing, puncture fix and wheel alignment setup.',
        categoryImage: 'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 31,
        averageRating: '4.7',
      ),
      CategoryModel(
        id: 'fallback_engine_diagnostics',
        categoryName: 'Engine Diagnostics',
        categoryType: 'diagnostics',
        categoryDescription: 'Check-engine scan, fault codes, sensor and performance analysis.',
        categoryImage: 'https://images.unsplash.com/photo-1615906655593-ad0386982a0f?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 23,
        averageRating: '4.8',
      ),
      CategoryModel(
        id: 'fallback_ac',
        categoryName: 'A/C & Climate Control',
        categoryType: 'comfort',
        categoryDescription: 'A/C gas refill, compressor checks and cooling performance tune-up.',
        categoryImage: 'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 15,
        averageRating: '4.5',
      ),
      CategoryModel(
        id: 'fallback_detailing',
        categoryName: 'Detailing & Car Wash',
        categoryType: 'detailing',
        categoryDescription: 'Interior deep clean, exterior polish, wax and premium detailing.',
        categoryImage: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 22,
        averageRating: '4.9',
      ),
      CategoryModel(
        id: 'fallback_ceramic',
        categoryName: 'Ceramic Coating',
        categoryType: 'detailing',
        categoryDescription: 'Long-lasting paint protection with gloss enhancement and hydrophobic coat.',
        categoryImage: 'https://images.unsplash.com/photo-1484130499497-c3de809fd3ef?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 11,
        averageRating: '4.8',
      ),
      CategoryModel(
        id: 'fallback_body_paint',
        categoryName: 'Body Repair & Paint',
        categoryType: 'repair',
        categoryDescription: 'Dent, scratch, bumper and complete body-paint restoration service.',
        categoryImage: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: true,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 14,
        averageRating: '4.6',
      ),
      CategoryModel(
        id: 'fallback_suspension',
        categoryName: 'Suspension & Steering',
        categoryType: 'safety',
        categoryDescription: 'Shock absorbers, steering response and suspension stability service.',
        categoryImage: 'https://images.unsplash.com/photo-1485291571150-772bcfc10da5?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 12,
        averageRating: '4.5',
      ),
      CategoryModel(
        id: 'fallback_roadside',
        categoryName: 'Roadside Assistance',
        categoryType: 'emergency',
        categoryDescription: 'Jump start, towing, lockout and emergency on-road support.',
        categoryImage: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: true,
        isEmergency: true,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 26,
        averageRating: '4.7',
      ),
      CategoryModel(
        id: 'fallback_inspection',
        categoryName: 'Inspection & Certification',
        categoryType: 'compliance',
        categoryDescription: 'Pre-purchase checks, safety inspection and certification support.',
        categoryImage: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=1000&auto=format&fit=crop',
        isActive: true,
        isDeleted: false,
        isPopular: false,
        isEmergency: false,
        createdAt: now,
        updatedAt: now,
        v: 0,
        nearbyServiceCount: 17,
        averageRating: '4.6',
      ),
    ];
  }



  /// Service Section

  var serviceLoading = false.obs;
  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;

  Future<void> getService(String categoryId,String type) async {
    serviceLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.serviceEndPoint,queryParameters:
      {
        'serviceCategory':categoryId,
        'sortBy' : type

      }
      );
      // Handle response
      if (response.isSuccess) {
        final List<dynamic> serviceData = response.data['data']['attributes']['results'];
        serviceList.value = serviceData
            .map((vehicle) => ServiceModel.fromJson(vehicle as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicles: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      serviceLoading.value = false;
    }
  }

  /// Service Details

  var serviceDetailsLoading = false.obs;
  Rx<ServiceModel> serviceDetails = ServiceModel.fromJson({}).obs;

  Future<void> getServiceDetails(String serviceId) async {
    serviceDetailsLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.serviceDetailsEndPoint(serviceId));
      // Handle response
      if (response.isSuccess) {
        final serviceData = response.data['data']['attributes'];
        serviceDetails.value = ServiceModel.fromJson(serviceData as Map<String, dynamic>);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch service details: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      serviceDetailsLoading.value = false;
    }
  }


  /// Get Profile Info
  var garageProfileLoading = false.obs;

  Rx<GarageProfile> garegeprofileModel=GarageProfile.fromJson({}).obs;

  Future<void> profileInfoGet(String garageId) async {
    garageProfileLoading.value = true;
    try {
      // API Call
      final response = await _apiClient.getData(
          '${ApiConstants.garageEndPoint}/$garageId',

      );
      // Handle response
      if (response.isSuccess) {
        garegeprofileModel.value=GarageProfile.fromJson(response.data['data']['attributes']);
      }
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
    } finally {
      garageProfileLoading.value = false;
    }
  }



  /// Get Vehicles

  var vehiclesLoading = false.obs;
  RxList<VehiclesModel> vehiclesList = <VehiclesModel>[].obs;

  Future<void> getVehicles() async {
    vehiclesLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.vehiclesEndpoint);
      // Handle response
      if (response.isSuccess) {
        final List<dynamic> vehiclesData = response.data['data']['attributes']['results'];
        vehiclesList.value = vehiclesData
            .map((vehicle) => VehiclesModel.fromJson(vehicle as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicles: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {

      vehiclesLoading.value = false;

    }
  }


  /// Create Service Booking

  TextEditingController nameTextCtrl =TextEditingController();
  TextEditingController phoneTextCtrl =TextEditingController();
  TextEditingController descriptionTextCtrl =TextEditingController();

  var serviceVehicleId=''.obs;
  var selectedDate=''.obs;
  var selectVehicle=''.obs;
  Rx<String> selectedTime=''.obs;

  var bookingLoading = false.obs;

  Future<bool> createBooking({
    required String bookingType,
    required String serviceID,
  }) async {
    bookingLoading.value = true;
    try {
      // Build request body based on bookingType
      Map<String, dynamic> body = {
        "bookingType": bookingType,
        "scheduledDate": selectedDate.value,
        "scheduledTime": selectedTime.value,
      };

      // Add vehicle if selected
      if (serviceVehicleId.value.isNotEmpty) {
        body["vehicle"] = serviceVehicleId.value;
      }

      // Add appropriate ID field based on booking type
      switch (bookingType) {
        case 'manual':
          body["service"] = serviceID;
          break;
        case 'offer':
          body["offerId"] = serviceID;
          break;
        case 'community_offer':
          body["communityOfferId"] = serviceID;
          break;
        case 'custom_offer':
          body["customOfferId"] = serviceID;
          break;
        default:
          body["service"] = serviceID;
      }

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.bookingEndPoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        Get.toNamed(AppRoutes.bookingConfirmScreen);

        return true;
      } else {
        // Check for insufficient wallet balance (status 402 or message)
        if (response.statusCode == 402 ||
            response.message.toLowerCase().contains('insufficient wallet balance')) {
          _showInsufficientBalanceDialog(response.message);
        } else {
          Get.snackbar('Error', response.message);
        }
        return false;
      }
    } catch (e) {
      debugPrint('Failed to create booking: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      return false;
    } finally {
      bookingLoading.value = false;
    }
  }

  /// Show dialog for insufficient wallet balance
  void _showInsufficientBalanceDialog(String message) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (Get.context != null) {
        Get.dialog(
          CustomDialog(
            title: 'Insufficient Balance',
            message: message,
            confirmText: 'Recharge',
            cancelText: 'Cancel',
            onConfirm: () {
              Get.back(); // Close dialog
              Get.toNamed(AppRoutes.walletScreen);
            },
          ),
          barrierDismissible: true,
        );
      }
    });
  }


  Future<void> selectDate(BuildContext context) async {
    List<int> closedWeekdays = _getClosedWeekdays();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _getNextOpenDate(closedWeekdays),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        selectableDayPredicate: closedWeekdays.isEmpty
            ? null
            : (DateTime date) => !closedWeekdays.contains(date.weekday),
    );

    if (picked != null) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  List<int> _getClosedWeekdays() {
    const Map<String, int> dayToWeekday = {
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
      'sunday': 7,
    };

    return garegeprofileModel.value.openingHours
        .where((hour) => !hour.isOpen)
        .map((hour) => dayToWeekday[hour.day.toLowerCase()])
        .whereType<int>()
        .toList();
  }

  DateTime _getNextOpenDate(List<int> closedWeekdays) {
    // Safety: if all 7 days closed or no data, return today
    if (closedWeekdays.length >= 7 || closedWeekdays.isEmpty) {
      return DateTime.now();
    }

    DateTime date = DateTime.now();
    int maxAttempts = 7;

    while (closedWeekdays.contains(date.weekday) && maxAttempts > 0) {
      date = date.add(const Duration(days: 1));
      maxAttempts--;
    }
    return date;
  }


  /// Get All Booking

  var myBookingLoading = false.obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;

  Future<void> getBooking(String status) async {
    myBookingLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.bookingGetEndPoint(status));
      // Handle response
      if (response.isSuccess) {
        final List<dynamic> booking = response.data['data']['attributes']['results'];
        bookingList.value = booking
            .map((vehicle) => BookingModel.fromJson(vehicle as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicles: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {

      myBookingLoading.value = false;

    }
  }

  /// Booking Details

  var bookingDetailsLoading = false.obs;
  Rx<BookingModel> bookingDetails = BookingModel.fromJson({}).obs;

  Future<void> getBookingDetails(String bookingId) async {
    bookingDetailsLoading.value = true;

    try {
      // API Call
      final response = await _apiClient.getData(ApiConstants.bookingDetailsEndPoint(bookingId));
      // Handle response
      if (response.isSuccess) {
        final bookingData = response.data['data']['attributes'];
        bookingDetails.value = BookingModel.fromJson(bookingData as Map<String, dynamic>);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to fetch booking details: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      bookingDetailsLoading.value = false;
    }
  }
}

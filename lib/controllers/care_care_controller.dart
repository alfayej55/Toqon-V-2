import 'package:car_care/all_export.dart';
import 'package:car_care/models/vahical_model.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:car_care/service/dio_api_client.dart';
import 'package:flutter/material.dart';

import '../models/care_graph_details_model.dart';

class CareGraphController extends GetxController {
  // Inject ApiClient
  final ApiClient _apiClient = Get.put(ApiClient());

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getVehicles();
    });
    super.onInit();
    // Initialize or fetch services
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
        final List<dynamic> vehiclesData =
            response.data['data']['attributes']['results'];
        final parsed =
            vehiclesData
                .map(
                  (vehicle) =>
                      VehiclesModel.fromJson(vehicle as Map<String, dynamic>),
                )
                .toList();
        vehiclesList.value = parsed.isEmpty ? _dummyVehicles() : parsed;
      } else {
        vehiclesList.value = _dummyVehicles();
        Get.snackbar('Info', 'Showing sample vehicles right now.');
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicles: $e');
      vehiclesList.value = _dummyVehicles();
      Get.snackbar('Info', 'Offline mode: showing sample vehicles.');
    } finally {
      vehiclesLoading.value = false;
    }
  }

  /// Register New Vehicle

  var primaryUserType = ''.obs;

  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController modelTextCtrl = TextEditingController();
  TextEditingController yearMenufasctureTextCtrl = TextEditingController();
  TextEditingController vinTextCtrl = TextEditingController();
  TextEditingController licenseTextCtrl = TextEditingController();
  TextEditingController manufactureTextCtrl = TextEditingController();
  TextEditingController registerTextCtrl = TextEditingController();

  /// Add Vehicle
  var addVehicleLoading = false.obs;

  Future<void> addVehicle({required String vehicleImage}) async {

    addVehicleLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "vehicleName": nameTextCtrl.text,
        "manufacturer": manufactureTextCtrl.text,
        "model": modelTextCtrl.text,
        "yearOfManufacture": yearMenufasctureTextCtrl.text,
        "registrationNumber": registerTextCtrl.text,
        "vin": vinTextCtrl.text,
        "primaryUsage": 'personal',
        "vehicleImages": [vehicleImage],
      };

      // API Call
      final response = await _apiClient.postData(
        ApiConstants.addVehiclesEndpoint,
        data: body,
      );

      // Handle response
      if (response.isSuccess) {
        // Add the new vehicle to the list locally
        final vehicleData = response.data['data']['attributes'];
        final newVehicle = VehiclesModel.fromJson(vehicleData);
        vehiclesList.add(newVehicle);
        vehiclesList.refresh();
        Get.back();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Failed to add vehicle: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      addVehicleLoading.value = false;
    }
  }

  /// Get Vehicle Details by ID

  var vehicleDetailsLoading = false.obs;

  Rx<CareGraphDetailsModel> vehicleDetails =
      CareGraphDetailsModel.fromJson({}).obs;

  Future<void> getVehicleDetails(String id) async {
    vehicleDetailsLoading.value = true;
    try {
      // API Call
      final response = await _apiClient.getData(
        '${ApiConstants.vehicleDetailsEndpoint}/$id',
      );

      // Handle response
      if (response.isSuccess) {
        final vehicleData = response.data['data']['attributes'];
        final parsed = CareGraphDetailsModel.fromJson(vehicleData);
        if (parsed.vehicle == null || parsed.results.isEmpty) {
          vehicleDetails.value = _dummyVehicleDetails(id);
        } else {
          vehicleDetails.value = parsed;
        }
        update();
      } else {
        vehicleDetails.value = _dummyVehicleDetails(id);
        Get.snackbar('Info', 'Showing sample service history.');
      }
    } catch (e) {
      debugPrint('Failed to fetch vehicle details: $e');
      vehicleDetails.value = _dummyVehicleDetails(id);
      Get.snackbar('Info', 'Offline mode: sample service history loaded.');
    } finally {
      vehicleDetailsLoading.value = false;
      update();
    }
  }

  List<VehiclesModel> _dummyVehicles() {
    final now = DateTime.now();
    return [
      VehiclesModel(
        id: 'dummy-honda',
        user: null,
        vehicleName: 'My Honda',
        manufacturer: 'Honda',
        model: 'Civic',
        yearOfManufacture: 2020,
        registrationNumber: 'ABC-1234',
        licensePlateImage: '',
        color: 'White',
        primaryUsage: 'personal',
        vehicleType: 'Sedan',
        fuelType: 'Gasoline',
        transmission: 'Automatic',
        engineSize: '2.0L',
        mileage: 45000,
        mileageUnit: 'km',
        insuranceProvider: '',
        insurancePolicyNumber: '',
        insuranceExpiryDate: '',
        lastServiceDate: '',
        nextServiceDue: '',
        nextServiceMileage: '',
        vehicleImages: const [],
        nuumberOfService: 5,
        notes: '',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      VehiclesModel(
        id: 'dummy-camry',
        user: null,
        vehicleName: 'Family Car',
        manufacturer: 'Toyota',
        model: 'Camry',
        yearOfManufacture: 2019,
        registrationNumber: 'XYZ-5678',
        licensePlateImage: '',
        color: 'Black',
        primaryUsage: 'personal',
        vehicleType: 'Sedan',
        fuelType: 'Gasoline',
        transmission: 'Automatic',
        engineSize: '2.5L',
        mileage: 44200,
        mileageUnit: 'km',
        insuranceProvider: '',
        insurancePolicyNumber: '',
        insuranceExpiryDate: '',
        lastServiceDate: '',
        nextServiceDue: '',
        nextServiceMileage: '',
        vehicleImages: const [],
        nuumberOfService: 8,
        notes: '',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  CareGraphDetailsModel _dummyVehicleDetails(String id) {
    final now = DateTime.now();
    final selected = _dummyVehicles().firstWhere(
      (v) => v.id == id,
      orElse: () => _dummyVehicles().first,
    );

    return CareGraphDetailsModel(
      vehicle: selected,
      results: [
        CareGraphResultModel(
          id: 'svc-1',
          vehicle: selected.id,
          user: '',
          source: 'manual',
          booking: null,
          serviceName: 'Oil Change',
          serviceDescription: 'Used synthetic oil, replaced filter',
          serviceCategory: 'Maintenance',
          garage: null,
          garageName: 'Quick Lube Express',
          garageAddress: '',
          mechanicName: '',
          serviceDate: DateTime(now.year, 1, 15, 10, 30),
          cost: 49.99,
          currency: 'CAD',
          mileage: 45000,
          mileageUnit: 'km',
          documents: const ['photo-1'],
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
        CareGraphResultModel(
          id: 'svc-2',
          vehicle: selected.id,
          user: '',
          source: 'manual',
          booking: null,
          serviceName: 'Brake Service',
          serviceDescription: 'Replaced front brake pads and rotors',
          serviceCategory: 'Repair',
          garage: null,
          garageName: 'Brake Masters',
          garageAddress: '',
          mechanicName: '',
          serviceDate: DateTime(now.year - 1, 12, 10, 14, 15),
          cost: 235.00,
          currency: 'CAD',
          mileage: 44200,
          mileageUnit: 'km',
          documents: const ['photo-1', 'photo-2'],
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      currentPage: 1,
      previousPage: null,
      nextPage: null,
      totalPages: 1,
      totalItems: 2,
      pdfDownloadUrl: '',
    );
  }
}

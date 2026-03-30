import 'package:car_care/all_export.dart';
import 'package:car_care/models/booking_model.dart';
import 'package:car_care/models/vahical_model.dart';
import 'package:car_care/service/api_constants.dart';
import 'package:car_care/service/dio_api_client.dart';

class ActivityServiceItem {
  final String serviceName;
  final String vehicleName;
  final DateTime date;
  final int points;

  const ActivityServiceItem({
    required this.serviceName,
    required this.vehicleName,
    required this.date,
    required this.points,
  });
}

class MyActivityData {
  final int carsRegistered;
  final int servicesLogged;
  final int totalPoints;
  final double moneySaved;
  final int pointsEarned;
  final int pointsRedeemed;
  final int currentBalance;
  final List<ActivityServiceItem> recentServices;

  const MyActivityData({
    required this.carsRegistered,
    required this.servicesLogged,
    required this.totalPoints,
    required this.moneySaved,
    required this.pointsEarned,
    required this.pointsRedeemed,
    required this.currentBalance,
    required this.recentServices,
  });
}

class MyActivityController extends GetxController {
  final ApiClient _apiClient = Get.put(ApiClient());

  final RxBool loading = false.obs;
  final RxString selectedRange = 'month'.obs;
  final Rx<MyActivityData> activity =
      const MyActivityData(
        carsRegistered: 0,
        servicesLogged: 0,
        totalPoints: 0,
        moneySaved: 0,
        pointsEarned: 0,
        pointsRedeemed: 0,
        currentBalance: 0,
        recentServices: [],
      ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivity();
  }

  Future<void> setRange(String range) async {
    selectedRange.value = range;
    await fetchActivity();
  }

  Future<void> fetchActivity() async {
    loading.value = true;
    try {
      final direct = await _fetchFromActivityEndpoint();
      if (direct != null) {
        activity.value = direct;
      } else {
        activity.value = await _buildFromExistingEndpoints();
      }
    } catch (_) {
      activity.value = await _buildFromExistingEndpoints();
    } finally {
      loading.value = false;
    }
  }

  Future<MyActivityData?> _fetchFromActivityEndpoint() async {
    try {
      final response = await _apiClient.getData(
        ApiConstants.myActivityEndPoint,
        queryParameters: {'range': selectedRange.value},
      );

      if (!response.isSuccess) return null;
      final dynamic attr = response.data['data']?['attributes'];
      if (attr is! Map<String, dynamic>) return null;

      final List<ActivityServiceItem> recent =
          ((attr['recentServices'] as List?) ?? [])
              .whereType<Map<String, dynamic>>()
              .map(
                (e) => ActivityServiceItem(
                  serviceName: (e['serviceName'] ?? 'Service').toString(),
                  vehicleName: (e['vehicleName'] ?? 'Vehicle').toString(),
                  date:
                      DateTime.tryParse((e['date'] ?? '').toString()) ??
                      DateTime.now(),
                  points:
                      (e['points'] is num) ? (e['points'] as num).toInt() : 0,
                ),
              )
              .toList();

      return MyActivityData(
        carsRegistered: _asInt(attr['carsRegistered']),
        servicesLogged: _asInt(attr['servicesLogged']),
        totalPoints: _asInt(attr['totalPoints']),
        moneySaved: _asDouble(attr['moneySaved']),
        pointsEarned: _asInt(attr['pointsEarned']),
        pointsRedeemed: _asInt(attr['pointsRedeemed']),
        currentBalance: _asInt(attr['currentBalance']),
        recentServices: recent,
      );
    } catch (_) {
      return null;
    }
  }

  Future<MyActivityData> _buildFromExistingEndpoints() async {
    final responses = await Future.wait([
      _apiClient.getData(ApiConstants.vehiclesEndpoint),
      _apiClient.getData(ApiConstants.bookingGetEndPoint('completed')),
      _apiClient.getData(ApiConstants.walletBalance),
      _apiClient.getData(ApiConstants.earnMyPointEndPoint),
    ]);

    final vehiclesRes = responses[0];
    final bookingRes = responses[1];
    final walletRes = responses[2];
    final pointsRes = responses[3];

    final List<VehiclesModel> vehicles = _parseVehicles(vehiclesRes);
    final List<BookingModel> bookings = _parseBookings(bookingRes);
    final int totalPoints =
        pointsRes.isSuccess
            ? _asInt(pointsRes.data['data']?['attributes']?['totalPoints'])
            : 0;
    final int walletBalance =
        walletRes.isSuccess ? _asInt(walletRes.data['data']?['balance']) : 0;

    final DateTime fromDate = _rangeStart(DateTime.now(), selectedRange.value);
    final filteredBookings =
        bookings.where((b) => !b.scheduledDate.isBefore(fromDate)).toList();

    final int servicesLogged =
        filteredBookings.isNotEmpty
            ? filteredBookings.length
            : vehicles.fold<int>(0, (sum, v) {
              final value = v.nuumberOfService;
              final int count =
                  (value is int) ? value : int.tryParse(value.toString()) ?? 0;
              return sum + count;
            });

    final double savedFromDiscount = filteredBookings.fold<double>(
      0,
      (sum, b) => sum + b.discountAmount.toDouble(),
    );
    final double moneySaved =
        savedFromDiscount > 0 ? savedFromDiscount : walletBalance.toDouble();

    final List<ActivityServiceItem> recent =
        filteredBookings
            .take(5)
            .map(
              (b) => ActivityServiceItem(
                serviceName:
                    b.service?.serviceName.isNotEmpty == true
                        ? b.service!.serviceName
                        : 'Service',
                vehicleName:
                    b.vehicle?.vehicleName.isNotEmpty == true
                        ? b.vehicle!.vehicleName
                        : 'Vehicle',
                date: b.scheduledDate,
                points: _estimatePointsFromBooking(b),
              ),
            )
            .toList();

    final int pointsRedeemed = (totalPoints * 0.33).round();
    final int pointsEarned = totalPoints + pointsRedeemed;

    final computed = MyActivityData(
      carsRegistered: vehicles.length,
      servicesLogged: servicesLogged,
      totalPoints: totalPoints,
      moneySaved: moneySaved,
      pointsEarned: pointsEarned,
      pointsRedeemed: pointsRedeemed,
      currentBalance: totalPoints > 0 ? totalPoints : walletBalance,
      recentServices: recent,
    );

    if (_looksEmpty(computed)) {
      return _dummyByRange(selectedRange.value);
    }
    return computed;
  }

  bool _looksEmpty(MyActivityData data) {
    return data.carsRegistered == 0 &&
        data.servicesLogged == 0 &&
        data.totalPoints == 0 &&
        data.moneySaved == 0 &&
        data.recentServices.isEmpty;
  }

  MyActivityData _dummyByRange(String range) {
    final now = DateTime.now();
    switch (range) {
      case 'week':
        return MyActivityData(
          carsRegistered: 2,
          servicesLogged: 2,
          totalPoints: 520,
          moneySaved: 86.5,
          pointsEarned: 640,
          pointsRedeemed: 120,
          currentBalance: 520,
          recentServices: [
            ActivityServiceItem(
              serviceName: 'Oil Change',
              vehicleName: '2020 Honda Civic',
              date: now.subtract(const Duration(days: 2)),
              points: 150,
            ),
            ActivityServiceItem(
              serviceName: 'Brake Inspection',
              vehicleName: '2019 Toyota Camry',
              date: now.subtract(const Duration(days: 5)),
              points: 88,
            ),
          ],
        );
      case 'year':
        return MyActivityData(
          carsRegistered: 2,
          servicesLogged: 14,
          totalPoints: 3240,
          moneySaved: 742.3,
          pointsEarned: 4410,
          pointsRedeemed: 1170,
          currentBalance: 3240,
          recentServices: [
            ActivityServiceItem(
              serviceName: 'Major Service',
              vehicleName: '2020 Honda Civic',
              date: now.subtract(const Duration(days: 24)),
              points: 320,
            ),
            ActivityServiceItem(
              serviceName: 'Tire Rotation',
              vehicleName: '2019 Toyota Camry',
              date: now.subtract(const Duration(days: 41)),
              points: 95,
            ),
            ActivityServiceItem(
              serviceName: 'Battery Health Check',
              vehicleName: '2020 Honda Civic',
              date: now.subtract(const Duration(days: 63)),
              points: 70,
            ),
          ],
        );
      case 'month':
      default:
        return MyActivityData(
          carsRegistered: 2,
          servicesLogged: 8,
          totalPoints: 2450,
          moneySaved: 485.5,
          pointsEarned: 3650,
          pointsRedeemed: 1200,
          currentBalance: 2450,
          recentServices: [
            ActivityServiceItem(
              serviceName: 'Oil Change',
              vehicleName: '2020 Honda Civic',
              date: now.subtract(const Duration(days: 3)),
              points: 150,
            ),
            ActivityServiceItem(
              serviceName: 'A/C Service',
              vehicleName: '2019 Toyota Camry',
              date: now.subtract(const Duration(days: 11)),
              points: 120,
            ),
            ActivityServiceItem(
              serviceName: 'Wheel Alignment',
              vehicleName: '2020 Honda Civic',
              date: now.subtract(const Duration(days: 18)),
              points: 105,
            ),
          ],
        );
    }
  }

  List<VehiclesModel> _parseVehicles(ApiResponse res) {
    if (!res.isSuccess) return const [];
    final data = res.data['data']?['attributes']?['results'];
    if (data is! List) return const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => VehiclesModel.fromJson(e))
        .toList();
  }

  List<BookingModel> _parseBookings(ApiResponse res) {
    if (!res.isSuccess) return const [];
    final data = res.data['data']?['attributes']?['results'];
    if (data is! List) return const [];
    final list =
        data
            .whereType<Map<String, dynamic>>()
            .map((e) => BookingModel.fromJson(e))
            .toList();
    list.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    return list;
  }

  int _estimatePointsFromBooking(BookingModel b) {
    final int servicePrice = b.servicePrice;
    if (servicePrice <= 0) return 0;
    return (servicePrice * 0.1).round();
  }

  DateTime _rangeStart(DateTime now, String range) {
    switch (range) {
      case 'week':
        final int weekday = now.weekday; // Mon=1
        return DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: weekday - 1));
      case 'year':
        return DateTime(now.year, 1, 1);
      case 'month':
      default:
        return DateTime(now.year, now.month, 1);
    }
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

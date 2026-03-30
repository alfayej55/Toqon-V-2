import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/service_controller.dart';
import '../../../Widget/my_booking_card.dart';

import '../../../base/custom_empty_state.dart';
import '../../../base/custom_page_loading.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({super.key});

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _serviceCtrl.getBooking('inprogress');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_serviceCtrl.myBookingLoading.value) {
        return Center(child: CustomPageLoading());
      }
      if (_serviceCtrl.bookingList.isEmpty) {
        return CustomEmptyState(
          icon: AppIcons.bookingIcon,
          title: 'No Active Bookings',
          subtitle: 'Your in-progress services will appear here',
        );
      }
      return ListView.builder(
        itemCount: _serviceCtrl.bookingList.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          var bookingInfo = _serviceCtrl.bookingList[index];
          return MyBookingCard(bookingModel: bookingInfo);
        },
      );
    });
  }
}

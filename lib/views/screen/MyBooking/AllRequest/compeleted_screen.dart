import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/service_controller.dart';
import '../../../Widget/my_booking_card.dart';

import '../../../base/custom_empty_state.dart';
import '../../../base/custom_page_loading.dart';

class CompeletedScreen extends StatefulWidget {
  const CompeletedScreen({super.key});

  @override
  State<CompeletedScreen> createState() => _CompeletedScreenState();
}

class _CompeletedScreenState extends State<CompeletedScreen> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _serviceCtrl.getBooking('completed');
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
          title: 'No Completed Bookings',
          subtitle: 'Your completed services will appear here',
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

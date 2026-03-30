import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/service_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import '../../../Widget/my_booking_card.dart';
import '../../../base/custom_empty_state.dart';


class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _serviceCtrl.getBooking('pending');
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
          title: 'No Pending Requests',
          subtitle: 'New service requests will appear here',
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

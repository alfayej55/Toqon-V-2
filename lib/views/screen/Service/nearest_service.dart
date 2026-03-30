import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';
import '../../../controllers/service_controller.dart';
import '../../Widget/garages_card.dart';
import '../../base/custom_empty_state.dart';

class NearestService extends StatefulWidget {
  final String categoryId;
  const NearestService({super.key, required this.categoryId});

  @override
  State<NearestService> createState() => _NearestServiceState();
}

class _NearestServiceState extends State<NearestService> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _serviceCtrl.getService(widget.categoryId, 'nearest');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_serviceCtrl.serviceList.isEmpty) {
        return CustomEmptyState(
          icon: AppIcons.serviceIcon,
          title: 'No Nearby Services',
          subtitle: 'Nearby services will appear here',
        );
      }
      return ListView.builder(
        itemCount: _serviceCtrl.serviceList.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          var serviceInfo = _serviceCtrl.serviceList[index];
          return ServiceCardWidget(serviceModel: serviceInfo);
        },
      );
    });
  }
}

import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';
import '../../../controllers/service_controller.dart';
import '../../Widget/garages_card.dart';
import '../../base/custom_empty_state.dart';

class BestPriceService extends StatefulWidget {
  final String categoryId;
  const BestPriceService({super.key, required this.categoryId});

  @override
  State<BestPriceService> createState() => _BestPriceServiceState();
}

class _BestPriceServiceState extends State<BestPriceService> {
  final ServiceController _serviceCtrl = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _serviceCtrl.getService(widget.categoryId, 'bestPrice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_serviceCtrl.serviceList.isEmpty) {
        return CustomEmptyState(
          icon: AppIcons.serviceIcon,
          title: 'No Best Price Services',
          subtitle: 'Affordable services will appear here',
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

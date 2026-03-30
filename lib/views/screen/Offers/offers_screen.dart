import 'package:car_care/controllers/offer_controller.dart';
import 'package:car_care/views/base/custom_empty_state.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import '../../Widget/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final searchCTrl = TextEditingController();
  final OfferController _offerCtrl = Get.put(OfferController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _offerCtrl.getActiveOffer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Special Offer',
        centerTitle: true,
      ),
      body: SafeArea(top: false, 
        minimum: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Obx(() {
          return Column(
            children: [
              CustomTextField(
                controller: searchCTrl,
                hintText: 'Search',
                contenpaddingVertical: 12,
              ),
              SizedBox(height: 10),
              if (_offerCtrl.offerLoading.value)
                Expanded(child: Center(child: CustomPageLoading()))
              else if (_offerCtrl.offerModelList.isEmpty)
                Expanded(
                  child: CustomEmptyState(
                    icon: AppIcons.offerIcon,
                    title: 'No Offers Available',
                    subtitle: 'Special offers will appear here',
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _offerCtrl.offerModelList.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      var offerInfo = _offerCtrl.offerModelList[index];
                      return OfferCard(offerModel: offerInfo);
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

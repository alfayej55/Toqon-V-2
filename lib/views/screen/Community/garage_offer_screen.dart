import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';

import '../../../controllers/community_controller.dart';
import '../../../utils/custom_appbar.dart';
import '../../Widget/garege_offer_card.dart';
import 'package:get/get.dart';
class GarageOfferScreen extends StatefulWidget {

  const GarageOfferScreen({super.key});

  @override
  State<GarageOfferScreen> createState() => _GarageOfferScreenState();
}

class _GarageOfferScreenState extends State<GarageOfferScreen> {
  final CommunityController _communityCtrl=Get.put(CommunityController());

  var garageOfferId=Get.arguments;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{

      await  _communityCtrl.garageOfferGet(garageOfferId);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title:'Garage Offer',
      ),
      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
        children: [
          Expanded(
            child: Obx(()=>_communityCtrl.garageOfferLoading.value?Center(child: CustomPageLoading(),): ListView.builder(
                itemCount:_communityCtrl.garageOfferList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context,index){
                  var communityInfo=_communityCtrl.garageOfferList[index];
                  return GaregeOfferCard(garageOfferModel: communityInfo);

                }))

          )
        ],
      )),
    );

  }
}

import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';

import '../../../controllers/profile_controller.dart';
import '../../base/custom_page_loading.dart';
class PrivacyScreen extends StatelessWidget {
   PrivacyScreen({super.key});


  final ProfileController _profileCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Text('Privacy Policy', style: AppStyles.h5(color: Get.theme.textTheme.bodyLarge!.color)),
        leading: IconButton(onPressed: (){
          NavigationHelper.backOrHome();
        }, icon: Icon(Icons.arrow_back_ios,color: Get.theme.textTheme.bodyLarge!.color,)),
      ),
      body: SafeArea(top: false, 
          minimum: EdgeInsets.symmetric(horizontal: 20),
          child: Obx(()=>_profileCtrl.profileLoading.value?Center(child: CustomPageLoading(),): Column(
            children: [

              Text(_profileCtrl.privacyModel.value.content,style: AppStyles.h5(),textAlign: TextAlign.start,)

            ],
          ))

      ),
    );
  }
}

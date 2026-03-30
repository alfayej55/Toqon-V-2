
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/profile_controller.dart';

class AccountInfoScreen extends StatelessWidget {
   AccountInfoScreen({super.key});

  final ProfileController _profileCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title:'Account Information',
      ),

      body: Obx(()=>_profileCtrl.isLoading.value?Center(child: CustomPageLoading(),):SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Profile Image

            Align(
              alignment: Alignment.center,
              child: CustomNetworkImage(
                  imageUrl:_profileCtrl.profileModel.value.image,
                  boxShape: BoxShape.circle,
                  width:100,
                  height:100
                // height: double.infinity,
              ),
            ),


            SizedBox(height: Dimensions.paddingSize,),
            /// Name Field

            Text(
              AppString.fullNameText,
              style: AppStyles.h5(
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            customContainer(context,_profileCtrl.profileModel.value.fullName),

            /// Phone Name
            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
              AppString.phoneNumberText,
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            customContainer(context,_profileCtrl.profileModel.value.phoneNumber),

            /// Address
            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
              'Address',
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            customContainer(context, _profileCtrl.profileModel.value.address,),
            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
              'Preferred garage type',
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            customContainer(context,'Personal'),


          ],
        ),
      )),
    );
  }

  customContainer(BuildContext context,String name){
    return Container(
      width:context.screenWidth ,
      padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color:Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          AppStyles.boxShadow
        ],
      ),
      child:Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.h6())
    );
  }
}

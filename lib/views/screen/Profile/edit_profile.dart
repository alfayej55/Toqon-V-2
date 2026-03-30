import 'dart:io';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/controllers/upload_image_controller.dart';
import 'package:car_care/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../base/image_picar_bottomsheet.dart';

class EditProfile extends StatelessWidget {
   EditProfile({super.key}) {
     // Initialize edit profile with existing data
     _profileCtrl.initEditProfile();
     // Reset upload controller
     _uploadImageCtrl.imagePath.value = '';
     _uploadImageCtrl.fileUrl.value = '';
   }

  final ProfileController _profileCtrl = Get.find<ProfileController>();
  final UploadImageController _uploadImageCtrl = Get.put(UploadImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title:'Edit Profile',
      ),

      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Profile Image
           Obx(()=> Align(
             alignment: Alignment.center,
             child: Stack(
               alignment: Alignment.bottomRight,
               children: [
                 // Show local image if picked, otherwise show network image
                 _uploadImageCtrl.imagePath.value.isNotEmpty
                     ? Stack(
                         children: [
                           Container(
                             height: 90,
                             width: 90,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               image: DecorationImage(
                                 image: FileImage(File(_uploadImageCtrl.imagePath.value)),
                                 fit: BoxFit.cover,
                               ),
                               border: Border.all(
                                 color: AppColors.subTextColor.withValues(alpha: 0.1),
                               ),
                             ),
                           ),
                           if (_uploadImageCtrl.isUploading.value)
                             Container(
                               height: 90,
                               width: 90,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.black.withValues(alpha: 0.5),
                               ),
                               child: Center(
                                 child: CircularProgressIndicator(
                                   value: _uploadImageCtrl.uploadProgress.value,
                                   strokeWidth: 3,
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                         ],
                       )
                     : _profileCtrl.profileModel.value.image.isNotEmpty
                         ? CustomNetworkImage(
                             imageUrl: _profileCtrl.profileModel.value.image,
                             height: 90,
                             width: 90,
                             boxShape: BoxShape.circle,
                             boxFit: BoxFit.cover,
                             border: Border.all(
                               color: AppColors.subTextColor.withValues(alpha: 0.1),
                             ),
                           )
                         : Container(
                             height: 90,
                             width: 90,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: AppColors.primaryColor,
                               border: Border.all(
                                 color: AppColors.subTextColor.withValues(alpha: 0.1),
                               ),
                             ),
                             child: Icon(Icons.person, size: 50, color: Colors.white),
                           ),

                 InkWell(
                   onTap: () {
                     showModalBottomSheet(
                       context: context,
                       builder: (builder) {
                         return ImagePicarBottomsheet(
                           onGalleryTap: () {
                             _uploadImageCtrl.pickImage(ImageSource.gallery);

                           },
                           onCameraTap: () {
                             _uploadImageCtrl.pickImage(ImageSource.camera);

                           },
                         );
                       },
                     );
                   },
                   child: Padding(
                     padding: EdgeInsets.only(bottom: 7),
                     child: SvgPicture.asset(AppIcons.profileEditIcon),
                   ),
                 )
               ],
             ),
           ),),

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
            CustomTextField(
              controller: _profileCtrl.nameTextCtrl,
              hintText: 'Full Name',
              contenpaddingVertical: 10,
            ),

            /// Phone Number

            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
              AppString.phoneNumberText,
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            CustomTextField(
              controller: _profileCtrl.phoneTextCtrl,
              hintText: 'Phone Number',
              contenpaddingVertical: 10,
            ),
            /// Address
            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
            'Address',
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            CustomTextField(
              controller: _profileCtrl.addressTextCtrl,
              hintText: 'Address',
              contenpaddingVertical: 10,
            ),

            /// Preferred garage type
            SizedBox(height: Dimensions.defultScreenSizeBoxSize,),
            Text(
              'Preferred garage type',
              style: AppStyles.h5(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.heightSize,),
            CustomTextField(
              controller: _profileCtrl.referredGarageTextCtrl,
              hintText: 'Type',
              contenpaddingVertical: 10,
            ),
            SizedBox(height: Dimensions.marginSizeHorizontal,),
            Obx(() => CustomButton(
              onTap: () => _profileCtrl.updateProfile(_uploadImageCtrl.fileUrl.value),
              text: 'Save',
              loading: _profileCtrl.isLoading.value,
            ))

          ],
        ),
      ),
    );
  }
}

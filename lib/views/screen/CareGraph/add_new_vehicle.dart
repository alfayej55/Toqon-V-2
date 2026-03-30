import 'dart:io';

import 'package:car_care/controllers/upload_image_controller.dart';
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/care_care_controller.dart';
import '../../base/image_picar_bottomsheet.dart';

class AddNewVehicle extends StatelessWidget {
  AddNewVehicle({super.key});

  final CareGraphController _carGraphCtrl = Get.put(CareGraphController());
  final UploadImageController uploadImageCtrl = Get.put(
    UploadImageController(),
  );

  final List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  final String? selectedValue = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Add New Vehicle', centerTitle: true),
      body: Obx(
        () => SafeArea(
          minimum: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: ListView(
            children: [
              /// Vehicle Name
              Text(
                AppString.vehicleInformationText,
                style: AppStyles.h4(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.paddingSizeHorizontalSize),
              Text(
                AppString.vehicleNameText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _carGraphCtrl.nameTextCtrl,
                hintText: 'e.g., My Honda, Family Car',
                contenpaddingVertical: 10,
              ),

              /// Manufacture
              SizedBox(height: 10),
              Text(
                AppString.manufactureText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              // CustomDropdown<String>(
              //   items: ['Apple', 'Samsung', 'Google', 'OnePlus'],
              //   hint: 'selected manufacture',
              //   onChanged: (value) {
              //     // Selected: $value
              //   },
              // ),
              CustomTextField(
                controller: _carGraphCtrl.manufactureTextCtrl,
                hintText: 'e.g., Toyota, Honda, BMW',
                contenpaddingVertical: 10,
              ),

              /// Model
              SizedBox(height: 10),
              Text(
                AppString.modelText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _carGraphCtrl.modelTextCtrl,
                hintText: 'e.g., Camry, Civic, X5',
                contenpaddingVertical: 10,
              ),

              /// Year of Manufacture
              SizedBox(height: 10),
              Text(
                AppString.yearofManufasctureText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _carGraphCtrl.yearMenufasctureTextCtrl,
                hintText: 'e.g., 2020',
                contenpaddingVertical: 10,
              ),

              /// VIN (Optional)
              SizedBox(height: 10),
              Text(
                AppString.vinOptionaText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _carGraphCtrl.vinTextCtrl,
                hintText: 'e.g., 1HGBH41JXMN109186',
                contenpaddingVertical: 10,
              ),

              /// License Plate
              SizedBox(height: 10),
              Text(
                'License Plate (Optional)',
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),

              CustomTextField(
                controller: _carGraphCtrl.licenseTextCtrl,
                hintText: 'e.g., ABC-1234',
                contenpaddingVertical: 10,
              ),

              /// Registration Number
              SizedBox(height: 10),
              Text(
                'Registration Number',
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomTextField(
                controller: _carGraphCtrl.registerTextCtrl,
                hintText: 'e.g., REG-123456',
                contenpaddingVertical: 10,
              ),

              /// Primary Usage Type
              SizedBox(height: 10),
              Text(
                AppString.primaryUsageTypeText,
                style: AppStyles.h5(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.heightSize),
              CustomDropdown<String>(
                items: [
                  "PERSONAL",
                  "COMMERCIAL",
                  "RENTAL",
                  "TAXI",
                  "DELIVERY",
                  "OTHER",
                ],
                hint: 'Select usage type',
                onChanged: (value) {
                  _carGraphCtrl.primaryUserType.value = value!.toLowerCase();
                  debugPrint('>>>>>>>>.${_carGraphCtrl.primaryUserType.value}');

                  // Selected: $value
                },
              ),

              /// Image Upload
              SizedBox(height: 10),

              /// Select Image Section
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return ImagePicarBottomsheet(
                        onGalleryTap: () {
                          uploadImageCtrl.pickImage(ImageSource.gallery);
                        },
                        onCameraTap: () {
                          uploadImageCtrl.pickImage(ImageSource.camera);
                        },
                      );
                    },
                  );
                },
                child: CustomComponetCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Image', style: AppStyles.h3()),
                      SizedBox(height: 15),
                      uploadImageCtrl.imagePath.isNotEmpty
                          ? Stack(
                            children: [
                              Container(
                                width: context.screenWidth,
                                height: context.screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(
                                      File(uploadImageCtrl.imagePath.value),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: AppColors.subTextColor.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ),
                              if (uploadImageCtrl.isUploading.value)
                                Container(
                                  width: context.screenWidth,
                                  height: context.screenHeight * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          value:
                                              uploadImageCtrl
                                                  .uploadProgress
                                                  .value,
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '${(uploadImageCtrl.uploadProgress.value * 100).toInt()}%',
                                          style: AppStyles.h4(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                          : DottnetUploadContainer(),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              CustomButton(
                loading: _carGraphCtrl.addVehicleLoading.value,
                onTap: () {
                  _carGraphCtrl
                      .addVehicle(vehicleImage: uploadImageCtrl.fileUrl.value)
                      .then((v) {
                        uploadImageCtrl.imagePath.value = '';
                        uploadImageCtrl.fileUrl.value = '';
                        uploadImageCtrl.uploadProgress.value = 0.0;
                      });
                },
                text: AppString.addVehicleText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

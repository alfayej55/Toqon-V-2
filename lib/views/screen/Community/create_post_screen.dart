import 'dart:io';

import 'package:car_care/controllers/community_controller.dart';
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/upload_image_controller.dart';
import '../../base/custom_gradiand_button.dart';
import '../../base/image_picar_bottomsheet.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final CommunityController _communityCtrl = Get.put(CommunityController());
  final UploadImageController uploadImageCtrl = Get.put(UploadImageController());

  final Map<String, String> _postTypeValueMap = const {
    'HELP POST': 'helpost',
    'JOB REQUEST': 'helpost',
    'EMERGENCY HELP': 'helpost',
    'GENERAL POST': 'onlypost',
    'PHOTO POST': 'onlypost',
    'REEL POST': 'onlypost',
    'GARAGE OFFER': 'onlypost',
    'MECHANIC TIPS': 'onlypost',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: GradientAppBar(title: 'Create Post', centerTitle: true),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                Get.isDarkMode
                    ? const [Color(0xFF0B111D), Color(0xFF0A0F19)]
                    : const [Color(0xFFF6F8FC), Color(0xFFEFF3FA)],
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Obx(
            () => ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom + 20,
              ),
              children: [
                _heroCard(),
                const SizedBox(height: 12),
                _mediaCard(context),
                const SizedBox(height: 12),
                _postTypeCard(),
                const SizedBox(height: 12),
                if (_communityCtrl.selectedPostType.value == 'helpost')
                  _helpFieldsCard(),
                if (_communityCtrl.selectedPostType.value == 'helpost')
                  const SizedBox(height: 12),
                _contentCard(),
                const SizedBox(height: 14),
                CustomGradientButton(
                  loading: _communityCtrl.offerAddLoading.value,
                  onTap: _onSharePost,
                  text: 'Publish Post',
                  showGlow: false,
                  height: 48,
                  borderRadius: BorderRadius.circular(14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(colors: AppColors.brandGradient),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TORQON COMMUNITY',
            style: AppStyles.h6(
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: 'InterSemiBold',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Share a build, ask for help, or post a job in seconds.',
            style: AppStyles.h5(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _mediaCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
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
            Row(
              children: [
                Icon(Icons.add_a_photo_outlined, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text('Media', style: AppStyles.h4(fontFamily: 'InterSemiBold')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Tap to add photo for your post',
              style: AppStyles.h6(color: AppColors.subTextColor),
            ),
            const SizedBox(height: 10),
            uploadImageCtrl.imagePath.isNotEmpty
                ? Stack(
                  children: [
                    Container(
                      width: context.screenWidth,
                      height: context.screenHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(uploadImageCtrl.imagePath.value)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: AppColors.subTextColor.withValues(alpha: 0.16),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          uploadImageCtrl.imagePath.value = '';
                          uploadImageCtrl.fileUrl.value = '';
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
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
                          color: Colors.black.withValues(alpha: 0.55),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                value: uploadImageCtrl.uploadProgress.value,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.3,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${(uploadImageCtrl.uploadProgress.value * 100).toInt()}%',
                                style: AppStyles.h4(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
                : const DottnetUploadContainer(),
          ],
        ),
      ),
    );
  }

  Widget _postTypeCard() {
    return CustomComponetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Post Type', style: AppStyles.h4(fontFamily: 'InterSemiBold')),
          const SizedBox(height: 4),
          Text(
            'Choose how your post appears in community feed.',
            style: AppStyles.h6(color: AppColors.subTextColor),
          ),
          const SizedBox(height: 10),
          CustomDropdown<String>(
            items: _postTypeValueMap.keys.toList(),
            hint: 'SELECT POST TYPE',
            onChanged: (value) {
              if (value != null) {
                _communityCtrl.selectedPostType.value =
                    _postTypeValueMap[value] ?? 'onlypost';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _helpFieldsCard() {
    return CustomComponetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Help Request Details', style: AppStyles.h4(fontFamily: 'InterSemiBold')),
          const SizedBox(height: 10),
          _fieldLabel('Issue Type'),
          const SizedBox(height: 5),
          CustomTextField(
            contenpaddingVertical: 12,
            controller: _communityCtrl.issueTextCtrl,
            hintText: 'Describe the issue',
            maxLines: null,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          _fieldLabel('Budget'),
          const SizedBox(height: 5),
          CustomTextField(
            contenpaddingVertical: 12,
            controller: _communityCtrl.budgetTextCtrl,
            hintText: 'Estimated budget',
            maxLines: null,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          _fieldLabel('Car Type'),
          const SizedBox(height: 5),
          CustomTextField(
            contenpaddingVertical: 12,
            controller: _communityCtrl.carTypeTextCtrl,
            hintText: 'e.g. BMW M3 2019',
            maxLines: null,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          _fieldLabel('Urgency'),
          const SizedBox(height: 5),
          CustomDropdown<String>(
            items: const ['LOW', 'MEDIUM', 'HIGH'],
            hint: 'SELECT URGENCY',
            onChanged: (value) {
              if (value != null) {
                _communityCtrl.selectedUrgencyType.value = value.toLowerCase();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _contentCard() {
    return CustomComponetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Post Title'),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _communityCtrl.titleTextCtrl,
            hintText: 'Add a strong title',
            maxLines: 1,
            minLines: 1,
            contenpaddingVertical: 12,
          ),
          const SizedBox(height: 10),
          _fieldLabel('Post Description'),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _communityCtrl.descriptionTextCtrl,
            hintText: 'Share your update with the community',
            maxLines: null,
            minLines: 3,
            contenpaddingVertical: 12,
          ),
          const SizedBox(height: 10),
          _fieldLabel('Tagged Location'),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _communityCtrl.locationTextCtrl,
            hintText: 'Tag location (City, Area, Garage)',
            maxLines: 1,
            minLines: 1,
            contenpaddingVertical: 12,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 10),
          _fieldLabel('Hashtags'),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _communityCtrl.hasTagTextCtrl,
            hintText: '#BMW #Turbo #Torqon',
            maxLines: null,
            minLines: 1,
            contenpaddingVertical: 12,
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppStyles.h5(fontFamily: 'InterSemiBold'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _onSharePost() {
    if (uploadImageCtrl.isUploading.value) {
      Get.snackbar(
        'Upload in Progress',
        'Please wait for media upload to complete.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    _communityCtrl.createCommunity(uploadImageCtrl.fileUrl.value);
  }
}

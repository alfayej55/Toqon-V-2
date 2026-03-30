import 'dart:io';

import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/controllers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/image_picar_bottomsheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileCtrl =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
  final UploadImageController _uploadImageCtrl =
      Get.isRegistered<UploadImageController>()
          ? Get.find<UploadImageController>()
          : Get.put(UploadImageController());

  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final baseProfile = _profileCtrl.effectiveProfile;
      final Map<String, dynamic> args =
          (Get.arguments is Map<String, dynamic>)
              ? Get.arguments as Map<String, dynamic>
              : <String, dynamic>{};

      final String argId = (args['id'] as String?)?.trim() ?? '';
      final bool isSelfProfile = argId.isEmpty || argId == baseProfile.id;

      final String name =
          (args['name'] as String?)?.trim().isNotEmpty == true
              ? args['name'] as String
              : baseProfile.fullName;
      final String email =
          (args['email'] as String?)?.trim().isNotEmpty == true
              ? args['email'] as String
              : baseProfile.email;
      final String address =
          (args['address'] as String?)?.trim().isNotEmpty == true
              ? args['address'] as String
              : baseProfile.address;
      final String birthday =
          (args['birthday'] as String?)?.trim().isNotEmpty == true
              ? args['birthday'] as String
              : _formatDate(baseProfile.dateOfBirth);

      final String effectiveImage =
          isSelfProfile
              ? baseProfile.image
              : ((args['image'] as String?) ?? '');

      return Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: NavigationHelper.backOrHome,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                Get.isDarkMode
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.white.withValues(alpha: 0.92),
                            border: Border.all(
                              color: AppColors.borderColor.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Get.theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Profile',
                        style: AppStyles.h3(fontFamily: 'InterSemiBold'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: _profileHeader(
                    name: name,
                    email: email,
                    address: address,
                    birthday: birthday,
                    image: effectiveImage,
                    isSelfProfile: isSelfProfile,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _profileActionButton(
                          title: isSelfProfile ? 'Edit Profile' : 'Message',
                          filled: true,
                          onTap: () {
                            if (isSelfProfile) {
                              Get.toNamed(AppRoutes.profileEditScreen);
                            } else {
                              Get.toNamed(AppRoutes.chatScreen);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _profileActionButton(
                          title: 'Share Profile',
                          filled: false,
                          onTap:
                              () => _shareProfile(
                                name: name,
                                email: email,
                                address: address,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    children: [
                      _tabPill('POSTS', index: 0),
                      const SizedBox(width: 8),
                      _tabPill('REELS', index: 1),
                      const SizedBox(width: 8),
                      _tabPill('TAGGED', index: 2),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: AppColors.brandGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            _tabIndex == 0
                                ? Icons.grid_view_rounded
                                : _tabIndex == 1
                                ? Icons.movie_creation_outlined
                                : Icons.sell_outlined,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'No ${_tabLabel()} Yet',
                          style: AppStyles.h2(fontFamily: 'InterSemiBold'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'This profile has no ${_tabLabel().toLowerCase()} yet.',
                          textAlign: TextAlign.center,
                          style: AppStyles.h5(
                            color:
                                Get.isDarkMode
                                    ? const Color(0xFFB7C3DB)
                                    : AppColors.subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _tabLabel() {
    if (_tabIndex == 1) return 'Reels';
    if (_tabIndex == 2) return 'Tagged';
    return 'Posts';
  }

  Future<void> _shareProfile({
    required String name,
    required String email,
    required String address,
  }) async {
    final String shareText = 'Profile: $name\nEmail: $email\nAddress: $address';
    await Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      'Copied',
      'Profile details copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ImagePicarBottomsheet(
          onGalleryTap: () => _handleProfileImagePick(ImageSource.gallery),
          onCameraTap: () => _handleProfileImagePick(ImageSource.camera),
        );
      },
    );
  }

  Future<void> _handleProfileImagePick(ImageSource source) async {
    _uploadImageCtrl.fileUrl.value = '';
    _uploadImageCtrl.uploadComplete.value = false;
    await _uploadImageCtrl.pickImage(source);

    var waitedMs = 0;
    while (!_uploadImageCtrl.uploadComplete.value &&
        _uploadImageCtrl.fileUrl.value.isEmpty &&
        waitedMs < 10000) {
      await Future.delayed(const Duration(milliseconds: 150));
      waitedMs += 150;
    }

    if (_uploadImageCtrl.fileUrl.value.isNotEmpty) {
      await _profileCtrl.updateProfileImageOnly(_uploadImageCtrl.fileUrl.value);
      await _profileCtrl.profileInfoGet();
    } else {
      Get.snackbar(
        'Upload failed',
        'Could not upload image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  Widget _profileHeader({
    required String name,
    required String email,
    required String address,
    required String birthday,
    required String image,
    required bool isSelfProfile,
  }) {
    final Color secondaryText =
        Get.isDarkMode ? const Color(0xFFC3CEE4) : AppColors.subTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar(image: image, name: name, isSelfProfile: isSelfProfile),
            const SizedBox(width: 16),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatBox(title: 'POSTS', value: '0'),
                  _StatBox(title: 'FOLLOWERS', value: '248'),
                  _StatBox(title: 'FOLLOWING', value: '191'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(name, style: AppStyles.h2(fontFamily: 'InterSemiBold')),
        const SizedBox(height: 4),
        Text(
          email,
          style: AppStyles.h5(color: secondaryText, fontFamily: 'InterMedium'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: AppStyles.h5(color: secondaryText, fontFamily: 'InterMedium'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          'Birthday: $birthday',
          style: AppStyles.h6(color: secondaryText, fontFamily: 'InterMedium'),
        ),
      ],
    );
  }

  Widget _avatar({
    required String image,
    required String name,
    required bool isSelfProfile,
  }) {
    final String initials =
        name
            .split(' ')
            .where((e) => e.trim().isNotEmpty)
            .take(2)
            .map((e) => e[0].toUpperCase())
            .join();

    return InkWell(
      onTap: isSelfProfile ? _pickProfileImage : null,
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Obx(() {
            final bool hasLocalPreview =
                _uploadImageCtrl.imagePath.value.isNotEmpty;
            if (hasLocalPreview && isSelfProfile) {
              return Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.brandPrimary.withValues(alpha: 0.35),
                  ),
                  image: DecorationImage(
                    image: FileImage(File(_uploadImageCtrl.imagePath.value)),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }

            if (image.trim().isNotEmpty) {
              return CustomNetworkImage(
                imageUrl: image,
                boxShape: BoxShape.circle,
                width: 84,
                height: 84,
              );
            }

            return Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: AppColors.brandGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials.isEmpty ? 'MS' : initials,
                style: AppStyles.h2(
                  color: Colors.white,
                  fontFamily: 'InterBold',
                ),
              ),
            );
          }),
          if (isSelfProfile)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: AppColors.brandGradient,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppIcons.profileEditIcon,
                    height: 12,
                    width: 12,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          if (isSelfProfile && _uploadImageCtrl.isUploading.value)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      value:
                          _uploadImageCtrl.uploadProgress.value > 0
                              ? _uploadImageCtrl.uploadProgress.value
                              : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _profileActionButton({
    required String title,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient:
              filled
                  ? const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: filled ? null : Colors.transparent,
          border: Border.all(
            color:
                filled
                    ? Colors.transparent
                    : AppColors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          title,
          style: AppStyles.h6(
            color: filled ? Colors.white : Get.theme.textTheme.bodyLarge?.color,
            fontFamily: 'InterSemiBold',
          ),
        ),
      ),
    );
  }

  Widget _tabPill(String title, {required int index}) {
    final bool active = _tabIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        setState(() => _tabIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient:
              active
                  ? const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color:
              active
                  ? null
                  : (Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.85)),
          border: Border.all(
            color:
                active
                    ? Colors.transparent
                    : AppColors.borderColor.withValues(alpha: 0.45),
          ),
        ),
        child: Text(
          title,
          style: AppStyles.customSize(
            size: 11,
            color: active ? Colors.white : Get.theme.textTheme.bodyLarge?.color,
            fontFamily: 'InterSemiBold',
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppStyles.h3(fontFamily: 'InterBold')),
        const SizedBox(height: 2),
        Text(
          title,
          style: AppStyles.customSize(
            size: 10,
            fontFamily: 'InterSemiBold',
            color:
                Get.isDarkMode
                    ? const Color(0xFFB7C3DB)
                    : AppColors.subTextColor,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

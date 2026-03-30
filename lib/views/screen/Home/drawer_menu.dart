import 'dart:io';

import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/notification_controller.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/controllers/upload_image_controller.dart';
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/theme_controller.dart';
import '../../base/image_picar_bottomsheet.dart';
import '../../base/worning_alert.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  final profileController = Get.find<ProfileController>();
  final notificationController = Get.put(NotificationController());
  final uploadImageCtrl = Get.put(UploadImageController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.isDarkMode;

    return Drawer(
      width: context.screenWidth * 0.88,
      child: Container(
        color:
            Get.isDarkMode ? const Color(0xFF121721) : const Color(0xFFF4F6FA),
        child: Column(
          children: [
            _buildHeader(context, isDarkMode),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  children: [
                    _sectionCard(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Account Info',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.accountInfoScreen,
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.shield_outlined,
                          title: 'Security & Login',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.securityScreen,
                              ),
                        ),
                        Obx(
                          () => _buildMenuItem(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            badgeCount: notificationController.unreadCount,
                            onTap:
                                () => _navigateFromDrawer(
                                  context,
                                  AppRoutes.notificationScreen,
                                ),
                          ),
                        ),
                        _buildMenuItem(
                          icon: Icons.workspace_premium_outlined,
                          title: 'My Badges',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.badgeScreen,
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.monitor_heart_outlined,
                          title: 'My Activity',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.myActivityScreen,
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.mark_chat_unread_outlined,
                          title: 'CareChat AI',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.aiDetection,
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Get Help',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.callSuportScreen,
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.info_outline_rounded,
                          title: 'About App',
                          onTap:
                              () => _navigateFromDrawer(
                                context,
                                AppRoutes.aboutScreen,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildBuildInfoCard(),
                    const SizedBox(height: 10),
                    _buildSignOutTile(),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: context.screenHeight * 0.052,
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.brandGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: AppStyles.h1(
                  color: Colors.white,
                  fontFamily: 'InterBold',
                ),
              ),
              Row(
                children: [
                  _topIconButton(
                    icon:
                        isDarkMode
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_round,
                    onTap: () => Get.find<ThemeController>().toggleTheme(),
                  ),
                  const SizedBox(width: 8),
                  _topIconButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    danger: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Obx(() {
                    final p = profileController.effectiveProfile;
                    final String image = p.image.trim();
                    final String name =
                        p.fullName.trim().isEmpty ? 'Mr. Sham' : p.fullName;
                    final String initials =
                        name
                            .split(' ')
                            .where((e) => e.trim().isNotEmpty)
                            .take(2)
                            .map((e) => e[0].toUpperCase())
                            .join();

                    return Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.24),
                      ),
                      child: ClipOval(
                        child:
                            uploadImageCtrl.imagePath.value.trim().isNotEmpty
                                ? Image.file(
                                  File(uploadImageCtrl.imagePath.value),
                                  fit: BoxFit.cover,
                                )
                                : image.isNotEmpty
                                ? CustomNetworkImage(
                                  imageUrl: image,
                                  boxShape: BoxShape.circle,
                                  width: 76,
                                  height: 76,
                                )
                                : Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: AppColors.brandGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Text(
                                    initials.isEmpty ? 'MS' : initials,
                                    style: AppStyles.h3(
                                      color: Colors.white,
                                      fontFamily: 'InterBold',
                                    ),
                                  ),
                                ),
                      ),
                    );
                  }),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: InkWell(
                      onTap: _openImagePickerSheet,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Obx(
                          () =>
                              uploadImageCtrl.isUploading.value
                                  ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 14,
                                    color: AppColors.brandPrimary,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  final p = profileController.effectiveProfile;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.fullName.trim().isEmpty ? 'Mr. Sham' : p.fullName,
                        style: AppStyles.h2(
                          color: Colors.white,
                          fontFamily: 'InterBold',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.email.trim().isEmpty ? 'mr.sham@torqon.app' : p.email,
                        style: AppStyles.h5(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            size: 16,
                            color: Color(0xFFFFE7A2),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _roleLabel(p.role),
                            style: AppStyles.h5(
                              color: Colors.white,
                              fontFamily: 'InterSemiBold',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color:
              danger
                  ? Colors.white.withValues(alpha: 0.20)
                  : Colors.white.withValues(alpha: 0.92),
        ),
        child: Icon(
          icon,
          color: danger ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A202B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.45),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return ListTile(
      dense: true,
      minVerticalPadding: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        width: 33,
        height: 33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              Get.isDarkMode
                  ? const Color(0xFF252D3A)
                  : const Color(0xFFF3F6FC),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Get.theme.textTheme.bodyLarge!.color,
        ),
      ),
      title: Text(title, style: AppStyles.h4(fontFamily: 'InterSemiBold')),
      trailing:
          badgeCount > 0
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$badgeCount',
                  style: AppStyles.h6(
                    color: Colors.white,
                    fontFamily: 'InterSemiBold',
                  ),
                ),
              )
              : const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildBuildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A202B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Build Date: June 2025',
            style: AppStyles.h5(color: AppColors.subTextColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Build SHA: e0a1c9b',
            style: AppStyles.h5(color: AppColors.subTextColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Version: 2.1.3',
            style: AppStyles.h5(color: AppColors.subTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutTile() {
    return InkWell(
      onTap: () {
        Get.dialog(
          CustomDialog(
            message: 'Are you sure you want to logout?',
            confirmText: 'Yes',
            onConfirm: () async {
              await PrefsHelper.remove(AppConstants.bearerToken);
              await PrefsHelper.remove(AppConstants.userID);
              await SocketService.instance.logout();
              SocketService.instance.dispose();
              Get.offAllNamed(AppRoutes.signInScreen);
            },
          ),
          barrierDismissible: true,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color:
              Get.isDarkMode
                  ? const Color(0xFF261B20)
                  : const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD7D7)),
        ),
        child: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFE44747)),
            const SizedBox(width: 10),
            Text(
              'Sign Out',
              style: AppStyles.h4(
                color: const Color(0xFFE44747),
                fontFamily: 'InterSemiBold',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(String role) {
    if (role.toLowerCase().contains('garage')) return 'Garage Guru';
    if (role.toLowerCase().contains('mechanic') ||
        role.toLowerCase().contains('macanic')) {
      return 'Mechanic Pro';
    }
    return 'Car Enthusiast';
  }

  void _navigateFromDrawer(BuildContext context, String route) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 130), () {
      if (mounted) {
        Get.toNamed(route);
      }
    });
  }

  void _openImagePickerSheet() {
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
    uploadImageCtrl.fileUrl.value = '';
    uploadImageCtrl.uploadComplete.value = false;
    await uploadImageCtrl.pickImage(source);

    var waitedMs = 0;
    while (!uploadImageCtrl.uploadComplete.value &&
        uploadImageCtrl.fileUrl.value.isEmpty &&
        waitedMs < 10000) {
      await Future.delayed(const Duration(milliseconds: 150));
      waitedMs += 150;
    }

    if (uploadImageCtrl.fileUrl.value.isNotEmpty) {
      await profileController.updateProfileImageOnly(
        uploadImageCtrl.fileUrl.value,
      );
      uploadImageCtrl.imagePath.value = '';
    } else {
      Get.snackbar(
        'Upload failed',
        'Could not upload image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

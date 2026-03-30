import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/security_controller.dart';
import 'package:car_care/views/base/custom_button.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  SecurityScreen({super.key});

  final SecurityController _securityCtrl = Get.put(SecurityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Obx(
                () => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  children: [
                    _sectionTitle('Change Password', icon: Icons.key_rounded),
                    const SizedBox(height: 10),
                    _fieldLabel('Current Password'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _securityCtrl.currentPasswordController,
                      hintText: 'Enter current password',
                      isPassword: true,
                      contenpaddingVertical: 12,
                    ),
                    const SizedBox(height: 10),
                    _fieldLabel('New Password'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _securityCtrl.newPasswordController,
                      hintText: 'Enter new password',
                      isPassword: true,
                      contenpaddingVertical: 12,
                    ),
                    const SizedBox(height: 10),
                    _fieldLabel('Confirm New Password'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _securityCtrl.confirmPasswordController,
                      hintText: 'Confirm new password',
                      isPassword: true,
                      contenpaddingVertical: 12,
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      loading: _securityCtrl.updatingPassword.value,
                      onTap: _securityCtrl.changePassword,
                      text: 'Update Password',
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(
                      'Biometric Login',
                      icon: Icons.fingerprint_rounded,
                    ),
                    const SizedBox(height: 10),
                    _switchTile(
                      title: 'Face ID / Fingerprint',
                      subtitle:
                          'Use biometric authentication to unlock the app',
                      value: _securityCtrl.biometricEnabled.value,
                      onChanged: _securityCtrl.setBiometric,
                    ),
                    const SizedBox(height: 14),
                    _sectionTitle(
                      'Two-Factor Authentication',
                      icon: Icons.shield_outlined,
                    ),
                    const SizedBox(height: 10),
                    _switchTile(
                      title: 'Enable 2FA',
                      subtitle:
                          'Add an extra layer of security to your account',
                      value: _securityCtrl.twoFactorEnabled.value,
                      onChanged: _securityCtrl.setTwoFactor,
                    ),
                    const SizedBox(height: 10),
                    _switchTile(
                      title: 'App Lock PIN',
                      subtitle: 'Require PIN to open the app',
                      value: _securityCtrl.pinLockEnabled.value,
                      onChanged: _securityCtrl.setPinLock,
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(
                      'Active Sessions',
                      icon: Icons.devices_rounded,
                    ),
                    const SizedBox(height: 10),
                    if (_securityCtrl.loadingSessions.value)
                      const Center(child: CustomPageLoading())
                    else
                      ..._securityCtrl.sessions.map(_sessionTile),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: NavigationHelper.backOrHome,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color:
                    Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.white.withValues(alpha: 0.88),
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Get.theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Security & Login',
            style: AppStyles.h2(fontFamily: 'InterSemiBold'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brandPrimary, size: 20),
        const SizedBox(width: 8),
        Text(text, style: AppStyles.h2(fontFamily: 'InterSemiBold')),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(text, style: AppStyles.h4(fontFamily: 'InterSemiBold'));
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.88),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.h3(fontFamily: 'InterSemiBold')),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppStyles.h5(
                    color: AppColors.subTextColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }

  Widget _sessionTile(SecuritySession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.88),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_iphone_rounded, color: AppColors.brandPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        session.deviceName,
                        style: AppStyles.h3(fontFamily: 'InterSemiBold'),
                      ),
                    ),
                    if (session.isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: const Color(0xFFE5F7EA),
                        ),
                        child: Text(
                          'Current',
                          style: AppStyles.h6(
                            color: const Color(0xFF1B8B43),
                            fontFamily: 'InterSemiBold',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  session.location,
                  style: AppStyles.h5(color: AppColors.subTextColor),
                ),
                Text(
                  session.lastActiveText,
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

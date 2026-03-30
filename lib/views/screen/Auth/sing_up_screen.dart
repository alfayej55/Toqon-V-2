import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/auth_controller.dart';
import '../../../service/google_api_service.dart';
import '../../base/custom_gradiand_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController(), permanent: true);

  // final _locationController = TextEditingController();
  //
  // @override
  // void dispose() {
  //   _locationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color panelColor =
        isDark
            ? const Color(0x99181F2B)
            : Colors.white.withValues(alpha: 0.16);
    final Color fieldColor =
        isDark ? const Color(0xDD1D2532) : Colors.white.withValues(alpha: 0.92);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.brandGradient,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                        decoration: BoxDecoration(
                          color: panelColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.torqonLogoIcon,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Join Torqon',
                                        style: AppStyles.h3(
                                          color: Colors.white,
                                          fontFamily: 'InterSemiBold',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Create your profile in under 60 seconds',
                                        style: AppStyles.h6(
                                          color: Colors.white.withValues(
                                            alpha: 0.88,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              hintText: 'Full name',
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                  AppIcons.profileIcon,
                                  colorFilter: ColorFilter.mode(
                                    Get.theme.textTheme.bodyMedium!.color!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: authController.fullNameCtrl,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Email address',
                              isEmail: true,
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(AppIcons.emailIcon),
                              ),
                              controller: authController.emailCtrl,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Phone number',
                              keyboardType: TextInputType.phone,
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.phone_outlined,
                                  color: Get.theme.textTheme.bodyMedium!.color!,
                                ),
                              ),
                              controller: authController.phoneCtrl,
                            ),
                            const SizedBox(height: 10),
                            TypeAheadField<String>(
                              controller: authController.locationCtrl,
                              suggestionsCallback: (search) async {
                                if (search.isEmpty) return [];
                                return await GoogleApiService.fetchSuggestions(
                                  search,
                                );
                              },
                              builder: (context, controller, focusNode) {
                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  cursorColor: AppColors.primaryColor,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter location";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Location',
                                    hintStyle: TextStyle(
                                      color: AppColors.hintColor,
                                      fontFamily: 'Poppins',
                                    ),
                                    filled: true,
                                    fillColor: fieldColor,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 5,
                                      ),
                                      child: SvgPicture.asset(
                                        AppIcons.locationIcon,
                                        height: 18,
                                        colorFilter: ColorFilter.mode(
                                          Get.theme.textTheme.bodyMedium!.color!,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minHeight: 24,
                                      minWidth: 24,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.primaryColor,
                                  ),
                                  title: Text(
                                    suggestion,
                                    style: AppStyles.h6(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              onSelected: (value) {
                                authController.locationCtrl.text = value;
                              },
                              emptyBuilder:
                                  (context) => const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text('No location found'),
                                  ),
                              loadingBuilder:
                                  (context) => const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                              decorationBuilder: (context, child) {
                                return Material(
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      isDark
                                          ? const Color(0xFF1D2532)
                                          : Colors.white,
                                  child: child,
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Password',
                              isPassword: true,
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: SvgPicture.asset(AppIcons.passwordIcon),
                              ),
                              controller: authController.passwordCtrl,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Confirm password',
                              isPassword: true,
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: SvgPicture.asset(AppIcons.passwordIcon),
                              ),
                              controller: authController.confirmPasswordCtrl,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Referral code (Optional)',
                              validator: (value) => null,
                              filColor: fieldColor,
                              contenpaddingHorizontal: 14,
                              contenpaddingVertical: 14,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: Icon(
                                  Icons.card_giftcard_outlined,
                                  color: Get.theme.textTheme.bodyMedium!.color,
                                ),
                              ),
                              controller: authController.referralCodeCtrl,
                            ),
                            const SizedBox(height: 14),
                            Obx(
                              () => CustomGradientButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (authController.passwordCtrl.text !=
                                        authController.confirmPasswordCtrl.text) {
                                      Get.snackbar(
                                        'Error',
                                        'Passwords do not match',
                                      );
                                      return;
                                    }
                                    authController.signUp();
                                  }
                                },
                                loading: authController.signUpLoading.value,
                                text: 'Create Account',
                                height: 44,
                                borderRadius: BorderRadius.circular(14),
                                showGlow: false,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: AppStyles.h6(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    'Sign in',
                                    style: AppStyles.h6(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'InterSemiBold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

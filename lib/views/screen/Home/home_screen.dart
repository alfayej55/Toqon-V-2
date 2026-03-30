import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/home_controller.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../Widget/garage_profile.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  var buttonInfo = [
    {
      "title": AppString.serviceText,
      "icon": AppIcons.serviceIcon,
      "action": "service",
    },
    {
      "title": AppString.communityText,
      "icon": AppIcons.communityIcon,
      "action": "community",
    },
    {
      "title": AppString.offersText,
      "icon": AppIcons.offerIcon,
      "action": "offers",
    },
    {
      "title": AppString.careDraftText,
      "icon": AppIcons.careDrftIcon,
      "action": "care_draft",
    },
  ];

  HomeController homeCtrl = Get.put(HomeController());
  final profileController = Get.put(ProfileController());
  late final AnimationController _surprisePulseCtrl;

  @override
  void initState() {
    _surprisePulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeCtrl.getGarage();
    });

    super.initState();
  }

  @override
  void dispose() {
    _surprisePulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Obx(() {
            final profile = profileController.effectiveProfile;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome ${profile.fullName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                ),
                SizedBox(height: 3),
                Text(
                  "DRIVE WITH CONFIDENCE. TRUST EVERY DECISION.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customSize(
                    size: 10,
                    color: AppColors.grayColor,
                    fontFamily: 'InterMedium',
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            );
          }),
        ),

        actions: [
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                  //  Get.find<ThemeController>().toggleTheme();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Obx(() {
                    final profile = profileController.effectiveProfile;
                    return Container(
                      width: 41,
                      height: 41,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.25,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            profile.image.trim().isNotEmpty
                                ? CustomNetworkImage(
                                  imageUrl: profile.image,
                                  boxShape: BoxShape.circle,
                                  width: 41,
                                  height: 41,
                                )
                                : Center(
                                  child: SvgPicture.asset(
                                    AppIcons.profileIcon,
                                    height: 23,
                                    width: 16,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.whiteColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),

          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.chatScreen);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppIcons.chatIcon,
                    height: 23,
                    width: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      endDrawer: SizedBox(child: ProfileMenu()),

      bottomNavigationBar: BottomMenu(0),

      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 10),
            aiScannerContainer(context),
            SizedBox(height: 10),
            buildQuickActionItem(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.nearbyGarageText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.h5(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  AppString.seeAllText,
                  style: AppStyles.h5(color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 10),

            Obx(
              () =>
                  homeCtrl.garageLoading.value
                      ? Center(child: CustomPageLoading())
                      : ListView.builder(
                        itemCount: homeCtrl.garageList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var garageIf = homeCtrl.garageList[index];

                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.garageDetailsScreen,
                                arguments: {
                                  'serviceId': '',
                                  'garageID': garageIf.id,
                                  'serviceName': 'Garage Details',
                                },
                              );
                            },
                            child: GarageProfileWidget(profileModel: garageIf),
                          );
                        },
                      ),
            ),
            SizedBox(height: 14),
            _surpriseDropCard(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Ai Scanner Container
  aiScannerContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.aiDetection);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(44),
          ),
          gradient: const LinearGradient(
            colors: AppColors.brandGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
              ),
            ),
            Positioned(
              bottom: -56,
              left: 26,
              child: Container(
                width: 180,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.black.withValues(alpha: 0.10),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _aiChip('AI-powered'),
                    const SizedBox(width: 8),
                    _aiChip('Instant insights'),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppString.aiDamageText.toUpperCase(),
                  style: TextStyle(
                    fontSize: 21,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.05,
                    height: 1.0,
                    fontFamily: 'RushDriverItalic',
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppString.aiDamageSybText.toUpperCase(),
                  style: AppStyles.customSize(
                    size: 10.2,
                    color: AppColors.whiteColor.withValues(alpha: 0.95),
                    fontFamily: 'InterSemiBold',
                    letterSpacing: 1.35,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/Robot-Bot 3D.json',
                      height: 70,
                      repeat: true,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.34),
                              width: 1.4,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.14),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.cameraIcon,
                                  height: 22,
                                  width: 22,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withValues(alpha: 0.18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                            ),
                          ),
                          child: Text(
                            'SNAP YOUR DRIVE',
                            style: AppStyles.customSize(
                              size: 10,
                              color: Colors.white,
                              fontFamily: 'InterSemiBold',
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _aiChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        style: AppStyles.customSize(
          size: 11,
          color: Colors.white,
          fontFamily: 'InterSemiBold',
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  buildQuickActionItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          buttonInfo.map((button) {
            return Flexible(
              child: InkWell(
                onTap: () {
                  switch (button['action'] as String) {
                    case 'service':
                      Get.toNamed(AppRoutes.serviceScreen);
                      break;
                    case 'community':
                      Get.toNamed(AppRoutes.communityScreen);
                      break;
                    case 'offers':
                      Get.toNamed(AppRoutes.offerScreen);
                      break;
                    case 'care_draft':
                      Get.toNamed(AppRoutes.careGraphScreen);
                      break;
                    default:
                      // Optional: handle unknown action
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Coming soon!')));
                  }
                  // Handle navigation based on title
                },

                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.brandGradient,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            button['icon'] as String,
                            height: 23,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              AppColors.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(50),
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
                      //     child: Container(
                      //       width: 56,
                      //       height: 56,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white.withValues(alpha: 0.3),
                      //         gradient: LinearGradient(
                      //           colors: [Color(0xFF9C27B0), Color(0xFFFF5722)],
                      //           begin: Alignment.topLeft,
                      //           end: Alignment.bottomRight,
                      //         ),
                      //         // gradient: LinearGradient(
                      //         //   begin: Alignment.topLeft,
                      //         //   end: Alignment.bottomRight,
                      //         //   colors: [
                      //         //
                      //         //
                      //         //       Color(0xFF5f4e32),
                      //         //       Color(0xFF5f4e32),
                      //         //
                      //         //     // Colors.white.withValues(alpha: 0.6),
                      //         //     // Colors.white10
                      //         //
                      //         //   ],
                      //         // ),
                      //        // color: AppColors.primaryColor,
                      //         shape: BoxShape.circle,
                      //         // boxShadow: [
                      //         //   BoxShadow(
                      //         //     color: AppColors.primaryColor.withValues(alpha: 0.25),
                      //         //     blurRadius: 10,
                      //         //     offset: Offset(0, 4),
                      //         //   ),
                      //         // ],
                      //       ),
                      //       child: Center(
                      //         child: SvgPicture.asset(
                      //           button['icon'] as String,
                      //           height: 23,
                      //           width: 16,
                      //           colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Text(
                        button['title'] as String,
                        style: AppStyles.h6(
                          // color: AppColors.blackColor,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontFamily: 'Regular',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _surpriseDropCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: AppColors.brandGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPrimary.withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surprise Drop',
                      style: AppStyles.h2(
                        color: Colors.white,
                        fontFamily: 'InterBold',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Unlock a 2x points mission and surprise service gifts',
                      style: AppStyles.h5(
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.08).animate(
                  CurvedAnimation(
                    parent: _surprisePulseCtrl,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: RotationTransition(
                  turns: Tween<double>(begin: -0.01, end: 0.01).animate(
                    CurvedAnimation(
                      parent: _surprisePulseCtrl,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Center(
                      child: Text('🎁', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _surpriseButton(
                  label: 'VIEW OFFERS',
                  onTap: () => Get.toNamed(AppRoutes.offerScreen),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _surpriseButton(
                  label: 'CLAIM 2X',
                  onTap: _showSurpriseDialog,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _surpriseButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.white.withValues(alpha: 0.20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
        ),
        child: Center(
          child: Text(
            label,
            style: AppStyles.h6(
              color: Colors.white,
              fontFamily: 'InterSemiBold',
            ),
          ),
        ),
      ),
    );
  }

  void _showSurpriseDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'surprise',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(horizontal: 22),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color:
                    Get.isDarkMode
                        ? const Color(0xF01A2230)
                        : const Color(0xF8FFFFFF),
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.24),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: AppColors.brandGradient,
                          ),
                        ),
                        child: const Center(
                          child: Text('🎉', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Today’s Surprise Is Live',
                          style: AppStyles.h3(fontFamily: 'InterBold'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete one service flow today to unlock 2x points. '
                    'Selected users can get a free oil change gift.',
                    style: AppStyles.h5(
                      color: Get.theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutes.offerScreen);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: AppColors.borderColor.withValues(
                                alpha: 0.9,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'View Offers',
                            style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutes.rewardsScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Activate 2x',
                            style: AppStyles.h5(
                              color: Colors.white,
                              fontFamily: 'InterSemiBold',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

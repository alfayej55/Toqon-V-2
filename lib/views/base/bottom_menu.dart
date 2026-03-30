//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:car_care/all_export.dart';
//
//
// class BottomMenu extends StatelessWidget {
//   final int menuIndex;
//
//   const BottomMenu(this.menuIndex, {super.key});
//
//   Color colorByIndex(ThemeData theme, int index) {
//     return index == menuIndex ? AppColors.primaryColor : theme.disabledColor;
//   }
//
//   BottomNavigationBarItem getItem(
//       String image, String title, ThemeData theme, int index) {
//     return BottomNavigationBarItem(
//         label: title,
//         icon: Padding(
//           padding: const EdgeInsets.only(top:8),
//           child: SvgPicture.asset(
//             image,
//             height: 24.0,
//             width: 24.0,
//             colorFilter: ColorFilter.mode(colorByIndex(theme, index), BlendMode.srcIn),
//           ),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     List<BottomNavigationBarItem> menuItems = [
//       getItem(AppIcons.homeIcon, 'Home', theme, 0),
//       getItem(AppIcons.locationIcon, 'Location', theme, 1),
//       getItem(AppIcons.addIcon, 'Quick A', theme, 2),
//       getItem(AppIcons.rewordIcon, 'Reward', theme, 3),
//       getItem(AppIcons.walletIcon, 'Wallet', theme, 4),
//     ];
//
//     return Container(
//       decoration: BoxDecoration(
//           //color: Colors.white,
//           color: Colors.transparent,
//           // borderRadius: BorderRadius.only(
//           //     topRight: Radius.circular(20.r),topLeft: Radius.circular(20.r)
//           // ),
//           boxShadow: const [
//             BoxShadow(color:Colors.black38,spreadRadius:0,blurRadius: 2)
//           ]
//       ),
//       child: ClipRRect(
//
//         // borderRadius: BorderRadius.only(
//         //     topRight: Radius.circular(20.r),topLeft: Radius.circular(20.r)
//         //
//         // ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           //backgroundColor: Colors.transparent,
//           selectedItemColor:Theme.of(context).primaryColor,
//           currentIndex: menuIndex,
//           onTap: (value) {
//             switch (value) {
//               case 0:
//                 Get.offAndToNamed(AppRoutes.homeScreen);
//                 break;
//               case 1:
//                 Get.offAndToNamed(AppRoutes.locationsScreen);
//                 break;
//               case 2:
//                 uploadImageDialog(context);
//                 break;
//               case 3:
//                 Get.offAndToNamed(AppRoutes.rewardsScreen);
//                 break;
//               case 4:
//                 Get.offAndToNamed(AppRoutes.walletScreen);
//                 break;
//             }
//           },
//           items: menuItems,
//         ),
//       ),
//     );
//   }
//
//   void uploadImageDialog(BuildContext context) {
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Text(
//                      'Quick Actions',
//                      style: AppStyles.h5(
//                        fontFamily: 'InterSemiBold',
//                      ),
//                    ),
//                      IconButton(
//                      padding: EdgeInsets.zero,
//                       onPressed: (){
//                        Get.back();
//                       }, icon: Icon(Icons.close))
//                   // Icon(Icons.close)
//                  ],
//                ),
//
//               Wrap(
//                 spacing: 5,
//                 children: [
//                   InkWell(
//                     onTap: (){
//                       Get.toNamed(AppRoutes.myBookingScreen);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Get.theme.cardColor,
//                           border: Border.all(
//                             color: AppColors.borderColor.withValues(alpha: 0.2),
//                             width: 1,
//                           ),
//                           boxShadow: [
//                             AppStyles.boxShadow
//                           ]),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor:AppColors.primaryColor,
//                             child: SvgPicture.asset(AppIcons.serviceIcon),
//                           ),
//                           SizedBox(height:10,),
//                           Text(
//                             'My Booking ',
//                             style: AppStyles.h5(
//                               fontFamily: 'InterSemiBold',
//                             ),
//                           ),
//                           // Text(
//                           //   'Shedule maintenece',
//                           //   style: AppStyles.h6(
//                           //     color: Get.theme.textTheme.bodyMedium!.color,
//                           //     fontFamily: 'InterSemiBold',
//                           //   ),
//                           // ),
//                         ],
//                       ),
//
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       Get.back();
//                       Get.toNamed(AppRoutes.callSuportScreen);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Get.theme.cardColor,
//                           border: Border.all(
//                             color: AppColors.borderColor.withValues(alpha: 0.2),
//                             width: 1,
//                           ),
//                           boxShadow: [
//                             AppStyles.boxShadow
//                           ]),
//                           child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor:AppColors.primaryColor,
//                             child: SvgPicture.asset(AppIcons.callIcon),
//                           ),
//                           SizedBox(height:10,),
//                           Text(
//                             '24/7 support',
//                             style: AppStyles.h5(
//                               fontFamily: 'InterSemiBold',
//                             ),
//                           ),
//                           // Text(
//                           //   '24/7 support',
//                           //   style: AppStyles.h6(
//                           //     color: Get.theme.textTheme.bodyMedium!.color,
//                           //     fontFamily: 'InterSemiBold',
//                           //   ),
//                           // ),
//                         ],
//                       ),
//
//                     ),
//                   ),
//
//                 ],
//               )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:car_care/all_export.dart';
import 'dart:ui';

class BottomMenu extends StatelessWidget {
  final int menuIndex;

  const BottomMenu(this.menuIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive sizing: scale down on smaller screens
    final double navSize = screenWidth < 360 ? 40 : 48;
    final double spacing = screenWidth < 360 ? 4 : 8;
    final double horizontalPadding = screenWidth < 360 ? 6 : 10;

    return Container(
      margin: EdgeInsets.only(
        top: 4,
        left: 12,
        right: 12,
        bottom: bottomPadding + 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 8),
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode
                      ? const Color(0xC7141A24)
                      : Colors.white.withValues(alpha: 0.82),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: Get.isDarkMode ? 0.10 : 0.78,
                ),
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: Get.isDarkMode ? 0.25 : 0.12,
                  ),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                _navCircle(
                  icon: AppIcons.homeIcon,
                  isSelected: menuIndex == 0,
                  onTap: () => _onTap(context, 0),
                  size: navSize,
                ),
                SizedBox(width: spacing),
                _navCircle(
                  icon: AppIcons.locationIcon,
                  isSelected: menuIndex == 1,
                  onTap: () => _onTap(context, 1),
                  size: navSize,
                ),
                SizedBox(width: spacing),
                Expanded(child: _centerPill(context, height: navSize)),
                SizedBox(width: spacing),
                _navCircle(
                  icon: AppIcons.rewordIcon,
                  isSelected: menuIndex == 3,
                  onTap: () => _onTap(context, 3),
                  size: navSize,
                ),
                SizedBox(width: spacing),
                _navCircle(
                  icon: AppIcons.walletIcon,
                  isSelected: menuIndex == 4,
                  onTap: () => _onTap(context, 4),
                  size: navSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (Get.currentRoute != AppRoutes.homeScreen) {
          Get.toNamed(AppRoutes.homeScreen, preventDuplicates: true);
        }
        break;
      case 1:
        if (Get.currentRoute != AppRoutes.locationsScreen) {
          Get.toNamed(AppRoutes.locationsScreen, preventDuplicates: true);
        }
        break;
      case 2:
        uploadImageDialog(context);
        break;
      case 3:
        if (Get.currentRoute != AppRoutes.rewardsScreen) {
          Get.toNamed(AppRoutes.rewardsScreen, preventDuplicates: true);
        }
        break;
      case 4:
        if (Get.currentRoute != AppRoutes.walletScreen) {
          Get.toNamed(AppRoutes.walletScreen, preventDuplicates: true);
        }
        break;
    }
  }

  Widget _navCircle({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
    double size = 48,
  }) {
    final double iconSize = size < 44 ? 18 : 22;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color:
              isSelected
                  ? null
                  : (Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.75)),
          border: Border.all(
            color:
                isSelected
                    ? Colors.transparent
                    : Colors.white.withValues(
                      alpha: Get.isDarkMode ? 0.10 : 0.88,
                    ),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            height: iconSize,
            width: iconSize,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? Colors.white
                  : (Get.isDarkMode
                      ? const Color(0xFFB2BAC9)
                      : const Color(0xFF5E6778)),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _centerPill(BuildContext context, {double height = 48}) {
    final bool isSelected = menuIndex == 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = height < 44 ? 18 : 22;
    final double horizontalPadding = screenWidth < 360 ? 8 : 14;

    return InkWell(
      onTap: () => _onTap(context, 2),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color:
              isSelected
                  ? null
                  : (Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.78)),
          border: Border.all(
            color:
                isSelected
                    ? Colors.transparent
                    : Colors.white.withValues(
                      alpha: Get.isDarkMode ? 0.10 : 0.90,
                    ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.keyboard_arrow_up_rounded,
              size: iconSize,
              color:
                  isSelected
                      ? Colors.white
                      : (Get.isDarkMode
                          ? const Color(0xFFB2BAC9)
                          : const Color(0xFF5E6778)),
            ),
            SizedBox(width: screenWidth < 360 ? 4 : 8),
            Flexible(
              child: Text(
                'Quick Actions',
                style: AppStyles.h6(
                  color:
                      isSelected
                          ? Colors.white
                          : (Get.isDarkMode
                              ? const Color(0xFFCDD3DF)
                              : const Color(0xFF61697A)),
                  fontFamily: 'InterSemiBold',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode
                      ? const Color(0xEF181C24)
                      : const Color(0xF7FFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.38),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: Get.back,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 26,
                    height: 22,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color:
                          Get.isDarkMode
                              ? const Color(0xFFC9D2E3)
                              : const Color(0xFF4F5B70),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _quickActionPill(
                        title: 'Book Service',
                        icon: Icons.event_note_rounded,
                        gradient: const [Color(0xFF3984F1), Color(0xFF2A66D4)],
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.myBookingScreen);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickActionPill(
                        title: 'Emergency',
                        icon: Icons.support_agent_rounded,
                        gradient: const [Color(0xFFF35A47), Color(0xFFD6362F)],
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.callSuportScreen);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _quickActionPill(
                        title: 'Refer Friend',
                        icon: Icons.group_add_rounded,
                        gradient: const [
                          AppColors.brandDeep,
                          AppColors.brandPrimary,
                        ],
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.rewardsScreen);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickActionPill(
                        title: 'Post',
                        icon: Icons.campaign_rounded,
                        gradient: const [
                          AppColors.brandPrimary,
                          AppColors.brandWarm,
                        ],
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.createCommunityScreen);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickActionPill({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 140;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 52,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 6 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color:
                  Get.isDarkMode
                      ? const Color(0xFF1F2430)
                      : const Color(0xFFF9FAFD),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isCompact ? 26 : 30,
                  height: isCompact ? 26 : 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: isCompact ? 14 : 16),
                ),
                SizedBox(width: isCompact ? 4 : 8),
                Flexible(
                  child: Text(
                    title,
                    style: AppStyles.h6(fontFamily: 'InterSemiBold'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

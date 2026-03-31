import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/community_controller.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Widget/community_card.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final TextEditingController searchCTrl = TextEditingController();
  final CommunityController _communityCtrl = Get.put(CommunityController());
  final ProfileController _profileCtrl =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 130,
              left: -80,
              child: _bgGlow(const Color(0x12A32B43), 220),
            ),
            Positioned(
              top: 170,
              right: -90,
              child: _bgGlow(const Color(0x12F08E2F), 240),
            ),
            SafeArea(
              minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Column(
                children: [
                  _topHeader(context),
                  const SizedBox(height: 10),
                  _searchField(),
                  const SizedBox(height: 10),
                  _heroPanel(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GetX<CommunityController>(
                      builder: (controller) {
                        final filteredList = controller.filteredCommunityList;
                        return Column(
                          children: [
                            _filterRail(controller),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '${filteredList.length} live posts',
                                  style: AppStyles.h6(
                                    fontFamily: 'InterSemiBold',
                                    color:
                                        isDark
                                            ? const Color(0xFFA9B1C2)
                                            : const Color(0xFF6E7586),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child:
                                  controller.communityLoading.value
                                      ? const Center(child: CustomPageLoading())
                                      : filteredList.isEmpty
                                      ? _emptyState(context)
                                      : ListView.builder(
                                        itemCount: filteredList.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final communityInfo =
                                              filteredList[index];
                                          return CommunityCard(
                                            index: index,
                                            communityModel: communityInfo,
                                          );
                                        },
                                      ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            NavigationHelper.backOrHome();
          },
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white,
              border: Border.all(color: const Color(0xFFE2E6EF)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Torqon Community',
            style: AppStyles.h5(
              fontFamily: 'InterBold',
              color:
                  Get.isDarkMode
                      ? const Color(0xFFEAF0FF)
                      : const Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Obx(() {
          final p = _profileCtrl.effectiveProfile;
          return InkWell(
            onTap:
                () => Get.toNamed(
                  AppRoutes.profileScreen,
                  arguments: {
                    'name': p.fullName,
                    'email': p.email,
                    'address': p.address,
                    'birthday': _formatDate(p.dateOfBirth),
                    'image': p.image,
                  },
                ),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white,
                border: Border.all(color: const Color(0xFFE2E6EF)),
              ),
              child: ClipOval(
                child:
                    p.image.trim().isEmpty
                        ? Icon(
                          Icons.person_outline_rounded,
                          size: 22,
                          color:
                              Get.isDarkMode
                                  ? Color(0xFFEAF0FF)
                                  : Color(0xFF111827),
                        )
                        : CustomNetworkImage(
                          imageUrl: p.image,
                          boxShape: BoxShape.circle,
                          width: 42,
                          height: 42,
                        ),
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.createCommunityScreen),
          borderRadius: BorderRadius.circular(999),
          child: _headerIcon(AppIcons.addIcon),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.chatScreen),
          borderRadius: BorderRadius.circular(999),
          child: _headerIcon(AppIcons.chatIcon),
        ),
      ],
    );
  }

  Widget _heroPanel() {
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
            color: AppColors.brandPrimary.withValues(alpha: 0.26),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Build. Flex. Fix.',
            style: AppStyles.h2(color: Colors.white, fontFamily: 'InterBold'),
          ),
          const SizedBox(height: 4),
          Text(
            'Your premium social garage for cars, reels and jobs',
            style: AppStyles.h6(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _heroBadge('Nearby', Icons.near_me_rounded),
              const SizedBox(width: 8),
              _heroBadge('Verified', Icons.verified_rounded),
              const SizedBox(width: 8),
              _heroBadge('Jobs', Icons.build_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppStyles.h6(
              color: Colors.white,
              fontFamily: 'InterSemiBold',
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomTextField(
        controller: searchCTrl,
        hintText: 'Search builds, jobs, garages',
        onChanged: _communityCtrl.setSearchQuery,
        contenpaddingVertical: 14,
        contenpaddingHorizontal: 16,
        filColor: Colors.transparent,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 8),
          child: Icon(
            Icons.search_rounded,
            color:
                Get.isDarkMode ? const Color(0xFFA6B0C2) : Colors.grey.shade500,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _filterRail(CommunityController controller) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.feedFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String filter = controller.feedFilters[index];
          final bool selected = controller.selectedFeedFilter.value == filter;

          return InkWell(
            onTap: () => controller.setFeedFilter(filter),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient:
                    selected
                        ? const LinearGradient(colors: AppColors.brandGradient)
                        : null,
                color:
                    selected
                        ? null
                        : (Get.isDarkMode
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white),
                border: Border.all(
                  color:
                      selected
                          ? Colors.transparent
                          : (Get.isDarkMode
                              ? Colors.white.withValues(alpha: 0.12)
                              : const Color(0xFFE8EAF0)),
                ),
                boxShadow:
                    selected
                        ? [
                          BoxShadow(
                            color: AppColors.brandPrimary.withValues(
                              alpha: 0.24,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              child: Text(
                filter,
                style: AppStyles.h6(
                  fontFamily: 'InterSemiBold',
                  color:
                      selected
                          ? Colors.white
                          : (Get.isDarkMode
                              ? const Color(0xFFCAD3E3)
                              : const Color(0xFF5E6472)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 152,
            height: 152,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.brandDeep.withValues(alpha: 0.12),
                  AppColors.brandWarm.withValues(alpha: 0.14),
                ],
              ),
              border: Border.all(
                color: AppColors.brandPrimary.withValues(alpha: 0.26),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.communityIcon,
                width: 72,
                height: 72,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Your Feed Is Waiting',
            style: AppStyles.h2(
              fontFamily: 'InterBold',
              color:
                  Get.isDarkMode
                      ? const Color(0xFFEAF0FF)
                      : const Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drop your first post to kick off the\nauto community vibe',
            style: AppStyles.h5(
              color:
                  Get.isDarkMode
                      ? const Color(0xFFA5AEC0)
                      : const Color(0xFF8D8F99),
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => _communityCtrl.getCommunity(),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Get.isDarkMode
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E6EF)),
                  ),
                  child: Text(
                    'Refresh',
                    style: AppStyles.h6(
                      fontFamily: 'InterSemiBold',
                      color:
                          Get.isDarkMode
                              ? const Color(0xFFCAD3E3)
                              : const Color(0xFF5F6678),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.createCommunityScreen),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.brandGradient,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    'Create First Post',
                    style: AppStyles.h6(
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
    );
  }

  Widget _headerIcon(String iconPath) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white,
        border: Border.all(color: const Color(0xFFE2E6EF)),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.brandPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _bgGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
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
}

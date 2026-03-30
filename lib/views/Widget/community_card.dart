import 'package:car_care/models/community_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/community_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/profile_model.dart';

class CommunityCard extends StatelessWidget {
  final CommunityModel communityModel;
  final int index;

  CommunityCard({super.key, required this.communityModel, required this.index});

  final CommunityController _communityCtrl =
      Get.isRegistered<CommunityController>()
          ? Get.find<CommunityController>()
          : Get.put(CommunityController());
  final ProfileController _profileCtrl =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final bool isHelpPost = communityModel.postType == 'helpost';
    final String postId = communityModel.id ?? '';
    final String userImage = communityModel.user?.image ?? '';
    final String userName =
        communityModel.user?.fullName.trim().isNotEmpty == true
            ? communityModel.user?.fullName ?? 'Torqon User'
            : 'Torqon User';
    final double distanceKm =
        communityModel.distanceInKm ?? communityModel.distance ?? 0;
    final bool isDark = Get.isDarkMode;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final currentProfile = _profileCtrl.effectiveProfile;
    final isCurrentUserPost =
        communityModel.user?.id.isNotEmpty == true &&
        communityModel.user?.id == currentProfile.id;
    final selectedProfile =
        isCurrentUserPost
            ? currentProfile
            : (communityModel.user ?? currentProfile);

    final Map<String, String> profileArgs = _profileArgs(selectedProfile);

    return Container(
      margin: const EdgeInsets.only(bottom: 14, top: 2),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : const Color(0xFFE9ECF3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap:
                    () => Get.toNamed(
                      AppRoutes.profileScreen,
                      arguments: profileArgs,
                    ),
                child: CustomNetworkImage(
                  imageUrl: userImage,
                  boxShape: BoxShape.circle,
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap:
                      () => Get.toNamed(
                        AppRoutes.profileScreen,
                        arguments: profileArgs,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userName,
                              style: AppStyles.h5(
                                fontFamily: 'InterSemiBold',
                                color:
                                    isDark
                                        ? const Color(0xFFEAF0FF)
                                        : const Color(0xFF101114),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (communityModel.user?.isVerified == true) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF2485FF),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            TimeFormatHelper.timeAgo(
                              communityModel.createdAt ?? DateTime.now(),
                            ),
                            style: AppStyles.h6(
                              color:
                                  isDark
                                      ? const Color(0xFFA8B1C2)
                                      : const Color(0xFF808390),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.circle,
                            size: 4,
                            color: Color(0xFFB7BBC7),
                          ),
                          const SizedBox(width: 6),
                          SvgPicture.asset(
                            AppIcons.locationIcon,
                            colorFilter: ColorFilter.mode(
                              isDark
                                  ? const Color(0xFFA8B1C2)
                                  : const Color(0xFF808390),
                              BlendMode.srcIn,
                            ),
                            height: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${distanceKm.toStringAsFixed(1)} km',
                            style: AppStyles.h6(
                              color:
                                  isDark
                                      ? const Color(0xFFA8B1C2)
                                      : const Color(0xFF808390),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          isHelpPost
                              ? const Color(0xFFFFF1EC)
                              : const Color(0xFFF0F8FF),
                    ),
                    child: Text(
                      isHelpPost ? 'Help Post' : 'Community',
                      style: AppStyles.h6(
                        fontFamily: 'InterSemiBold',
                        color:
                            isHelpPost
                                ? const Color(0xFFE95A2E)
                                : const Color(0xFF2D7FD8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (postId.isEmpty) return;
                          _communityCtrl.toggleSavePost(postId);
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.10)
                                    : const Color(0xFFF2F4F8),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(
                            communityModel.isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 18,
                            color:
                                communityModel.isSaved
                                    ? const Color(0xFFFF3B00)
                                    : const Color(0xFF667085),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _showShareBottomSheet(context),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.10)
                                    : const Color(0xFFF2F4F8),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(
                            Icons.ios_share_rounded,
                            size: 18,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (isHelpPost && communityModel.isSolved) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAFBF0),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Color(0xFF1D9C50),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Solved',
                    style: AppStyles.h6(
                      fontFamily: 'InterSemiBold',
                      color: const Color(0xFF1D9C50),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            communityModel.postDescription ?? '',
            style: AppStyles.h5(
              color: isDark ? const Color(0xFFEAF0FF) : const Color(0xFF20232A),
              fontFamily: 'Regular',
              height: 1.45,
            ),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          if (isHelpPost) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _specPill(
                  icon: Icons.directions_car_filled_rounded,
                  title: 'Car: ${communityModel.carType ?? ''}',
                ),
                _specPill(
                  icon: Icons.payments_rounded,
                  title: 'Budget: \$${communityModel.budget ?? 0}',
                ),
                _specPill(
                  icon: Icons.handyman_rounded,
                  title: 'Issue: ${communityModel.issueType ?? ''}',
                ),
                _specPill(
                  icon:
                      communityModel.isSolved
                          ? Icons.check_circle_rounded
                          : Icons.bolt_rounded,
                  title:
                      communityModel.isSolved
                          ? 'Status: Solved'
                          : 'Status: Active',
                ),
              ],
            ),
          ],
          if ((communityModel.postImage ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CustomNetworkImage(
                imageUrl: communityModel.postImage ?? '',
                width: screenWidth,
                height: screenHeight * 0.28,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (postId.isEmpty) return;
                    _communityCtrl.likeCommunity(postId);
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: _actionBadge(
                    icon: AppIcons.loveIcon,
                    count: '${communityModel.likeCount}',

                    iconColor:
                        communityModel.isLiked == true
                            ? Colors.red
                            : const Color(0xFF667085),
                    background:
                        communityModel.isLiked == true
                            ? const Color(0xFFFFEEF0)
                            : const Color(0xFFF2F4F8),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (postId.isEmpty) return;
                    _communityCtrl.getComments(postId);
                    _showCommentBottomSheet(context);
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: _actionBadge(
                    icon: AppIcons.commentIcon,
                    count: '${communityModel.commentCount}',
                    iconColor: const Color(0xFF667085),
                    background: const Color(0xFFF2F4F8),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showShareBottomSheet(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          size: 16,
                          color: Color(0xFF667085),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Share',
                          style: AppStyles.h6(
                            fontFamily: 'InterSemiBold',
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _specPill({required IconData icon, required String title}) {
    final bool isDark = Get.isDarkMode;
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : const Color(0xFFE8EBF2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? const Color(0xFFC7D2E8) : const Color(0xFF666D80),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppStyles.h6(
              color: isDark ? const Color(0xFFD8E1F3) : const Color(0xFF4A5060),
              fontFamily: 'InterMedium',
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBadge({
    required String icon,
    required String count,
    required Color iconColor,
    required Color background,
  }) {
    final bool isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: AppStyles.h6(
              fontFamily: 'InterSemiBold',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    final String postId = communityModel.id ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments',
                        style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: Get.theme.dividerColor.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: Obx(() {
                    if (_communityCtrl.commentLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_communityCtrl.commentList.isEmpty) {
                      return Center(
                        child: Text(
                          'No comments yet',
                          style: AppStyles.h5(color:Get.theme.textTheme.bodyLarge!.color),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: _communityCtrl.commentList.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            thickness: 0.2,
                            color: Get.theme.dividerColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                      itemBuilder: (context, index) {
                        final comment = _communityCtrl.commentList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.profileScreen,
                              arguments: _profileArgs(comment.user),
                            );
                          },
                          leading: CustomNetworkImage(
                            imageUrl: comment.user.image,
                            boxShape: BoxShape.circle,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            comment.user.fullName,
                            style: AppStyles.h5(fontFamily: 'InterSemiBold',   color:
                            Colors.black,),
                          ),
                          subtitle: Text(
                            comment.comment,
                            style: AppStyles.h6(
                              color:
                                  Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _communityCtrl.commentTextCtrl,
                            hintText: 'Write a comment...',
                            filColor: Colors.white,
                            textStyle: TextStyle(color: Colors.black),
                            maxLines: null,
                            minLines: 1,
                            contenpaddingVertical: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => InkWell(
                            onTap:
                                _communityCtrl.addCommentLoading.value
                                    ? null
                                    : () {
                                      if (postId.isEmpty) return;
                                      _communityCtrl.addComment(postId);
                                    },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child:
                                  _communityCtrl.addCommentLoading.value
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    final String title = (communityModel.postDescription ?? '').trim();
    final String safeTitle =
        title.isEmpty ? 'Check this auto post on Torqon' : title;
    final String deepLink =
        'https://torqon.app/community/${communityModel.id ?? ''}';
    final String shareText = '$safeTitle\n\n$deepLink';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Share Post',
                  style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _shareAction(
                        icon: Icons.share_rounded,
                        label: 'Share Now',
                        onTap: () {
                          Get.back();
                          Share.share(shareText);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _shareAction(
                        icon: Icons.link_rounded,
                        label: 'Copy Link',
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: deepLink),
                          );
                          Get.back();
                          Get.snackbar(
                            'Copied',
                            'Post link copied to clipboard',
                          );
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

  Widget _shareAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isDark = Get.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark ? const Color(0xFFEAF0FF) : const Color(0xFF4B5563),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.h6(
                fontFamily: 'InterSemiBold',
                color:
                    isDark ? const Color(0xFFEAF0FF) : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _profileArgs(ProfileModel profile) {
    final String safeName =
        profile.fullName.trim().isEmpty ? 'Torqon User' : profile.fullName;
    return {
      'name': safeName,
      'email':
          profile.email.trim().isEmpty
              ? 'Email not shared'
              : profile.email.trim(),
      'address':
          profile.address.trim().isEmpty
              ? 'Address not shared'
              : profile.address.trim(),
      'birthday': _formatDate(profile.dateOfBirth),
      'image': profile.image,
      'id': profile.id,
    };
  }
}

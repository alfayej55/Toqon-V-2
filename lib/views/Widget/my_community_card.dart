import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/models/community_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/community_controller.dart';
import '../../models/profile_model.dart';
import '../base/custom_gradiand_button.dart';

class MyCommunityCard extends StatelessWidget {
  final CommunityModel communityModel;
  final int index;
  MyCommunityCard({
    super.key,
    required this.communityModel,
    required this.index,
  });

  final CommunityController _communityCtrl = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 15),
      padding: EdgeInsets.all(Dimensions.radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Get.theme.cardColor,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [AppStyles.boxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap:
                () => Get.toNamed(
                  AppRoutes.profileScreen,
                  arguments: _profileArgs(communityModel.user!),
                ),
            leading: CustomNetworkImage(
              imageUrl: communityModel.user!.image,
              boxShape: BoxShape.circle,
              width: 50,
              height: 50,
            ),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    communityModel.user!.fullName,
                    style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (communityModel.user?.isVerified == true) ...[
                  SizedBox(width: 6),
                  Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: Color(0xFF2485FF),
                  ),
                ],
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  TimeFormatHelper.timeAgo(
                    communityModel.createdAt ?? DateTime.now(),
                  ),
                  style: AppStyles.h6(
                    color:
                        Get.theme.textTheme.bodyMedium!.color ??
                        AppColors.whiteColor.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(width: 4),
                SvgPicture.asset(
                  AppIcons.locationIcon,
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  height: 12,
                ),
                SizedBox(width: 4),
                Text(
                  '12 km',
                  style: AppStyles.h6(
                    color:
                        Get.theme.textTheme.bodyMedium!.color ??
                        AppColors.whiteColor.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            //trailing: Icon(Icons.more_vert, color: Colors.grey[600], size: 20),

            /// Post Edit and Deleted PopupMenu
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (String result) {
                if (result == 'edit') {
                  // Edit Post Selected
                } else if (result == 'delete') {}
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Edit Post',
                            style: AppStyles.h5(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      onTap: () {
                        debugPrint('Index>>>>$index');
                        _communityCtrl.deletePost(communityModel.id!, index);
                      },
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Delete Post',
                            style: AppStyles.h5(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
            visualDensity: VisualDensity.compact,
          ),

          Text(
            communityModel.postDescription ?? "",
            style: AppStyles.h5(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontFamily: 'Regular',
            ),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),

          /// >>>>>>>>>>>>> Help Post Info >>>>>>>>>>>>
          SizedBox(height: Dimensions.heightSize),
          communityModel.postType == 'helpost'
              ? Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Car: ${communityModel.carType ?? ''}',
                          style: AppStyles.h5(),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Budget: \$${communityModel.budget ?? 0}',
                          style: AppStyles.h5(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Issue: ${communityModel.issueType ?? ''}',
                          style: AppStyles.h5(),
                        ),
                        SizedBox(height: 3),
                        Text('Status: Active', style: AppStyles.h5()),
                      ],
                    ),
                  ),
                ],
              )
              : SizedBox(),

          SizedBox(height: Dimensions.paddingSize),
          CustomNetworkImage(
            imageUrl: communityModel.postImage ?? '',
            borderRadius: BorderRadius.circular(16),
            width: context.screenWidth,
            height: context.screenHeight * 0.2,
          ),

          SizedBox(height: Dimensions.paddingSize),

          // ❤️ Like & Comment Count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _communityCtrl.likeCommunity(communityModel.id!);
                          },
                          child: SvgPicture.asset(
                            AppIcons.loveIcon,
                            colorFilter: ColorFilter.mode(
                              communityModel.isLiked == true
                                  ? Colors.red
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),

                        SizedBox(width: 4),
                        Text(
                          '${communityModel.likeCount}',
                          style: AppStyles.h6(),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.commentIcon,
                          colorFilter: ColorFilter.mode(
                            Colors.grey[600]!,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${communityModel.commentCount}',
                          style: AppStyles.h6(),
                        ),
                      ],
                    ),
                  ],
                ),

                CustomGradientButton(
                  width: 130,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.garageOfferScreen,
                      arguments: communityModel.id,
                    );
                  },
                  text: 'Sent Offer(${communityModel.offerSend})',
                  textStyle: AppStyles.h5(color: Colors.white),
                ),
              ],
            ),
          ),

          if (communityModel.postType == 'helpost') ...[
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap:
                        () =>
                            _communityCtrl.toggleSolvedPost(communityModel.id!),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            communityModel.isSolved
                                ? Color(0xFFEAFBF0)
                                : Color(0xFFFFF2ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            communityModel.isSolved
                                ? Icons.check_circle_rounded
                                : Icons.build_circle_outlined,
                            size: 16,
                            color:
                                communityModel.isSolved
                                    ? Color(0xFF1D9C50)
                                    : Color(0xFFE35C35),
                          ),
                          SizedBox(width: 6),
                          Text(
                            communityModel.isSolved
                                ? 'Marked Solved'
                                : 'Mark as Solved',
                            style: AppStyles.h6(
                              fontFamily: 'InterSemiBold',
                              color:
                                  communityModel.isSolved
                                      ? Color(0xFF1D9C50)
                                      : Color(0xFFE35C35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap:
                      () => _communityCtrl.toggleSavePost(communityModel.id!),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F4F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      communityModel.isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color:
                          communityModel.isSaved
                              ? Color(0xFFFF3B00)
                              : Color(0xFF667085),
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    final String deepLink =
                        'https://torqon.app/community/${communityModel.id ?? ''}';
                    final String desc =
                        (communityModel.postDescription ?? '').trim();
                    final String text =
                        desc.isEmpty
                            ? 'Check this auto post on Torqon\n\n$deepLink'
                            : '$desc\n\n$deepLink';
                    await Clipboard.setData(ClipboardData(text: deepLink));
                    Share.share(text);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F4F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.ios_share_rounded,
                      color: Color(0xFF667085),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
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

  String _formatDate(DateTime date) {
    const months = <String>[
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
    final int monthIndex = date.month.clamp(1, 12) - 1;
    return '${date.day} ${months[monthIndex]}';
  }
}

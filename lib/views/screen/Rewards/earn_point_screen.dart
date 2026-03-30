import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/wallet_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

import '../../Widget/custom_card.dart';
import '../../base/custom_button.dart';

class EarnPointScreen extends StatefulWidget {
  const EarnPointScreen({super.key});

  @override
  State<EarnPointScreen> createState() => _EarnPointScreenState();
}

class _EarnPointScreenState extends State<EarnPointScreen> {
  final WalletController walletCtrl = Get.put(WalletController());
  final List<Map<String, String>> _recentRows = const [
    {
      'title': 'Oil Change',
      'meta': 'Jays smart garage · Dec 20',
      'points': '+187',
    },
    {
      'title': 'Tire Rotation',
      'meta': 'Velocity auto hub · Dec 11',
      'points': '+96',
    },
    {
      'title': 'Brake Check',
      'meta': 'Northline garage · Dec 05',
      'points': '+124',
    },
  ];

  @override
  void initState() {
    super.initState();
    walletCtrl.getMoreEarn();
    walletCtrl.getReferralCode();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rafferCard(context),
          const SizedBox(height: 14),
          Text(
            'More Ways to Earn',
            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
          ),
          _buildEarnCard(),
          const SizedBox(height: 14),
          recentActivity(),
        ],
      ),
    );
  }

  rafferCard(BuildContext context) {
    return Obx(
      () => CustomCard(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: AppColors.brandGradient,
                          ),
                        ),
                        child: const Icon(
                          Icons.group_add_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Invite Friends',
                        style: AppStyles.h3(fontFamily: 'InterSemiBold'),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: AppColors.brandPrimary.withValues(alpha: 0.18),
                      border: Border.all(
                        color: AppColors.brandPrimary.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Text(
                      '+${walletCtrl.referralPoints.value} PTS',
                      style: AppStyles.h6(
                        color: AppColors.brandHighlight,
                        fontFamily: 'InterSemiBold',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'For each successful referral',
                style: AppStyles.h5(
                  color: Get.theme.textTheme.bodyMedium!.color,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: context.screenWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderColor.withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color:
                      Get.isDarkMode
                          ? const Color(0x3D202838)
                          : const Color(0x66FFFFFF),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your referral code',
                      style: AppStyles.h6(color: AppColors.grayColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      walletCtrl.referralCode.value.isEmpty
                          ? 'TORQON-XXXX'
                          : walletCtrl.referralCode.value,
                      style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.borderColor.withValues(
                              alpha: 0.85,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final code =
                              walletCtrl.referralCode.value.isEmpty
                                  ? 'TORQON-XXXX'
                                  : walletCtrl.referralCode.value;
                          await Clipboard.setData(ClipboardData(text: code));
                          Get.snackbar(
                            'Copied',
                            'Referral code copied',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Text(
                          'Copy Code',
                          style: AppStyles.h6(fontFamily: 'InterSemiBold'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      height: 38,
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Share.share(
                          'Join Torqon and get ${walletCtrl.referralPoints.value} points. '
                          'Use my referral code: ${walletCtrl.referralCode.value}',
                        );
                      },
                      text: 'Share Invite',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarnCard() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: walletCtrl.moreEarnList.length,
        itemBuilder: (context, index) {
          final earn = walletCtrl.moreEarnList[index];
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: CustomCard(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFDBEAFE),
                  backgroundImage:
                      earn.image.isNotEmpty ? NetworkImage(earn.image) : null,
                  child:
                      earn.image.isEmpty
                          ? SvgPicture.asset(
                            AppIcons.communityIcon,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2563EB),
                              BlendMode.srcIn,
                            ),
                          )
                          : null,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        earn.typeName,
                        style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: AppColors.brandPrimary.withValues(alpha: 0.15),
                      ),
                      child: Text(
                        '+${earn.pointsValue} pts',
                        style: AppStyles.customSize(
                          size: 11,
                          color: AppColors.brandHighlight,
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    earn.description,
                    style: AppStyles.h6(color: Get.textTheme.bodyMedium!.color),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.serviceScreen),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: AppColors.borderColor.withValues(alpha: 0.85),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    'Book',
                    style: AppStyles.h6(fontFamily: 'InterSemiBold'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  recentActivity() {
    return CustomCard(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppStyles.h4(fontFamily: 'InterSemiBold'),
          ),
          const SizedBox(height: 6),
          ..._recentRows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        index == _recentRows.length - 1
                            ? Colors.transparent
                            : AppColors.borderColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['title']!,
                          style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          row['meta']!,
                          style: AppStyles.h6(
                            color: Get.textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${row['points']} pts',
                    style: AppStyles.h5(
                      color: const Color(0xFF00C978),
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

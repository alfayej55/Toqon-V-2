import 'package:car_care/controllers/wallet_controller.dart';
import 'package:car_care/models/redeem_model.dart';
import 'package:car_care/utils/custom_textbutton.dart';
import 'package:car_care/views/Widget/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  final WalletController walletCtrl = Get.put(WalletController());
  final List<Map<String, String>> _recentRows = const [
    {
      'title': 'Oil Change',
      'meta': 'Jays smart garage · Dec 20',
      'points': '+187',
    },
    {
      'title': 'Battery Check',
      'meta': 'Peak motors · Dec 14',
      'points': '+102',
    },
    {
      'title': 'A/C Service',
      'meta': 'Cityline auto · Dec 08',
      'points': '+143',
    },
  ];

  @override
  void initState() {
    super.initState();
    walletCtrl.getRedeem();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Rewards to Redeem",
            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
          ),

          Obx(
            () => ListView.builder(
              itemCount: walletCtrl.redeemList.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                final redeem = walletCtrl.redeemList[index];
                return avabilableCard(redeem);
              },
            ),
          ),

          SizedBox(height: 10),
          recentActivity(),
        ],
      ),
    );
  }

  avabilableCard(RedeemModel redeem) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  redeem.category?.categoryName ?? 'Service',
                  style: AppStyles.h5(fontFamily: 'InterMedium'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: Text(
                  redeem.category?.categoryType ?? 'Service',
                  style: AppStyles.h6(
                    fontFamily: 'InterSemiBold',
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            redeem.description,
            style: AppStyles.h6(
              color:
                  Get.theme.textTheme.bodyMedium!.color ??
                  AppColors.whiteColor.withValues(alpha: 0.9),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${redeem.userCompletedVisits}/${redeem.requiredVisits} visits required",
                style: AppStyles.h6(
                  fontFamily: 'InterSemiBold',
                  color:
                      Get.theme.textTheme.bodyMedium!.color ??
                      AppColors.whiteColor.withValues(alpha: 0.9),
                ),
              ),
              Text(
                "${redeem.requiredPoints} pts",
                style: AppStyles.h6(
                  fontFamily: 'InterSemiBold',
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: (redeem.pointsPerVisit / 100).clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: AppColors.greyColor,
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          SizedBox(height: 10),
          CustomTextButton(
            height: 35,
            onTap: () {
              Get.snackbar(
                'Reward Progress',
                '${redeem.pointsPerVisit}% completed. Keep visiting to unlock this reward.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            text: '${redeem.pointsPerVisit}% Completed',
          ),
        ],
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

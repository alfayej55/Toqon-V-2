import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Widget/custom_card.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  static const List<Map<String, String>> _recentRows = [
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Challenges',
            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
          ),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return _availableCard(index);
            },
          ),
          const SizedBox(height: 10),
          _recentActivity(),
        ],
      ),
    );
  }

  Widget _availableCard(int index) {
    final List<String> goals = ['Oil Change', 'Brake Check', 'A/C Service'];
    final String title =
        index == 0
            ? 'Free Oil Change'
            : index == 1
            ? 'Premium Tire Rotation'
            : 'A/C Refresh Bonus';
    final String percent =
        index == 0
            ? '67%'
            : index == 1
            ? '45%'
            : '82%';
    final double progress =
        index == 0
            ? 0.67
            : index == 1
            ? 0.45
            : 0.82;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppStyles.h5(fontFamily: 'InterSemiBold')),
              Text(
                percent,
                style: AppStyles.h6(
                  fontFamily: 'InterSemiBold',
                  color: AppColors.brandHighlight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Complete 3 specific services this season',
                  style: AppStyles.h6(fontFamily: 'InterSemiBold'),
                ),
              ),
              Text(
                index == 2 ? '7 days left' : '15 days left',
                style: AppStyles.customSize(
                  fontFamily: 'InterSemiBold',
                  color: Get.theme.textTheme.bodyMedium!.color,
                  size: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.greyColor,
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(5),
          ),
          for (final goal in goals)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.rightboldIcon),
                  const SizedBox(width: 6),
                  Text(
                    goal,
                    style: AppStyles.customSize(
                      fontFamily: 'InterSemiBold',
                      size: 10,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    return CustomCard(
      margin: EdgeInsets.zero,
      child: Column(
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

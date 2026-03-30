import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/wallet_controller.dart';
import 'package:car_care/views/screen/Rewards/redeem.dart';
import 'package:flutter/material.dart';
import 'challenges_screen.dart';
import 'earn_point_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  static const int _dummyRewardPoints = 2450;
  int currentIndex = 0;
  final WalletController walletCtrl = Get.put(WalletController());
  late final PageController _pageController;

  final List<(String, IconData)> statusList = [
    ('Earn', Icons.auto_awesome_rounded),
    ('Redeem', Icons.local_activity_outlined),
    ('Challenges', Icons.flag_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    walletCtrl.getMyEarnPoint();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF090E17) : Get.theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomMenu(3),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: _bgGlow(const Color(0x22F08E2F), 260),
          ),
          Positioned(
            bottom: 80,
            left: -110,
            child: _bgGlow(const Color(0x226A1838), 280),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Column(
              children: [
                _pointsHero(),
                const SizedBox(height: 12),
                _tabRail(),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    children: const [
                      EarnPointScreen(),
                      RedeemScreen(),
                      ChallengesScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsHero() {
    return Obx(
      () {
        final int livePoints = walletCtrl.myPoints.value;
        final int displayPoints =
            livePoints > 0 ? livePoints : _dummyRewardPoints;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: AppColors.brandGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandPrimary.withValues(alpha: 0.26),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TORQON REWARDS',
                style: AppStyles.h6(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontFamily: 'InterSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$displayPoints PTS',
                style: AppStyles.customSize(
                  size: 38,
                  color: Colors.white,
                  fontFamily: 'InterBold',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                livePoints > 0
                    ? 'Ready to redeem for services and perks'
                    : 'Sample points loaded for preview mode',
                style: AppStyles.h6(color: Colors.white.withValues(alpha: 0.92)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _heroChip('Trusted garages'),
                  const SizedBox(width: 8),
                  _heroChip('Referral rewards'),
                  const SizedBox(width: 8),
                  _heroChip('Live challenges'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
      ),
      child: Text(
        text,
        style: AppStyles.customSize(
          size: 10,
          color: Colors.white,
          fontFamily: 'InterSemiBold',
        ),
      ),
    );
  }

  Widget _tabRail() {
    final bool isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            isDark
                ? const Color(0xFF121928).withValues(alpha: 0.88)
                : Colors.white.withValues(alpha: 0.88),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: List.generate(statusList.length, (index) {
          final selected = currentIndex == index;
          final tab = statusList[index];
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() => currentIndex = index);
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient:
                      selected
                          ? const LinearGradient(
                            colors: AppColors.brandGradient,
                          )
                          : null,
                  color: selected ? null : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.$2,
                      size: 16,
                      color:
                          selected
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFFA7AEBD)
                                  : const Color(0xFF6A7284)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.$1,
                      style: AppStyles.h6(
                        fontFamily: 'InterSemiBold',
                        color:
                            selected
                                ? Colors.white
                                : (isDark
                                    ? const Color(0xFFA7AEBD)
                                    : const Color(0xFF6A7284)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _bgGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

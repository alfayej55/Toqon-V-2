import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileCtrl =
        Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());
    final profile = profileCtrl.effectiveProfile;
    final bool isDark = Get.isDarkMode;
    final int points = profile.myWallet;
    final List<_RankTier> tiers = _rankTiers;
    final int currentIndex = _currentTierIndex(points, tiers);
    final _RankTier currentTier = tiers[currentIndex];
    final bool hasNextTier = currentIndex < tiers.length - 1;
    final int nextMinPoints =
        hasNextTier ? tiers[currentIndex + 1].minPoints : currentTier.minPoints;
    final int pointsToNext =
        hasNextTier ? (nextMinPoints - points).clamp(0, 1 << 31) : 0;
    final double progress = _progressToNext(points, currentIndex, tiers);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF090F1A) : const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          _bgLayer(isDark),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    child: _header(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _hero(
                      points: points,
                      currentTier: currentTier,
                      progress: progress,
                      hasNextTier: hasNextTier,
                      pointsToNext: pointsToNext,
                      nextTierName:
                          hasNextTier ? tiers[currentIndex + 1].name : currentTier.name,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _sectionTitle('Rank Ladder'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 78,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final tier = tiers[index];
                        final bool unlocked = points >= tier.minPoints;
                        final bool active = index == currentIndex;
                        return _rankRailItem(
                          tier: tier,
                          unlocked: unlocked,
                          active: active,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: tiers.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _sectionTitle('Unlocked Benefits'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _BenefitChip(label: 'FREE CAR WASH'),
                        _BenefitChip(label: 'FREE OIL CHANGE'),
                        _BenefitChip(label: 'INTERIOR DETAILING'),
                        _BenefitChip(label: 'CERAMIC COATING'),
                        _BenefitChip(label: 'PRIORITY SUPPORT'),
                        _BenefitChip(label: 'EARLY OFFERS'),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _sectionTitle('How To Level Up'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    child: Column(
                      children: [
                        _infoTile(
                          icon: Icons.handyman_outlined,
                          title: 'Complete Services',
                          subtitle:
                              'Book and complete garage services to increase points.',
                        ),
                        _infoTile(
                          icon: Icons.groups_outlined,
                          title: 'Engage In Community',
                          subtitle:
                              'Post, comment, and share to boost your rank score.',
                        ),
                        _infoTile(
                          icon: Icons.person_add_alt_1_rounded,
                          title: 'Refer Friends',
                          subtitle:
                              'Invite friends and earn bonus points after sign-up.',
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

  Widget _bgLayer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            isDark
                ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0B111D), Color(0xFF070C15)],
                )
                : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8FAFF), Color(0xFFF2F5FC)],
                ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -80,
            child: _orb(
              280,
              isDark
                  ? const [Color(0x2AF08E2F), Color(0x006A1838)]
                  : const [Color(0x1FF08E2F), Color(0x00F08E2F)],
            ),
          ),
          Positioned(
            top: 220,
            left: -100,
            child: _orb(
              260,
              isDark
                  ? const [Color(0x1B8C2048), Color(0x008C2048)]
                  : const [Color(0x148C2048), Color(0x008C2048)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: NavigationHelper.backOrHome,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  Get.isDarkMode
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.9),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Get.theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('My Badges', style: AppStyles.h2(fontFamily: 'InterSemiBold')),
      ],
    );
  }

  Widget _hero({
    required int points,
    required _RankTier currentTier,
    required double progress,
    required bool hasNextTier,
    required int pointsToNext,
    required String nextTierName,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: AppColors.brandGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPrimary.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                currentTier.name,
                style: AppStyles.h4(color: Colors.white, fontFamily: 'InterBold'),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withValues(alpha: 0.22),
                ),
                child: Text(
                  'CURRENT',
                  style: AppStyles.customSize(
                    size: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$points PTS',
            style: AppStyles.customSize(
              size: 34,
              color: Colors.white,
              fontFamily: 'InterBold',
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.28),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasNextTier
                ? '$pointsToNext points to unlock $nextTierName'
                : 'Top rank unlocked. Keep earning for bonus rewards.',
            style: AppStyles.h6(color: Colors.white.withValues(alpha: 0.92)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppStyles.h3(fontFamily: 'InterSemiBold'));
  }

  Widget _rankRailItem({
    required _RankTier tier,
    required bool unlocked,
    required bool active,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient:
            active
                ? const LinearGradient(colors: AppColors.brandGradient)
                : null,
        color:
            active
                ? null
                : (Get.isDarkMode
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.92)),
        border: Border.all(
          color:
              active
                  ? Colors.white.withValues(alpha: 0.35)
                  : AppColors.borderColor.withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
            size: 16,
            color:
                active
                    ? Colors.white
                    : (unlocked ? AppColors.brandPrimary : AppColors.subTextColor),
          ),
          const SizedBox(width: 7),
          Text(
            tier.name,
            style: AppStyles.customSize(
              size: 12,
              color: active ? Colors.white : Get.theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${tier.minPoints}+',
            style: AppStyles.customSize(
              size: 11,
              color:
                  active
                      ? Colors.white.withValues(alpha: 0.92)
                      : AppColors.subTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.92),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.brandPrimary.withValues(alpha: 0.14),
            ),
            child: Icon(icon, size: 15, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.h5(fontFamily: 'InterSemiBold')),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: AppStyles.h6(color: AppColors.subTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final String label;
  const _BenefitChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFF5F7FC),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: AppStyles.customSize(
          size: 11,
          fontFamily: 'InterSemiBold',
          letterSpacing: 0.6,
          color: Get.theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}

class _RankTier {
  final String name;
  final int minPoints;

  const _RankTier({required this.name, required this.minPoints});
}

const List<_RankTier> _rankTiers = [
  _RankTier(name: 'ROOKIE', minPoints: 0),
  _RankTier(name: 'DRIVER', minPoints: 500),
  _RankTier(name: 'PRO', minPoints: 1500),
  _RankTier(name: 'ELITE', minPoints: 3500),
  _RankTier(name: 'LEGEND', minPoints: 6000),
];

int _currentTierIndex(int points, List<_RankTier> tiers) {
  for (int i = tiers.length - 1; i >= 0; i--) {
    if (points >= tiers[i].minPoints) {
      return i;
    }
  }
  return 0;
}

double _progressToNext(int points, int currentIndex, List<_RankTier> tiers) {
  if (currentIndex >= tiers.length - 1) return 1;
  final int start = tiers[currentIndex].minPoints;
  final int end = tiers[currentIndex + 1].minPoints;
  if (end <= start) return 1;
  final double raw = (points - start) / (end - start);
  return raw.clamp(0.0, 1.0);
}

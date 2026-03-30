import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/my_activity_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyActivityScreen extends StatefulWidget {
  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  final MyActivityController _ctrl = Get.put(MyActivityController());
  late final PageController _pageController;
  double _rangeDragDelta = 0;

  static const List<String> _ranges = ['week', 'month', 'year'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _rangeIndex(_ctrl.selectedRange.value),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _rangeIndex(String range) {
    switch (range) {
      case 'week':
        return 0;
      case 'year':
        return 2;
      case 'month':
      default:
        return 1;
    }
  }

  void _animateToRangeIndex(int index) {
    final int safeIndex = index.clamp(0, _ranges.length - 1);
    final String nextRange = _ranges[safeIndex];
    if (_ctrl.selectedRange.value != nextRange) {
      _ctrl.setRange(nextRange);
    }
    _pageController.animateToPage(
      safeIndex,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _slideRangeBy(int delta) {
    final current = _rangeIndex(_ctrl.selectedRange.value);
    _animateToRangeIndex(current + delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090F1A),
      body: Stack(
        children: [
          _pageBackground(),
          SafeArea(
            child: Obx(() {
              final data = _ctrl.activity.value;
              return Column(
                children: [
                  _header(context),
                  _rangeTabs(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        final range = _ranges[index];
                        if (_ctrl.selectedRange.value != range) {
                          _ctrl.setRange(range);
                        }
                      },
                      itemCount: _ranges.length,
                      itemBuilder: (_, __) {
                        if (_ctrl.loading.value) {
                          return const Center(child: CustomPageLoading());
                        }

                        return RefreshIndicator(
                          onRefresh: _ctrl.fetchActivity,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                            children: [
                              _topStatsStrip(data),
                              const SizedBox(height: 8),
                              _pointsSummary(data),
                              const SizedBox(height: 8),
                              _recentServices(data),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _pageBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B111D), Color(0xFF070C15)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -70,
            child: _glowOrb(
              260,
              const [Color(0x338C2048), Color(0x00F08E2F)],
            ),
          ),
          Positioned(
            top: 180,
            right: -90,
            child: _glowOrb(
              280,
              const [Color(0x26F08E2F), Color(0x00923C32)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowOrb(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  NavigationHelper.backOrHome();
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white.withValues(alpha: 0.88),
                    border: Border.all(
                      color: AppColors.borderColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: Get.theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 34),
            ],
          ),
          Text(
            'My Activity',
            style: AppStyles.h3(fontFamily: 'InterSemiBold', color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _rangeTabs() {
    final tabs = const [
      ('week', 'This Week'),
      ('month', 'This Month'),
      ('year', 'This Year'),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) => _rangeDragDelta = 0,
      onHorizontalDragUpdate: (details) {
        _rangeDragDelta += details.delta.dx;
        const threshold = 26.0;
        if (_rangeDragDelta <= -threshold) {
          _slideRangeBy(1);
          _rangeDragDelta = 0;
        } else if (_rangeDragDelta >= threshold) {
          _slideRangeBy(-1);
          _rangeDragDelta = 0;
        }
      },
      onHorizontalDragEnd: (details) {
        _rangeDragDelta = 0;
        final velocity = details.primaryVelocity ?? 0;
        if (velocity <= -180) {
          _slideRangeBy(1);
        } else if (velocity >= 180) {
          _slideRangeBy(-1);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(2.5),
        decoration: _panelDecoration(radius: 12),
        child: Row(
          children:
              tabs.map((t) {
                return Expanded(
                  child: Obx(() {
                    final selected = _ctrl.selectedRange.value == t.$1;
                    return InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () => _animateToRangeIndex(_rangeIndex(t.$1)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient:
                              selected
                                  ? const LinearGradient(
                                    colors: AppColors.brandGradient,
                                  )
                                  : null,
                          color:
                              selected
                                  ? null
                                  : Colors.white.withValues(alpha: 0.02),
                        ),
                        child: Center(
                          child: Text(
                            t.$2,
                            style: AppStyles.customSize(
                              size: 12.5,
                              fontFamily: 'InterSemiBold',
                              color:
                                  selected
                                      ? Colors.white
                                      : (Get.isDarkMode
                                          ? const Color(0xFFCDD4E2)
                                          : const Color(0xFF4A5568)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _topStatsStrip(MyActivityData data) {
    final stats = [
      (
        icon: Icons.directions_car_filled_rounded,
        color: const Color(0xFF3A7BFF),
        value: '${data.carsRegistered}'
      ),
      (
        icon: Icons.event_note_rounded,
        color: const Color(0xFF41D89A),
        value: '${data.servicesLogged}'
      ),
      (
        icon: Icons.workspace_premium_rounded,
        color: const Color(0xFFE2A900),
        value: NumberFormat.decimalPattern().format(data.totalPoints)
      ),
      (
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFF9B5CF3),
        value: '\$${data.moneySaved.toStringAsFixed(1)}'
      ),
    ];

    return Container(
      decoration: _panelDecoration(radius: 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children:
              stats.map((item) {
                return _compactStatChip(
                  icon: item.icon,
                  iconColor: item.color,
                  value: item.value,
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _compactStatChip({
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, color: iconColor, size: 13),
          ),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 42),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customSize(
                size: 18,
                fontFamily: 'InterSemiBold',
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsSummary(MyActivityData data) {
    final int earned = data.pointsEarned;
    final int redeemed = data.pointsRedeemed;
    final int balance = data.currentBalance;
    final int denominator = earned <= 0 ? 1 : earned;
    final double usage = (redeemed / denominator).clamp(0.0, 1.0);
    final double hold = (balance / denominator).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _panelDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B1A4A), Color(0xFFF08E2F)],
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points Flow',
                    style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                  ),
                  Text(
                    'How your points move this period',
                    style: AppStyles.customSize(
                      size: 11.5,
                      color: AppColors.subTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _pointsKpiChip(
                  label: 'Earned',
                  value: '+${NumberFormat.decimalPattern().format(earned)}',
                  color: const Color(0xFF39D98A),
                  icon: Icons.north_east_rounded,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _pointsKpiChip(
                  label: 'Used',
                  value: '-${NumberFormat.decimalPattern().format(redeemed)}',
                  color: const Color(0xFFFF5D6E),
                  icon: Icons.south_east_rounded,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _pointsKpiChip(
                  label: 'Balance',
                  value: NumberFormat.decimalPattern().format(balance),
                  color: const Color(0xFF2DDA9A),
                  valueGradient: const [
                    Color(0xFF1FAF79),
                    Color(0xFF2DDA9A),
                    Color(0xFF7CF5CE),
                  ],
                  icon: Icons.bolt_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _softProgressRow(
            title: 'Usage Rate',
            percent: usage,
            color: const Color(0xFFF08E2F),
            gradientColors: const [Color(0xFF8B1A4A), Color(0xFFF08E2F)],
          ),
          const SizedBox(height: 6),
          _softProgressRow(
            title: 'Balance Retained',
            percent: hold,
            color: const Color(0xFF4FC9A6),
            gradientColors: const [
              Color(0xFF1FAF79),
              Color(0xFF2DDA9A),
              Color(0xFF7CF5CE),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pointsKpiChip({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    List<Color>? valueGradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customSize(
                    size: 11,
                    color: AppColors.subTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          if (valueGradient == null)
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
                style: AppStyles.customSize(
                  size: 14.5,
                  color: color,
                  fontFamily: 'InterSemiBold',
                  fontWeight: FontWeight.w700,
              ),
            )
          else
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(colors: valueGradient).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              blendMode: BlendMode.srcIn,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customSize(
                  size: 14.5,
                  color: Colors.white,
                  fontFamily: 'InterSemiBold',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _softProgressRow({
    required String title,
    required double percent,
    required Color color,
    List<Color>? gradientColors,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Text(
            title,
            style: AppStyles.customSize(
              size: 11.5,
              color: AppColors.subTextColor.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fillWidth = constraints.maxWidth * percent;
              return Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: fillWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: LinearGradient(
                        colors: gradientColors ?? [color, color],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${(percent * 100).round()}%',
            textAlign: TextAlign.right,
            style: AppStyles.customSize(
              size: 11.5,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentServices(MyActivityData data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: _panelDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_car_rounded,
                color: Color(0xFF3A7BFF),
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Services',
                style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (data.recentServices.isEmpty)
            Text(
              'No recent services in this period.',
              style: AppStyles.h6(color: AppColors.subTextColor),
            )
          else
            ...data.recentServices.map(
              (s) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Get.isDarkMode
                          ? Colors.white.withValues(alpha: 0.04)
                          : const Color(0xFFF7F9FD),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.serviceName,
                            style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                          ),
                          Text(
                            s.vehicleName,
                            style: AppStyles.customSize(
                              size: 12,
                              color: AppColors.subTextColor,
                            ),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(s.date),
                            style: AppStyles.customSize(
                              size: 12,
                              color: AppColors.subTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${s.points} pts',
                      style: AppStyles.h5(
                        color: const Color(0xFF49D19D),
                        fontFamily: 'InterSemiBold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration({double radius = 14}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            Get.isDarkMode
                ? [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.03),
                ]
                : [
                  Colors.white.withValues(alpha: 0.98),
                  Colors.white.withValues(alpha: 0.9),
                ],
      ),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      boxShadow:
          Get.isDarkMode
              ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
              : null,
    );
  }
}

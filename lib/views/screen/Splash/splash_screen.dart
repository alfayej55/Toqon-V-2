import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/profile_controller.dart';
import 'package:car_care/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    // Check auth and navigate
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await PrefsHelper.getString(AppConstants.bearerToken);

    if (token.isNotEmpty) {
      // Connect Socket on auto-login
      await SocketService.instance.initialize();
      await SocketService.instance.connect();

      // Fetch profile data before navigating
      final profileController = Get.put(ProfileController(), permanent: true);
      await profileController.profileInfoGet();

      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Get.offAllNamed(AppRoutes.signInScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _progressAnimation.value / 100.0;
          final rotation = _controller.value * 6.28;
          final logoScale = 0.76 + (_controller.value * 0.24);
          final logoOpacity = (_controller.value * 1.35).clamp(0.0, 1.0);

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.brandGradient,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -140,
                  right: -80,
                  child: _orb(260, Colors.white.withValues(alpha: 0.10)),
                ),
                Positioned(
                  bottom: -120,
                  left: -70,
                  child: _orb(240, Colors.black.withValues(alpha: 0.12)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: rotation * 0.25,
                          child: Container(
                            width: 142,
                            height: 142,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.24),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -122),
                          child: Opacity(
                            opacity: logoOpacity,
                            child: Transform.scale(
                              scale: logoScale,
                              child: Container(
                                width: 104,
                                height: 104,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.28),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.torqonLogoIcon,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Torqon',
                          style: AppStyles.h1(
                            color: Colors.white,
                            fontFamily: 'InterBold',
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Torqon - Built for Trust. Designed for Control.',
                          textAlign: TextAlign.center,
                          style: AppStyles.h6(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontFamily: 'InterMedium',
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: 320,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withValues(alpha: 0.14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.24),
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 9,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.22,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Loading experience',
                                    style: AppStyles.h6(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_progressAnimation.value.toStringAsFixed(0)}%',
                                    style: AppStyles.h6(
                                      fontFamily: 'InterSemiBold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'dart:ui';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.h4(
          fontFamily: 'InterBold',
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.brandDeep.withValues(alpha: 0.86),
                  AppColors.brandPrimary.withValues(alpha: 0.82),
                  AppColors.brandWarm.withValues(alpha: 0.78),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    );
  }
}

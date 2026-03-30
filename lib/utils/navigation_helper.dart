import 'package:car_care/all_export.dart';

class NavigationHelper {
  const NavigationHelper._();

  static void backOrHome({String? fallbackRoute}) {
    final String targetRoute = fallbackRoute ?? AppRoutes.homeScreen;
    final bool canPop = Get.key.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back();
      return;
    }
    Get.offAllNamed(targetRoute);
  }
}

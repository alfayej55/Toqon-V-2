
import 'package:car_care/all_export.dart';
class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        await PrefsHelper.remove(AppConstants.isLogged);
        await PrefsHelper.remove(AppConstants.bearerToken);
       // Get.offAllNamed(AppRoutes.logInScreen);
       // Get.offAllNamed(AppRoutes.logInScreen);
      } else {
        // showCustomSnackBar(response.statusText!, getXSnackBar: getXSnackBar);
      }
    }
  }
}

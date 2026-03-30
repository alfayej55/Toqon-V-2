import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:car_care/themes/dark_theme.dart';
import 'package:car_care/themes/light_theme.dart';
import 'package:car_care/utils/app_constants.dart';
import 'package:car_care/utils/message.dart';
import 'controllers/localization_controller.dart';
import 'controllers/theme_controller.dart';
import 'helpers/di.dart' as di;
import 'helpers/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di.init();

  // Socket will be initialized after login (not here - no token yet)
  if (!kIsWeb) {
    Stripe.publishableKey =
        'pk_test_51JwGrdHqqc8fJ7jxdlB0j9Nsc4pWPhb6OytRJYxB3u0UfV4boyBqdLxWuMKNTFgMgJjy4afcKcI4ZbCmpRSr55jj00RI4dzZCj';
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark() : light(),
              //theme: light(),
              popGesture: true,
              defaultTransition: Transition.cupertino,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale:
                  AppConstants.languages.isNotEmpty
                      ? Locale(
                        AppConstants.languages[0].languageCode,
                        AppConstants.languages[0].countryCode,
                      )
                      : const Locale('en', 'US'),
              transitionDuration: const Duration(milliseconds: 420),
              getPages: AppRoutes.page,
              //initialBinding: AssessmentBinding(),
              initialRoute: AppRoutes.splashScreen,
            );
          },
        );
      },
    );
  }
}

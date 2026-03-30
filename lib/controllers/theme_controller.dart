import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  RxString currentTheme = 'Light'.obs;

  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  @override
  void onInit() {
    super.onInit();
    _loadCurrentTheme();
  }

  List<String> themes = ['Light', 'Dark'];

  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.theme, _darkTheme);
    currentTheme.value = _darkTheme ? 'Dark' : 'Light';
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.theme) ?? true;
    currentTheme.value = _darkTheme ? 'Dark' : 'Light';

    update();
  }
}


import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/home_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/language_model.dart';
import '../utils/app_constants.dart';


Future<Map<String, Map<String, String>>>  init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeController());





  //Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonMap = {};
    mappedJson.forEach((key, value) {
      jsonMap[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonMap;
  }
  return languages;
}
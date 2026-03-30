import '../models/language_model.dart';

class AppConstants{

  static String appName="car_care";

  // Socket URL
  static const String socketUrl = "https://arif-3.sobhoy.com";  // Change to your socket URL

  static const String isLogged = 'isLogged';
  // share preference Key
  static String theme ="theme";

  static const String languageCode = 'language_code';
  static const String countryCode = 'country_code';

  static const String bearerToken = '';
  static const String userSubscription = 'userSubscription';
   static const String userID = 'userID';


  static RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static RegExp passwordValidator = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
  );
  static List<LanguageModel> languages = [
    LanguageModel( languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel( languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel( languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];

}
import 'package:car_care/views/screen/Booking/booking_screen.dart';
import 'package:car_care/views/screen/CareGraph/add_new_vehicle.dart';
import 'package:car_care/views/screen/CareGraph/care_graph_screen.dart';
import 'package:car_care/views/screen/Chat/chat_screen.dart';
import 'package:car_care/views/screen/Community/create_post_screen.dart';
import 'package:car_care/views/screen/Community/garage_offer_screen.dart';
import 'package:car_care/views/screen/Community/my_community_post.dart';
import 'package:car_care/views/screen/Location/location_screen.dart';
import 'package:car_care/views/screen/Chat/message_inbox.dart';
import 'package:car_care/views/screen/MyBooking/booking_details_screen.dart';
import 'package:car_care/views/screen/MyBooking/my_booking_screen.dart';
import 'package:car_care/views/screen/Offers/offers_screen.dart';
import 'package:car_care/views/screen/Profile/about_app_screen.dart';
import 'package:car_care/views/screen/Profile/account_info_screen.dart';
import 'package:car_care/views/screen/Profile/edit_profile.dart';
import 'package:car_care/views/screen/Profile/feedback_screen.dart';
import 'package:car_care/views/screen/Profile/notification_screen.dart';
import 'package:car_care/views/screen/Profile/privacy_screen.dart';
import 'package:car_care/views/screen/Profile/term_and_condition_screen.dart';
import 'package:car_care/views/screen/Profile/my_activity_screen.dart';
import 'package:car_care/views/screen/Rewards/rewards_screen.dart';
import 'package:car_care/views/screen/Service/garage_details_screen.dart';
import 'package:car_care/views/screen/Service/service_booking_screen.dart';
import 'package:car_care/views/screen/Wallet/add_saving_plan.dart';
import 'package:car_care/views/screen/Wallet/carsaving_screen.dart';
import 'package:get/get.dart';
import 'package:car_care/views/screen/Home/home_screen.dart';
import 'package:car_care/views/screen/Profile/profile_screen.dart';
import 'package:car_care/views/screen/Wallet/wallet_screen.dart';
import '../views/Setting/call_support.dart';
import '../views/screen/Support/ticket_details_screen.dart';
import '../views/screen/Auth/forgot_email.screen.dart';
import '../views/screen/Auth/forgot_password_screen.dart';
import '../views/screen/Auth/otp_screen.dart';
import '../views/screen/Auth/signin.dart';
import '../views/screen/Auth/sing_up_screen.dart';
import '../views/screen/CareGraph/my_registered_vechicles_details.dart';
import '../views/screen/Community/community_screen.dart';
import '../views/screen/Home/ai_detecting_screen.dart';
import '../views/screen/Profile/badge_screen.dart';
import '../views/screen/Profile/security_screen.dart';
import '../views/screen/Service/booking_confirm_screen.dart';
import '../views/screen/Service/service_by_garage_screen.dart';
import '../views/screen/Service/service_category_screnn.dart';
import '../views/screen/Splash/splash_screen.dart';

class AppRoutes {
  // Auth Routes
  static String signInScreen = "/signIn_screen";
  static String signUpScreen = "/signUp_screen";
  static String forgotEmailScreen = "/forgotEmail_screen";
  static String otpScreen = "/otp_screen";
  static String forgotPasswordScreen = "/forgotPassword_screen";

  static String splashScreen = "/splash_screen";
  static String homeScreen = "/home_screen";
  static String profileScreen = "/profile_screen";
  static String walletScreen = "/wallet_screen";
  static String locationsScreen = "/location_screen";
  static String rewardsScreen = "/rewards_screen";
  static String chatScreen = "/chat_screen";
  static String bookingScreen = "/booking_screen";
  static String aboutScreen = "/about_screen";
  static String aiDetection = "/aiDetection_screen";
  static String serviceScreen = "/service_screen";
  static String serviceByGarageScreen = "/serviceByGarage_screen";
  static String garageDetailsScreen = "/garageDetails_screen";
  static String bookingServiceScreen = "/bookingService_screen";
  static String communityScreen = "/community_screen";
  static String createCommunityScreen = "/createCommunity_screen";
  static String careGraphScreen = "/careGraph_screen";
  static String offerScreen = "/offer_screen";
  static String addNewVehicleScreen = "/addNewVehicle_screen";
  static String registerVehicleServiceDetailsScreen =
      "/registerVehicleServiceDetails_screen";
  static String bookingConfirmScreen = "/bookingConfirm_screen";
  static String myCommunityScreen = "/myCommunity_screen";
  static String garageOfferScreen = "/garageOffer_screen";
  static String callSuportScreen = "/callSupport_screen";

  static String profileEditScreen = "/profileEdit_screen";
  static String accountInfoScreen = "/accountInfo_screen";
  static String securityScreen = "/security_screen";
  static String privacyScreen = "/privacy_screen";
  static String termAndConditionScreen = "/termAndConditon_screen";
  static String notificationScreen = "/notification_screen";
  static String badgeScreen = "/badge_screen";
  static String carSavingScreen = "/carSaving_screen";
  static String addSavingPlanScreen = "/adSavingPlan_screen";
  static String myBookingScreen = "/myBooking_screen";
  static String myBookingDetailsScreen = "/myBookingDetails_screen";
  static String messageInboxScreen = "/messageInbox_screen";
  static String feedBackScreen = "/feedBack_screen";
  static String myActivityScreen = "/myActivity_screen";
  static String ticketDetailsScreen = "/ticketDetails_screen";

  static List<GetPage> page = [
    // Auth Pages
    GetPage(
      name: signInScreen,
      page: () => const SignInScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: signUpScreen,
      page: () => const SignUpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: forgotEmailScreen,
      page: () => const ForgotEmailOtpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: otpScreen,
      page: () => OtpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),

    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: walletScreen,
      page: () => WalletScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: profileScreen,
      page: () => const ProfileScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: locationsScreen,
      page: () => LocationScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: rewardsScreen,
      page: () => const RewardsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: aboutScreen,
      page: () => const AboutAppScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: chatScreen,
      page: () => ChatScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: bookingScreen,
      page: () => const BookingScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: aiDetection,
      page: () => const AiDetectingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: serviceScreen,
      page: () => ServiceCategoryScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: serviceByGarageScreen,
      page: () => ServiceByGarageScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: bookingServiceScreen,
      page: () => ServiceBookingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: garageDetailsScreen,
      page: () => GarageDetailScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: communityScreen,
      page: () => CommunityScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: createCommunityScreen,
      page: () => CreatePostScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: careGraphScreen,
      page: () => CareGraphScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: offerScreen,
      page: () => OffersScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: addNewVehicleScreen,
      page: () => AddNewVehicle(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: registerVehicleServiceDetailsScreen,
      page: () => MyRegisteredVechiclesDetails(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: bookingConfirmScreen,
      page: () => BookingConfirmScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: myCommunityScreen,
      page: () => MyCommunityPost(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: garageOfferScreen,
      page: () => const GarageOfferScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: callSuportScreen,
      page: () => CallSupportScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),

    GetPage(
      name: profileEditScreen,
      page: () => EditProfile(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: accountInfoScreen,
      page: () => AccountInfoScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: securityScreen,
      page: () => SecurityScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: notificationScreen,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: privacyScreen,
      page: () => PrivacyScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: termAndConditionScreen,
      page: () => TermAndConditionScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: badgeScreen,
      page: () => BadgeScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: carSavingScreen,
      page: () => CarSavingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: addSavingPlanScreen,
      page: () => AddSavingplanScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: myBookingScreen,
      page: () => MyBookingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: myBookingDetailsScreen,
      page: () => BookingDetailsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: messageInboxScreen,
      page: () => MessageInboxScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: feedBackScreen,
      page: () => FeedbackScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: myActivityScreen,
      page: () => MyActivityScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: ticketDetailsScreen,
      page: () => const TicketDetailsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 100),
    ),
  ];
}

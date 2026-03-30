class ApiConstants {
  static String googleBaseUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";

  // static String mapBoxKey="pk.eyJ1Ijoid2Fsa2llIiwiYSI6ImNscm55M2lhajEzdW0ycXF6ZTRuY2w4OXYifQ.pI4bApY7BJvW8hUqeYEgiw";

  static String mapKey = "AIzaSyDKwihJRZd4TFnA8DiTSOe2q3QsgLRC04k";
  static String estimatedTimeUrl =
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&";

  // static const String baseUrl = "http://10.0.60.206:6089/api/v1";
  // static const String imageBaseUrl = "http://10.0.60.206:6089";

  static const String imageBaseUrl = "https://arif-3.sobhoy.com";
  static const String baseUrl = "https://arif-3.sobhoy.com/api/v1";
  // static const String socketUrl = "https://ws.walkieapp.co.uk";

  /// Upload Image to S3Backed

  static const String uploadImage = '/upload/presigned-url';

  static const String signIn = "/auth/login";
  static const String sigUpEndPoint = "/auth/register";
  static const String otpVerifyEndPoint = "/auth/verify-email";
  static const String forgotEmailEndPoint = "/auth/forgot-password";
  static const String updateEndPoint = "/users/self/update-location";
  static const String resetEndPoint = "/auth/reset-password";

  /// Profile Information

  static const String profileEndPoint = '/users/self/in';
  static const String updateProfileEndPoint = '/users/self/update';
  static const String privacyPolicyEndPoint = '/privacy-policy';
  static const String termAndConditionEndPoint = '/terms-conditions';
  static const String changePasswordEndPoint = '/auth/change-password';
  static const String securityPreferencesEndPoint =
      '/users/self/security-preferences';
  static const String activeSessionsEndPoint = '/auth/sessions';
  static const String myActivityEndPoint = '/users/self/activity';

  /// Offer Section

  static const String offerEndpoint = '/offer/active';

  /// Care Graph End Point

  static const String addVehiclesEndpoint = '/vehicles';
  static const String vehiclesEndpoint = '/vehicles/my-vehicles';
  static const String vehicleDetailsEndpoint =
      '/vehicle-service-history/vehicle';

  static const String aiDamageEndpoint = '/damage-assessment/analyze';

  /// Community

  static const String communityCreateEndPoint = '/community';
  static const String myCommunityEndPoint = '/community/my-posts';
  static const String garageOfferCommunityEndPoint = '/community-offers/post';
  static String likeCommunityEndPoint(String id) => '/community/$id/like';
  static String commentCommunityEndPoint(String id) =>
      '/community/$id/comments';
  static String saveCommunityEndPoint(String id) => '/community/$id/save';
  static String solvedCommunityEndPoint(String id) => '/community/$id/solve';

  /// Service and Category

  static String categoryEndPoint = '/categories/nearby';
  static String serviceEndPoint = '/services/nearby';
  static String garageEndPoint = '/garages';
  static String nearbyGarageEndPoint = '/users/nearby-garages/map';
  static String homeGarageProfileEndPoint = '/users/nearby-garages';

  /// Booking

  static const String bookingEndPoint = '/bookings';
  static String bookingGetEndPoint(String status) => '/bookings?status=$status';
  static String bookingDetailsEndPoint(String id) => '/bookings/$id';

  /// Message End Point

  static const String conversationsEndPoint = '/chat/conversations';
  static String inboxEndPoint(String id) => '/chat/conversations/$id/messages';

  /// Notification

  static const String notificationEndPoint = '/notifications';

  /// Support

  static const String supportTicketsEndPoint = '/support-tickets';
  static const String sendEmailEndPoint = '/contact-support';

  /// Wallet

  static const String walletBalance = '/payment/wallet/balance';
  static const String moreEarnEndPoint = '/earn-point-types';
  static const String earnPointReferrCodeEndPoint =
      '/earn-point-types/referral-code';
  static const String earnMyPointEndPoint = '/earn-point-types/my-points';
  static const String redeemEndPoint = '/redeems';
}

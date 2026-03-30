//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Utils/app_constants.dart';
// import '../helpers/prefs_helpers.dart';
//
//
// FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
// bool isNotificationsEnabled = true;
// class NotificationHelper {
//
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   // static Future<void> getFcmToken() async {
//   //  String? fcmToken = await _firebaseMessaging.getToken();
//   //    if (fcmToken != null) {
//   //      PrefsHelper.setString(AppConstants.fcmToken, fcmToken);
//   //    }
//   //    print('FCM Token: $fcmToken');
//   //  }
//   static Future<void> getFcmToken() async {
//
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     // Ensure the app is requesting notification permissions on iOS
//     NotificationSettings settings = await messaging.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       print('Notification permission denied.');
//       return;
//     }
//
//     // // Ensure the APNS token is available for iOS
//     // String? apnsToken = await messaging.getAPNSToken();
//     // if (apnsToken != null) {
//     //   print('APNS Token: $apnsToken');
//     //   await PrefsHelper.setString(AppConstants.fcmToken, apnsToken);
//     //   return; // Return early if APNS token is retrieved
//     // } else {
//     //   print('APNS token not set yet.');
//     // }
//
//     // Retrieve the FCM token (for Android and when APNS is not available)
//     String? fcmToken = await messaging.getToken();
//     if (fcmToken != null) {
//       print('FCM Token: $fcmToken');
//       await PrefsHelper.setString(AppConstants.fcmToken, fcmToken);
//     } else {
//       print('FCM token not available.');
//     }
//   }
//
//
//   //==================Request for permission and Generate FCM token=================
//   static init() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: isNotificationsEnabled,
//     );
//
//     debugPrint(
//         'User granted permission==================>>>>>>>>>>>>: ${settings.authorizationStatus}');
//
//     String? token = await messaging.getToken();
//
//
//     // await PrefsHelper.setString(AppConstants.fcmToken, fcmToken);
//
//     debugPrint('FCM TOKEN <<<<<<<=====>>>>>>> $token');
//   }
//
//   static saveNotificationPreference(bool isEnabled) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('notifications_enabled', isEnabled);
//   }
//
//   Future<bool> getNotificationPreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('notifications_enabled') ?? true;
//   }
//
//   static toggleNotifications(bool isEnabled) {
//     print('Notification Page kdasksda>>>>${isEnabled}');
//     if (isEnabled) {
//       enableNotifications();
//     } else {
//       disableNotifications();
//     }
//     saveNotificationPreference(isEnabled);
//   }
//
//   static enableNotifications() {
//     const androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'Channel description',
//       importance: Importance.high,
//       priority: Priority.high,
//       sound: null, // Disable sound by setting it to null
//     );
//
//     const notificationDetails = NotificationDetails(android: androidDetails);
//
//     fln.show(
//       0,
//       'Test Notification',
//       'Your notification is active, but no sound!',
//       notificationDetails,
//     );
//   }
//
//   static disableNotifications() {
//     fln.cancelAll();
//   }
//
//   void initializeApp() async {
//     bool isEnabled = await getNotificationPreference();
//     toggleNotifications(isEnabled);
//   }
//
//
//   //==================Listen Firebase Notification in every State of the app=================
//
//   static firebaseListenNotification({  required BuildContext context}) async {
//     FirebaseMessaging.instance.subscribeToTopic('signedInUsers');
// //============>>>>>Listen Notification when the app is in foreground state<<<<<<<===========
//
//     FirebaseMessaging.onMessage.listen((message) {
//       // debugPrint(
//       //     "Firebase onMessage=============================>>>>>>>>>>>>>>>>>>${message.data}");
//       //
//       //
//       initLocalNotification(message: message);
//
//       showTextNotification(
//         title: message.notification!.title!,
//         body: message.notification!.body!,
//       );
//     });
//
// //============>>>>>Listen Notification when the app is in BackGround state<<<<<<<===========
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       //handleMessage(message: message);
//     });
//
// //============>>>>>Listen Notification when the app is in Terminated state<<<<<<<===========
//
//     RemoteMessage? terminatedMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//
//     if (terminatedMessage != null) {
//       //handleMessage(message: terminatedMessage);
//     }
//   }
//
//   //============================Initialize Local Notification=======================
//
//   static Future<void> initLocalNotification(
//       {required RemoteMessage message}) async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings("@mipmap/ic_launcher");
//
//     var initializationSettingsIOS = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     fln.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//
//     await fln.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse? paylod) {
//         debugPrint("==================>>>>>>>>>paylod hitted");
//         //handleMessage(message: message);
//       },
//     );
//   }
//
//
//   // static handleMessage({required RemoteMessage message}) {
//   //   Map<String, dynamic> data = message.data;
//   //
//   //   String type = data["type"];
//   //
//   //   if (type == "inbox") {
//   //     SenderUser senderInfo =
//   //     SenderUser.fromJson(jsonDecode(data["senderUser"]));
//   //
//   //     MessageSent messageInfo =
//   //     MessageSent.fromJson(jsonDecode(data["messageSent"]));
//   //     Get.toNamed(AppRoute.inbox, arguments: [
//   //       senderInfo.name,
//   //       senderInfo.photo![0].publicFileUrl,
//   //       messageInfo.sender
//   //     ], parameters: {
//   //       "chatId": messageInfo.chat!
//   //     });
//   //   } else if (type == "matchRequest") {
//   //     Get.toNamed(AppRoute.matchRequest);
//   //   }
//   // }
//
// // <-------------------------- Show Text Notification  --------------------------->
//   static Future<void> showTextNotification({
//     required String title,
//     required String body,
//   }) async {
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//
//
//
//     AndroidNotificationDetails(
//       'notification', // meta-data android value
//       'notification', // meta-data android value
//       playSound: true,
//       importance: Importance.low,
//       priority: Priority.low,
//
//     );
//
//
//
//
//     var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
//         presentAlert: true, presentBadge: true, presentSound: true);
//
//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//     await fln.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }
//
//
//
//
// }

import 'dart:convert';
import 'dart:developer';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class FCMHandler {
  static FirebaseMessaging? _messaging;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  ///
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'artzfly application', // id
    'artzfly App', // title
    description: 'artzfly Notifications', // description
    importance: Importance.high,
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<String?> getFcmToken() async {
    _messaging = FirebaseMessaging.instance;
    String? fcmToken = await _messaging?.getToken();
    print("token: $fcmToken");
    return fcmToken;
  }

  static Future<void> initFcmListeners() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('flutter_devs');
    IOSInitializationSettings ios = const IOSInitializationSettings();
    InitializationSettings platform =
        InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      platform,
      onSelectNotification: (payload) {
        _fcmMessageClickHandler(payload, isFromLocalNotification: true);
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      //_socialController.uploadFCMToken(newToken);
      // Api.registerFCMToken(fcmToken: newToken, partnerId: AppPrefs.partnerId);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message received");
      print("event.data.toString = ${event.data.toString()}");
      print("event.notification.title = ${event.notification?.title}");
      print("event.notification.body = ${event.notification?.body}");

      // FlutterAppBadger.updateBadgeCount(1);

      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && !kIsWeb) {
        // NotificationDataModel model =
        //     NotificationDataModel.fromJson(event.data);

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'flutter_devs',
              styleInformation: const BigTextStyleInformation(''),
            ),
          ),
          payload: "",
        );
      }

      //_fcmMessageActionHandler(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      print('Message clicked!');
      // Fluttertoast.showToast(msg: "Message clicked - ${message.data.toString()}", toastLength: Toast.LENGTH_LONG);

      _fcmMessageClickHandler(jsonEncode(message?.data));
    });
    /* FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      log("FirebaseMessaging.instance.getInitialMessage() = $message");
      /* Fluttertoast.showToast(
          msg:
              "FirebaseMessaging.instance.getInitialMessage() - ${message?.data.toString()}",
          toastLength: Toast.LENGTH_LONG); */
      _fcmMessageActionHandler(message);
    }); */
  }

  static Future<void> fcmBackgroundMessageHandler(RemoteMessage message) async {
    // Fluttertoast.showToast(msg: "background message ${message.data.toString()}", toastLength: Toast.LENGTH_LONG);
    // print('background message ${message.notification.body}');
    // FlutterAppBadger.updateBadgeCount(1);
    _fcmMessageActionHandler(message);
  }

  static _fcmMessageActionHandler(RemoteMessage? event) async {
    // if (notNull(event)) {
      // NotificationDataModel model = NotificationDataModel.fromJson(event!.data);
      // Get.log("_fcmMessageActionHandler - event = ${event.data}");
      // switch (model.status) {
      //   case "upcoming":
      //     Get.to(() => const MyBookingsScreen(tabIndex: 0));
      //     break;
      //   case "complete":
      //     Get.to(() => const MyBookingsScreen(tabIndex: 1));
      //     break;
      //   case "cancel":
      //     Get.to(() => const MyBookingsScreen(tabIndex: 2));
      //     break;
      //   case "wallet":
      //     //homeScreenController.changeTab(3);
      //     //await Get.offNamedUntil(HomeScreen.id, (route) => route.isFirst);
      //     break;
      // }
    // }
  }

  static _fcmMessageClickHandler(String? data,
      {bool isFromLocalNotification = false}) async {
    //
    // HomeScreenController homeScreenController =
    //     Get.find<HomeScreenController>();
    // Get.log("_fcmMessageClickHandler - data = $data");
    // if (notNull(data)) {
    //   // Get.log("_fcmMessageClickHandler - data = ${jsonDecode(data!)}");
    //   NotificationDataModel model = NotificationDataModel();
    //   if (isFromLocalNotification) {
    //     Get.log("_fcmMessageClickHandler in the if");
    //     model = NotificationDataModel(
    //       status: data!.split("||").first,
    //       actionId: int.tryParse(data.split("||").last) ?? 0,
    //     );
    //     // TODO: Setup - Home Screen
    //     // AppNavigation.backUntil(page: () => HomeScreen());
    //   } else {
    //     Get.log("_fcmMessageClickHandler in the else");
    //     model = NotificationDataModel.fromJson(jsonDecode(data!));
    //   }
    //   Get.log("_fcmMessageClickHandler - model.type = ${model.status}");
    //   Get.log("_fcmMessageClickHandler - model.actionId = ${model.actionId}");
    //   switch (model.status) {
    //     case "upcoming":
    //       Get.to(() => const MyBookingsScreen(tabIndex: 0));
    //       break;
    //     case "complete":
    //       Get.to(() => const MyBookingsScreen(tabIndex: 1));
    //       break;
    //     case "cancel":
    //       Get.to(() => const MyBookingsScreen(tabIndex: 2));
    //       break;
    //     case "wallet":
    //       homeScreenController.changeTab(3);
    //       await Get.offNamedUntil(HomeScreen.id, (route) => route.isFirst);
    //       break;
    //     default:
    //       Fluttertoast.showToast(
    //           msg: AppStrings.somethingWentWrong,
    //           toastLength: Toast.LENGTH_LONG);
    //       break;
    //   }
    // }
  }

  static clearAllNotification() async {
    // FlutterAppBadger.removeBadge();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static checkInitialMessageAndNavigateToScreen() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      log("FirebaseMessaging.instance.getInitialMessage() = $message");
      // Fluttertoast.showToast(msg: "FirebaseMessaging.instance.getInitialMessage() - ${message?.data.toString()}", toastLength: Toast.LENGTH_LONG);
      if (message?.data != null) {
        _fcmMessageClickHandler(jsonEncode(message?.data));
      }
    });
  }
}

import 'package:app/screens/splash_screen.dart';
import 'package:app/screens/webview_screen.dart';
import 'package:app/services/fcm_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(FCMHandler.fcmBackgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<int, Color> _yellow700Map = {
      50: const Color(0xFFFFD7C2),
      100: Colors.yellow[100]!,
      200: Colors.yellow[200]!,
      300: Colors.yellow[300]!,
      400: Colors.yellow[400]!,
      500: Colors.yellow[500]!,
      600: Colors.yellow[600]!,
      700: Colors.yellow[800]!,
      800: Colors.yellow[900]!,
      900: Colors.yellow[700]!,
    };
    FCMHandler.initFcmListeners();
    return MaterialApp(
      title: 'artzfly - Handmade in India',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: MaterialColor(Colors.white.value, _yellow700Map),
      ),
      home: const WebviewScreen(),
    );
  }
}

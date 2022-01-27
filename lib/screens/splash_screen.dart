import 'package:app/data/image_paths.dart';
import 'package:app/helpers/snack_helper.dart';
import 'package:app/screens/webview_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final Widget _portrait = Image.asset(
    splashBg,
    fit: BoxFit.fitWidth,
    height: double.infinity,
    width: double.infinity,
  );

  static final Widget _landscape = Image.asset(
    splashBg,
    fit: BoxFit.fitWidth,
    height: double.infinity,
    width: double.infinity,
  );

  Widget _child = _landscape;
  @override
  void initState() {
    gotoNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: OrientationBuilder(builder: (_, orientation) {
          if (orientation == Orientation.portrait)
            _child = _portrait;
          else
            _child = _landscape;

          return _child;
        }),
      ),
    );
  }

  void gotoNextScreen() async {
    if (await connectionAvailable()) {
      //
      await Future.delayed(const Duration(seconds: 2));
      await FirebaseMessaging.instance.getToken();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WebviewScreen()));
    } else {
      SnackBarHelper.showSnackBarWithAction(context, () {
        gotoNextScreen();
      }, message: 'Connection error', dismissDuration: const Duration(days: 1));
    }
  }

  Future<bool> connectionAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a network.
      return true;
    } else {
      return false;
    }
  }
}

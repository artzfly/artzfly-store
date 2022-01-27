import 'dart:io';
import 'dart:ui';
import 'package:app/data/image_paths.dart';
import 'package:app/services/firebase_message_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

// late int scheck;
// late WebViewController _controller;

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key}) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool _loading = true;
  bool _error = false;
  bool _pageNavigationLoading = false;
  double _progress = 0.0;
  final _key = UniqueKey();
  late WebViewController _controller;
  static const appLogo = appIcon;
  static const url = 'https://www.artzfly.com/';
  static const accountUrl = 'https://www.artzfly.com/account';
  static const cartUrl = 'https://www.artzfly.com/cart';
  int _selectedNavigationIndex = 0;
  // late bool check;
  // late ScrollController _scrollController;

  @override
  void initState() {
    // _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
    // check = false;
    startFirebase();
    super.initState();
  }

  void _onItemTapped(int index) {
     setState(() {
      _selectedNavigationIndex = index;
    });

    if(index == 0) {
     _controller.loadUrl(url);
    } else if(index == 1) {
      _controller.loadUrl(accountUrl);
    } else if(index == 2) {
      _controller.loadUrl(cartUrl);
    }
  }

  // _scrollListener() {
  //   if (_scrollController.offset <=
  //           _scrollController.position.minScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     _controller.reload();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          setState(() {
            _error = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                key: _key,
                gestureNavigationEnabled: true,
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                  if (progress == 100) {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                onPageStarted: (String url) {
                  setState(() {
                    _pageNavigationLoading = true;
                  });
                },
                onPageFinished: (String result) {
                  _pageNavigationLoading = false;
                  // _controller.scrollBy(0, 5);
                },
                onWebViewCreated: (WebViewController controller) {
                  _controller = controller;
                },
                onWebResourceError: (WebResourceError error) {
                  setState(() {
                    _error = true;
                  });
                },
                // gestureRecognizers: [
                //   Factory(() => PlatformViewVerticalGestureRecognizer()),
                // ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.contains('addthis.com') ||
                      request.url.contains('sms:?') ||
                      request.url.contains('www.facebook.com') ||
                      request.url.contains('twitter.com') ||
                      request.url.contains('www.instagram.com') ||
                      request.url.contains('wa.me') ||
                      request.url.contains('www.pinterest.com/pin')) {
                    _launchURL(request.url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
              if (_loading)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.asset(
                    splashBg,
                    fit: BoxFit.cover,
                  ),
                ),
              if (_error)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'No Internet Connection',
                            style: TextStyle(
                              letterSpacing: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Image.asset(
                              errorIcon,
                              width: double.infinity,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(
                              40,
                              10,
                              40,
                              40,
                            ),
                            child: Text(
                              'Please check your connection again or connect to wifi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.reload();
                              setState(() {
                                _error = false;
                                _loading = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_pageNavigationLoading && !_error && !_loading)
                const Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Color(0xffF5A70F),
                  ),
                )
            ],
          ),
        ),
      bottomNavigationBar: !_loading ? SizedBox(
        height: 50,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '',
            ),
          ],
          currentIndex: _selectedNavigationIndex,
          selectedItemColor: const Color(0xffF5A70F),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 28,
          onTap: _onItemTapped,
        ),
      ): null
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void startFirebase() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessageService.startMessageListener(context);
  }
}

// class PlatformViewVerticalGestureRecognizer
//     extends VerticalDragGestureRecognizer {
//   Offset _dragDistance = Offset.zero;
//
//   @override
//   void addPointer(PointerEvent event) {
//     startTrackingPointer(event.pointer);
//   }
//
//   @override
//   void handleEvent(PointerEvent event) {
//     // _dragDistance = _dragDistance + event.delta;
//     print('*********************************');
//     print('Simple Dragging');
//     print(event.size.toString());
//     print('*********************************');
//     _controller.getScrollY().then((value) {
//       if (value < 2) {
//         _controller.reload();
//       }
//     });
//   }
//
//   @override
//   String get debugDescription => 'horizontal drag (platform view)';
//
//   @override
//   void didStopTrackingLastPointer(int pointer) {}
// }

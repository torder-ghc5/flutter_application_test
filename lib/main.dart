import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

main() async {
  // dotenv 초기화
  await dotenv.load();

  // 위젯 바인딩 초기화 : 웹뷰와 플러터 엔진과의 상호작용을 위함
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(
    const MaterialApp(home: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 인앱웹뷰 컨트롤러
  InAppWebViewController? webViewController;

  InAppWebViewSettings options = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true, // URL 로딩 제어
    mediaPlaybackRequiresUserGesture: false, // 미디어 자동 재생
    javaScriptEnabled: true, // 자바스크립트 실행 여부
    javaScriptCanOpenWindowsAutomatically: true, // 팝업 여부
    useHybridComposition: true, // 하이브리드 사용을 위한 안드로이드 웹뷰 최적화
    allowsInlineMediaPlayback: true, // 웹뷰 내 미디어 재생 허용
  );

  // network 연결 확인
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    sendMessageToWeb();
  }

  // 웹뷰 화면 띄우기
  String webviewUrl = dotenv.env['WEBVIEW_URL'] ?? '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: List.empty());

    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(webviewUrl)),
          onWebViewCreated: (controller) {
            webViewController = controller;
            controller.addJavaScriptHandler(
                handlerName: 'flutterHandler',
                callback: (args) {
                  return _connectionStatus;
                });
          },
        ),
      ),
    );
  }

  void sendMessageToWeb() async {
    await webViewController?.postWebMessage(
        message: WebMessage(data: '$_connectionStatus'),
        targetOrigin: WebUri(webviewUrl));
  }
}

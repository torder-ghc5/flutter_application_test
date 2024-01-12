import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  // 위젯 바인딩 초기화 : 웹뷰와 플러터 엔진과의 상호작용을 위함
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
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
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      // 플랫폼 상관없이 동작하는 옵션
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true, // URL 로딩 제어
        mediaPlaybackRequiresUserGesture: false, // 미디어 자동 재생
        javaScriptEnabled: true, // 자바스크립트 실행 여부
        javaScriptCanOpenWindowsAutomatically: true, // 팝업 여부
      ),
      // 안드로이드 옵션
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true, // 하이브리드 사용을 위한 안드로이드 웹뷰 최적화
      ),
      // iOS 옵션
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true, // 웹뷰 내 미디어 재생 허용
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    // // 시작 페이지
                    // initialData:
                    //     InAppWebViewInitialData(data: """ """), // 코드 작성
                    // // 초기 설정
                    // initialOptions: options,
                    initialUrlRequest:
                        URLRequest(url: WebUri("http://192.168.11.42:5173/")),
                    // 인앱웹뷰 생성 시 컨트롤러 정의
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

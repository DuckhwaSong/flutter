import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:convert';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('하이브리드 웹 앱'),
        ),*/
        body: const WebViewPage(),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final String _internalDomain = 'https://pointpp.duckdns.org'; // 웹뷰 내에서 유지할 도메인

  // 1. 상태 변수 선언: userAgent 값을 저장할 변수
  String? _userAgent;
  String? _outboundIP;

  // 2. initState()에서 비동기 작업 수행
  @override
  void initState() {
    super.initState();
    _setCustomUserAgent();
    //_getOutboundIp();
  }

  // 3. UUID를 가져와 상태를 업데이트하는 비동기 함수
  Future<void> _setCustomUserAgent() async {
    String uuidWithHiddenChars = await FlutterUdid.udid;
    String uuid = uuidWithHiddenChars.trim(); // trim() 메서드로 공백 및 줄바꿈 제거
    // 모든 유니코드 공백 문자(\p{Z})와 제어 문자(\p{C})를 제거
    //String cleanedUuid = uuidWithHiddenChars.replaceAll(RegExp(r'[\p{Z}\p{C}]', unicode: true), '');

    setState(() {
      // 4. setState() 호출로 UI를 갱신
      _userAgent = "PointPangPangApp-1.0(UUID:${uuid})";
    });
  }

  @override
  Widget build(BuildContext context) {

    // 5. _userAgent가 null이 아닌 경우에만 InAppWebView를 표시
    //    (UUID를 가져오는 동안 로딩 화면을 보여줄 수 있음)
    if (_userAgent == null) {
      return const Center(child: CircularProgressIndicator());
    }

    //print("==============================");
    //print(_userAgent);
    //print(_userAgent.runtimeType);
    //print("==============================");

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(_internalDomain)),

      /*onReceivedServerTrustAuthRequest: (controller, challenge) async {
        // 서버 인증서 유효성 검사 무시
        return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
      },*/

      // *** 핵심 부분: URL 로딩 재정의 ***
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        print("==============================");
        print(navigationAction);
        print(navigationAction.runtimeType);
        print("==============================");

        // null 체크: uri가 null이면 바로 처리 중단
        if (uri == null) return NavigationActionPolicy.ALLOW; // 또는 CANCEL

        // WebUri를 Uri로 안전하게 변환
        final Uri externalUri = Uri.parse(uri.toString());

        // 1. isRedirect 속성을 사용하여 자동 탐색을 걸러냅니다.
        //    (이 속성이 isUserInitiated 대신 임시로 사용될 수 있습니다.)
        /*if (navigationAction.isRedirect) {
            return NavigationActionPolicy.ALLOW;
        }
        // 2. JS에 의해 시작된 탐색인지 확인
        //    (JS를 통한 페이지 내 이동은 웹뷰 내부에서 처리하도록 허용)
        if (!navigationAction.isUserInitiated) {
            // isUserInitiated가 false인 경우: JS, 리다이렉션 등으로 인한 자동 탐색
            return NavigationActionPolicy.ALLOW;
        }*/
        // 내부 도메인(Host)에 대한 탐색은 웹뷰 내부에서 허용
        if (externalUri.host.contains(_internalDomain)) {
            return NavigationActionPolicy.ALLOW;
        }
        // 외부 링크 (사용자 시작)는 url_launcher로 처리
        if (await canLaunchUrl(externalUri)) {
          await launchUrl(externalUri, mode: LaunchMode.externalApplication);
          return NavigationActionPolicy.CANCEL; // 웹뷰 로드 취소
        }        
        // 그 외의 경우 로드 허용
        return NavigationActionPolicy.ALLOW;        
      },
      /*initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          userAgent: _userAgent!, // _userAgent가 String 타입인지 확인
          javaScriptEnabled: true,
        ),
      ),*/
    );
  }
}
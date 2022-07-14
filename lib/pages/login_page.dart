import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/pages/top_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../service/qiita_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  WebViewPlusController? _controller;

  late final String uri;
  double webViewHeight = 1;

  Future<void> onPageFinished(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (uri.queryParameters['code'] != null) {
      onAuthorizeCallbackIsCalled(uri);
    }
    await pageLoading();
  }

  Future<void> pageLoading() async {
    await _controller?.getHeight().then((double height) {
      setState(() {
        webViewHeight = height;
      });
    });
  }

  void onAuthorizeCallbackIsCalled(Uri uri) async {
    final accessToken = await QiitaClient.createAccessTokenFromCallbackUri(uri);
    await QiitaClient.saveAccessToken(accessToken);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => TopPage(
                uri: uri,
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebViewPlus.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            ),
            height: 59.0,
            child: Center(
              child: Text(
                "Qiita Auth",
                style: GoogleFonts.pacifico(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: webViewHeight + keyboardHeight,
            child: WebViewPlus(
              initialUrl: QiitaClient.createAuthorizeUrl(),
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) => onPageFinished(context, url),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/pages/top_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../service/qiita_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late WebViewController _webViewController;
  double _webViewHeight = 0;

  late final String uri;

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

  Future<void> onPageFinished(context, url) async {
    final uri = Uri.parse(url);
    if (uri.queryParameters['code'] != null) {
      onAuthorizeCallbackIsCalled(uri);
    }
    double newHeight = double.parse(
      await _webViewController.runJavascriptReturningResult(
          "document.documentElement.scrollHeight;"),
    );
    setState(() {
      _webViewHeight = newHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.95,
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
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                height: _webViewHeight,
                color: Colors.white,
                child: WebView(
                  initialUrl: QiitaClient.createAuthorizeUrl(),
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) async {
                    final uri = Uri.parse(url);
                    if (uri.queryParameters['code'] != null) {
                      onAuthorizeCallbackIsCalled(uri);
                    }
                    await onPageFinished(context, url);
                  },
                  onWebViewCreated: (WebViewController webViewController) {
                    _webViewController = webViewController;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

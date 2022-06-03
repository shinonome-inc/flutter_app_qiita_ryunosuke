import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/top_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late WebViewController _webViewController;
  double _webViewHeight = 1;
  late final Uri uri;

  void onAuthorizeCallbackIsCalled(Uri uri) async {
    final accessToken = await QiitaClient.createAccessTokenFromCallbackUri(uri);
    await QiitaClient.saveAccessToken(accessToken);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TopPage()),
    );
  }

  Future<void> onPageFinished(BuildContext context, String url) async {
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
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Qiita Auth',
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _webViewHeight,
                child: WebView(
                  initialUrl: QiitaClient.createdAuthorizeUrl(),
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) async {
                    final uri = Uri.parse(url);
                    if (uri.queryParameters['code'] != null) {
                      onAuthorizeCallbackIsCalled(uri);
                    }
                    await onPageFinished(context, url);
                  },
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                ),
              ),
              Container(
                height: 500,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

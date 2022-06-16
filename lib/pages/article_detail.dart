import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/article.dart';

class ArticleDetail extends StatefulWidget {
  final Article article;
  const ArticleDetail({Key? key, required this.article}) : super(key: key);
  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  double _webViewHeight = 0;
  late WebViewController _webViewController;

  Future<void> onPageFinished(
    BuildContext context,
    String url,
  ) async {
    double contentHeight = double.parse(
        await _webViewController.runJavascriptReturningResult(
            "document.documentElement.scrollHeight;"));
    setState(() {
      _webViewHeight = contentHeight;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          height: 59.0,
          child: Center(
            child: Text(
              "Article",
              style: GoogleFonts.pacifico(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: SizedBox(
              height: _webViewHeight,
              child: WebView(
                initialUrl: widget.article.url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (String url) => onPageFinished(context, url),
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

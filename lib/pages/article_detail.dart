import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          Container(
            height: 57.0,
            width: size.width,
            color: HexColor('F9F9F9'),
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
              child: Container(
                height: _webViewHeight,
                color: Colors.white,
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
      ),
    );
  }
}

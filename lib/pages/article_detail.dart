import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../models/article.dart';

class ArticleDetail extends StatefulWidget {
  final Article article;
  const ArticleDetail({Key? key, required this.article}) : super(key: key);
  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  double _webViewHeight = 1;
  WebViewPlusController? _controller;

  Future<void> onPageFinished(context, url) async {
    await _controller?.getHeight().then((double height) {
      setState(() {
        _webViewHeight = height;
      });
    });
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
                "Article",
                style: GoogleFonts.pacifico(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: _webViewHeight,
            child: WebViewPlus(
              initialUrl: widget.article.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) => onPageFinished(context, url),
              onWebViewCreated: (WebViewPlusController controller) {
                _controller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}

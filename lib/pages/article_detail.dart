import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
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
    if (Platform.isAndroid) {
      WebViewPlus.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Article',
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
      ),
    );
  }
}

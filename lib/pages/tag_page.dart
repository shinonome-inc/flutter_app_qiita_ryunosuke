import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/models/tag.dart';
import 'package:flutter_app_qiita/pages/tag_list_view.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import 'error_page.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Future<List<dynamic>> futureTag;
  List<Tag> tags = [];
  int page = 1;

  @override
  void initState() {
    futureTag = QiitaClient.fetchTag(page);
    super.initState();
  }

  void reloadTag() {
    setState(() {
      futureTag = QiitaClient.fetchTag(page);
    });
  }

  Future<void> addTags(int page) async {
    var tagItems = await QiitaClient.fetchTag(page);
    setState(() {
      tags.addAll(tagItems);
    });
  }

  Future<void> onRefreshTag() async {
    var newTagItems = await QiitaClient.fetchTag(page);
    setState(() {
      tags.clear();
      tags.addAll(newTagItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Tag',
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.extentAfter == 0) {
            addTags(++page);
          }
          return true;
        },
        child: FutureBuilder<List<dynamic>>(
          future: futureTag,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            int tagsNum = (MediaQuery.of(context).size.width ~/ 162);
            if (snapshot.hasData) {
              tags = snapshot.data;
              return CustomRefreshIndicator(
                onRefresh: onRefreshTag,
                builder: (BuildContext context, Widget child,
                    IndicatorController controller) {
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, _) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          if (!controller.isIdle)
                            Positioned(
                                top: 50 * controller.value,
                                child: const CupertinoActivityIndicator()),
                          Transform.translate(
                            offset: Offset(0, 100.0 * controller.value),
                            child: child,
                          ),
                        ],
                      );
                    },
                  );
                },
                child: TagListView(
                  tags: tags,
                  tagsNum: tagsNum,
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorPage(onTapReload: reloadTag);
            }
            return const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Center(
                child: SizedBox(
                    height: 30, width: 30, child: CupertinoActivityIndicator()),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/pages/tag_detail.dart';

import '../models/tag.dart';

class TagListView extends StatefulWidget {
  final List<Tag> tags;
  final int tagsNum;
  const TagListView({Key? key, required this.tags, required this.tagsNum})
      : super(key: key);

  @override
  State<TagListView> createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  Widget tagItem(tag) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 38.0,
                width: 38.0,
                child: CachedNetworkImage(
                  imageUrl: tag.iconUrl,
                  placeholder: (context, url) => const SizedBox(
                      width: 38.0,
                      height: 38.0,
                      child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/default_icon_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Text(
                  tag.id,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              Text(
                '記事件数：${tag.itemsCount}',
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Text(
                  'フォロワー数：${tag.followersCount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagDetail(
                tag: tag,
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.tagsNum,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.tags.length,
        itemBuilder: (context, index) {
          final tag = widget.tags[index];
          return tagItem(tag);
        },
      ),
    );
  }
}

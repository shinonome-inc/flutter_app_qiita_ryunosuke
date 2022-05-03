import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/tag.dart';

class TagListView extends StatefulWidget {
  final List<Tag> tags;
  const TagListView({Key? key, required this.tags}) : super(key: key);

  @override
  State<TagListView> createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double width = size.width;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (width >= 600) ? 3 : 2,
      ),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.tags.length,
      itemBuilder: (context, index) {
        final tag = widget.tags[index];
        return ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
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
        );
      },
    );
  }
}

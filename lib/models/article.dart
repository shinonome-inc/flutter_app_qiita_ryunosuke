import 'package:flutter_app_qiita/models/user.dart';

class Article {
  final String title;
  final String url;
  final String createdAt;
  final int likesCount;
  final User user;

  Article({
    required this.title,
    required this.url,
    required this.createdAt,
    required this.likesCount,
    required this.user,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      createdAt: json['created_at'],
      likesCount: json['likes_count'],
      user: User.fromJson(json['user']),
    );
  }
}



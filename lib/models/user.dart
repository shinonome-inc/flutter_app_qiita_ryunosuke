class User {
  final String description;
  final int followeesCount;
  final int followersCount;
  final String name;
  final String id;
  final String iconUrl;
  final String posts;

  User(
      {required this.id,
      required this.iconUrl,
      required this.description,
      required this.followeesCount,
      required this.followersCount,
      required this.name,
      required this.posts,
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      description: json['description']?? '未設定',
      followeesCount: json['followees_count'],
      followersCount: json['followers_count'],
      name: json['name'] == '' ? 'ユーザー名未設定': json['name'],
      id: json['id'],
      iconUrl: json['profile_image_url'],
      posts:json['item_count'],
    );
  }
}

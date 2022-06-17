class User {
  final String id;
  final String iconUrl;
  final String? name;
  final String? description;
  final int? followingsCount;
  final int? followersCount;
  final int? posts;

  User({
    required this.id,
    required this.iconUrl,
    required this.name,
    required this.description,
    required this.followingsCount,
    required this.followersCount,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      iconUrl: json['profile_image_url'],
      name: json['name'] == '' ? 'ユーザー名未設定' : json['name'],
      description: json['description'] ?? 'description未設定',
      followingsCount: json['followees_count'],
      followersCount: json['followers_count'],
      posts: json['items_count'],
    );
  }
}

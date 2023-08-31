class UserFollowMangaModel {
  final String id;
  final String currentChapterId;
  final String lastestChapterId;
  final int createdAt;

  UserFollowMangaModel({
    required this.id,
    required this.currentChapterId,
    required this.lastestChapterId,
    required this.createdAt,
  });

  factory UserFollowMangaModel.empty() {
    return UserFollowMangaModel(
      id: "",
      currentChapterId: "",
      lastestChapterId: "",
      createdAt: 0,
    );
  }

  factory UserFollowMangaModel.fromJson(Map<String, dynamic> json) {
    return UserFollowMangaModel(
      id: json["_id"] as String,
      currentChapterId: json["currentChapterId"] as String,
      lastestChapterId: json["lastestChapterId"] as String,
      createdAt: json["createdAt"] as int,
    );
  }
}

class MangaAuthorModel {
  final String id;
  final String name;

  const MangaAuthorModel({
    required this.id,
    required this.name,
  });

  factory MangaAuthorModel.fromJson(Map<String, dynamic> json) {
    return MangaAuthorModel(
      id: json["_id"] as String,
      name: json["name"] as String,
    );
  }
}

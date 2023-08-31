class MangaTagModel {
  final String id;
  final String name;
  final String description;

  const MangaTagModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MangaTagModel.fromJson(Map<String, dynamic> json) {
    return MangaTagModel(
      id: json["_id"] as String,
      name: json["name"] as String,
      description: json["description"] as String,
    );
  }
}

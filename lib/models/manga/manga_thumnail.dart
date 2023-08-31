class MangaThumnailModel {
  final String id;
  final String detailId;
  final String src;

  const MangaThumnailModel({
    required this.id,
    required this.detailId,
    required this.src,
  });

  factory MangaThumnailModel.empty() {
    return const MangaThumnailModel(
      id: "",
      detailId: "",
      src: "",
    );
  }

  factory MangaThumnailModel.fromJson(Map<String, dynamic> json) {
    return MangaThumnailModel(
      id: json["_id"] as String,
      detailId: json["detailId"] as String,
      src: json["src"] as String,
    );
  }
}

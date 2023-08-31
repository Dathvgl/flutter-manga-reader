class MangaChapterModel {
  final String id;
  final String detailId;
  final double chapter;
  final int time;
  final int watched;

  const MangaChapterModel({
    required this.id,
    required this.detailId,
    required this.chapter,
    required this.time,
    required this.watched,
  });

  factory MangaChapterModel.fromJson(Map<String, dynamic> json) {
    return MangaChapterModel(
      id: json["_id"] as String,
      detailId: json["detailId"] as String,
      chapter: json["chapter"].runtimeType == int
          ? (json["chapter"] as int).toDouble()
          : json["chapter"] as double,
      time: json["time"] as int,
      watched: json["watched"] as int,
    );
  }
}

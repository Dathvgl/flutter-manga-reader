class MangaChapterImageModel {
  final MangaChapterDetailModel? canPrev;
  final MangaChapterDetailModel? canNext;
  final MangaChapterCurrentModel? current;
  final List<MangaChapterDetailModel> chapters;

  const MangaChapterImageModel({
    this.canPrev,
    this.canNext,
    this.current,
    required this.chapters,
  });

  factory MangaChapterImageModel.empty() {
    return const MangaChapterImageModel(
      canPrev: null,
      canNext: null,
      current: null,
      chapters: [],
    );
  }

  factory MangaChapterImageModel.fromJson(Map<String, dynamic> json) {
    return MangaChapterImageModel(
      canPrev: json["canPrev"] == null
          ? null
          : MangaChapterDetailModel.fromJson(json["canPrev"]),
      canNext: json["canNext"] == null
          ? null
          : MangaChapterDetailModel.fromJson(json["canNext"]),
      current: json["current"] == null
          ? null
          : MangaChapterCurrentModel.fromJson(json["current"]),
      chapters: (json["chapters"] as List)
          .map((e) => MangaChapterDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class MangaChapterDetailModel {
  final String id;
  final double chapter;

  const MangaChapterDetailModel({
    required this.id,
    required this.chapter,
  });

  factory MangaChapterDetailModel.empty() {
    return const MangaChapterDetailModel(
      id: "",
      chapter: 0,
    );
  }

  factory MangaChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return MangaChapterDetailModel(
      id: json["_id"] as String,
      chapter: json["chapter"].runtimeType == int
          ? (json["chapter"] as int).toDouble()
          : json["chapter"] as double,
    );
  }
}

class MangaChapterCurrentModel {
  final String id;
  final double chapter;
  final List<MangaChapterCurrentImageModel> chapters;

  const MangaChapterCurrentModel({
    required this.id,
    required this.chapter,
    required this.chapters,
  });

  factory MangaChapterCurrentModel.fromJson(Map<String, dynamic> json) {
    return MangaChapterCurrentModel(
      id: json["_id"] as String,
      chapter: json["chapter"].runtimeType == int
          ? (json["chapter"] as int).toDouble()
          : json["chapter"] as double,
      chapters: (json["chapters"] as List)
          .map((e) => MangaChapterCurrentImageModel.fromJson(e))
          .toList(),
    );
  }
}

class MangaChapterCurrentImageModel {
  final String id;
  final String chapterId;
  final double chapterIndex;
  final String src;

  const MangaChapterCurrentImageModel({
    required this.id,
    required this.chapterId,
    required this.chapterIndex,
    required this.src,
  });

  factory MangaChapterCurrentImageModel.fromJson(Map<String, dynamic> json) {
    return MangaChapterCurrentImageModel(
      id: json["_id"] as String,
      chapterId: json["chapterId"] as String,
      chapterIndex: json["chapterIndex"].runtimeType == int
          ? (json["chapterIndex"] as int).toDouble()
          : json["chapterIndex"] as double,
      src: json["src"] as String,
    );
  }
}

import 'package:flutter_crawl/models/manga/manga_author.dart';

class MangaListModel {
  final int totalData;
  final int totalPage;
  final int currentPage;
  final bool canPrev;
  final bool canNext;
  final List<MangaListDetailModel> data;

  const MangaListModel({
    required this.totalData,
    required this.totalPage,
    required this.currentPage,
    required this.canPrev,
    required this.canNext,
    required this.data,
  });

  factory MangaListModel.empty() {
    return const MangaListModel(
      totalData: 0,
      totalPage: 0,
      currentPage: 0,
      canPrev: false,
      canNext: false,
      data: [],
    );
  }

  factory MangaListModel.fromJson(Map<String, dynamic> json) {
    return MangaListModel(
      totalData: json["totalData"] as int,
      totalPage: json["totalPage"] as int,
      currentPage: json["currentPage"] as int,
      canPrev: json["canPrev"] as bool,
      canNext: json["canNext"] as bool,
      data: (json["data"] as List)
          .map((e) => MangaListDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class MangaListDetailModel {
  final String id;
  final String title;
  final List<MangaAuthorModel> authors;
  final String status;
  final List<MangaListTagModel> tags;
  final int watched;
  final int followed;
  final int lastestUpdated;
  final String description;
  final List<MangaListChapterModel> chapters;

  const MangaListDetailModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.status,
    required this.tags,
    required this.watched,
    required this.followed,
    required this.lastestUpdated,
    required this.description,
    required this.chapters,
  });

  factory MangaListDetailModel.fromJson(Map<String, dynamic> json) {
    return MangaListDetailModel(
      id: json["_id"] as String,
      title: json["title"] as String,
      authors: (json["authors"] as List)
          .map((e) => MangaAuthorModel.fromJson(e))
          .toList(),
      status: json["status"] as String,
      tags: (json["tags"] as List)
          .map((e) => MangaListTagModel.fromJson(e))
          .toList(),
      watched: json["watched"] as int,
      followed: json["followed"] as int,
      lastestUpdated: json["lastestUpdated"] as int,
      description: json["description"] as String,
      chapters: (json["chapters"] as List)
          .map((e) => MangaListChapterModel.fromJson(e))
          .toList(),
    );
  }
}

class MangaListTagModel {
  final String id;
  final String name;

  const MangaListTagModel({
    required this.id,
    required this.name,
  });

  factory MangaListTagModel.fromJson(Map<String, dynamic> json) {
    return MangaListTagModel(
      id: json["_id"] as String,
      name: json["name"] as String,
    );
  }
}

class MangaListChapterModel {
  final String id;
  final double chapter;
  final int time;

  const MangaListChapterModel({
    required this.id,
    required this.chapter,
    required this.time,
  });

  factory MangaListChapterModel.fromJson(Map<String, dynamic> json) {
    return MangaListChapterModel(
      id: json["_id"] as String,
      chapter: json["chapter"].runtimeType == int
          ? (json["chapter"] as int).toDouble()
          : json["chapter"] as double,
      time: json["time"] as int,
    );
  }
}

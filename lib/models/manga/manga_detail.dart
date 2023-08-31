import 'package:flutter_crawl/models/manga/manga_author.dart';
import 'package:flutter_crawl/models/manga/manga_tag.dart';

class MangaDetailModel {
  final String id;
  final String title;
  final String? altTitle;
  final List<MangaAuthorModel> authors;
  final String status;
  final List<MangaTagModel> tags;
  final int watched;
  final int followed;
  final int lastestUpdated;
  final String description;

  const MangaDetailModel({
    required this.id,
    required this.title,
    this.altTitle,
    required this.authors,
    required this.status,
    required this.tags,
    required this.watched,
    required this.followed,
    required this.lastestUpdated,
    required this.description,
  });

  factory MangaDetailModel.empty() {
    return const MangaDetailModel(
      id: "",
      title: "",
      authors: [],
      status: "",
      tags: [],
      watched: 0,
      followed: 0,
      lastestUpdated: 0,
      description: "",
    );
  }

  factory MangaDetailModel.fromJson(Map<String, dynamic> json) {
    return MangaDetailModel(
      id: json["_id"] as String,
      title: json["title"] as String,
      altTitle: json["altTitle"] as String?,
      authors: (json["authors"] as List)
          .map((e) => MangaAuthorModel.fromJson(e))
          .toList(),
      status: json["status"] as String,
      tags:
          (json["tags"] as List).map((e) => MangaTagModel.fromJson(e)).toList(),
      watched: json["watched"] as int,
      followed: json["followed"] as int,
      lastestUpdated: json["lastestUpdated"] as int,
      description: json["description"] as String,
    );
  }
}

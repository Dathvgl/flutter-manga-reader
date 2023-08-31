import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/manga/manga_chapter.dart';
import 'package:flutter_crawl/models/manga/manga_chapter_image.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/models/manga/manga_list.dart';
import 'package:flutter_crawl/models/manga/manga_thumnail.dart';

class MangaRepository {
  final Dio _dio = Dio();
  final String _url = "https://nodejs-crawl-puppeteer.onrender.com";

  Future<MangaListModel> getMangaList({
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/manga/list",
        queryParameters: {
          "type": type.name,
          "sort": "lastest",
          "order": "desc",
        },
      );

      if (kDebugMode) {
        print("Get manga list");
      }

      return MangaListModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return MangaListModel.empty();
    }
  }

  Future<MangaThumnailModel> getMangaThumnail({
    required String id,
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/manga/thumnail/$id",
        queryParameters: {
          "type": type.name,
        },
      );

      if (kDebugMode) {
        print("Get manga thumnail");
      }

      return MangaThumnailModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return MangaThumnailModel.empty();
    }
  }

  Future<MangaDetailModel> getMangaDetail({
    required String id,
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/manga/detail/$id",
        queryParameters: {
          "type": type.name,
        },
      );

      if (kDebugMode) {
        print("Get manga detail");
      }

      return MangaDetailModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return MangaDetailModel.empty();
    }
  }

  Future<List<MangaChapterModel>> getMangaDetailChapter({
    required String id,
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/manga/chapter/$id",
        queryParameters: {
          "type": type.name,
        },
      );

      if (kDebugMode) {
        print("Get manga detail chapter");
      }

      return (response.data as List)
          .map((e) => MangaChapterModel.fromJson(e))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return [];
    }
  }

  Future<MangaChapterImageModel> getMangaDetailChapterImage({
    required String detailId,
    required String chapterId,
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/manga/chapter/$detailId/$chapterId",
        queryParameters: {
          "type": type.name,
        },
      );

      if (kDebugMode) {
        print("Get manga detail chapter image");
      }

      return MangaChapterImageModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return MangaChapterImageModel.empty();
    }
  }
}

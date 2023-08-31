import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/tuTien/tuTiens/quoc_vuong_van_tue.dart';
import 'package:flutter_crawl/models/tuTien/tu_tien.dart';
import 'package:flutter_crawl/models/user/user_follow_manga.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String _url = "https://nodejs-crawl-puppeteer.onrender.com";
  final _firebaseDatabase = FirebaseDatabase.instance;

  List<TuTienModel> _tuTiens = [];
  QuocVuongVanTueModel? _tuLuyen;

  set tuTiens(List<TuTienModel> tuTiens) {
    _tuTiens = tuTiens;
  }

  void init({required List<TuTienModel> tuTiens}) {
    _tuTiens = tuTiens;
  }

  Future<void> updateTuLuyen([String? id]) async {
    final tuTien = _tuTiens.firstWhereOrNull((element) => element.id == id);

    if (tuTien == null || id == null) {
      _tuLuyen = null;
    } else {
      _tuLuyen = await TuTienModel.tuLuyen(
        id: id,
        tuTiens: _tuTiens,
      );
    }
  }

  Stream<DatabaseEvent>? listenUserCultivation({required String uid}) {
    if (uid.isEmpty) return null;
    return _firebaseDatabase.ref("tuTien/$uid").onValue;
  }

  Future<void> setUserCultivation({required String uid}) async {
    await _firebaseDatabase.ref("tuTien/$uid").set({
      "idTuLuyen": _tuLuyen?.id,
      "idCanhGioi": _tuLuyen?.canhGioi.phamNhan.id,
      "xungHo": _tuLuyen?.canhGioi.phamNhan.xungHo,
      "tuVi": 0,
    });
  }

  Future<void> updateUserCultivation({
    required String uid,
    required String idCanhGioi,
    required int tuVi,
    required int tuViTheo,
  }) async {
    if (idCanhGioi.isEmpty) {
      await updateTuLuyen("quocVuongVanTue");
      await setUserCultivation(uid: uid);
    }

    int multiple = tuViTheo;
    final result = tuVi + multiple;

    Map<String, dynamic> map = {
      "tuVi": ServerValue.increment(multiple),
    };

    final canhGioi = _tuLuyen?.canhGioi.get(idCanhGioi);
    final canhGioiMoi = _tuLuyen?.canhGioi.nextRealm(
      result: result,
      canhGioi: _tuLuyen?.canhGioi.get(canhGioi?.nextId),
    );

    if (canhGioi?.id != canhGioiMoi?.id) {
      if (canhGioiMoi != null) {
        map = {
          "idCanhGioi": canhGioiMoi.backId,
          "xungHo": canhGioiMoi.xungHo,
          "tuVi": ServerValue.increment(multiple),
        };
      }
    }

    await _firebaseDatabase.ref("tuTien/$uid").update(map);
  }

  Future<UserFollowMangaModel?> getUserFollowManga({
    required String mangaId,
    required String token,
    required MangaTypes type,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/user/followManga/$mangaId",
        queryParameters: {
          "type": type.name,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      if (kDebugMode) {
        print("User get follow manga");
      }

      return UserFollowMangaModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }

      return null;
    }
  }

  Future<void> postUserFollowManga({
    required String mangaId,
    required String token,
    required MangaTypes type,
  }) async {
    try {
      await _dio.post(
        "$_url/api/user/followManga/$mangaId",
        queryParameters: {
          "type": type.name,
          "chapter": "empty",
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      if (kDebugMode) {
        print("User post follow manga");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }
    }
  }

  Future<void> putUserFollowManga({
    required String id,
    required String token,
    required MangaTypes type,
    required bool replace,
    required String currentChapter,
  }) async {
    try {
      await _dio.put("$_url/api/user/followManga/$id",
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
          ),
          data: jsonEncode({
            "type": type.name,
            "replace": replace,
            "currentChapter": currentChapter,
          }));

      if (kDebugMode) {
        print("User put follow manga");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }
    }
  }

  Future<void> deleteUserFollowManga({
    required String id,
    required String token,
    required MangaTypes type,
  }) async {
    try {
      await _dio.delete(
        "$_url/api/user/followManga/$id",
        queryParameters: {
          "type": type.name,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      if (kDebugMode) {
        print("User delete follow manga");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Data not found / Connection issue");
      }
    }
  }
}

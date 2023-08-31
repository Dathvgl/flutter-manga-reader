import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_crawl/models/tuTien/tu_tien.dart';

class QuocVuongVanTueModel extends TuLuyenModel {
  QuocVuongVanTueModel({
    required super.id,
    required super.canhGioi,
  });

  static Future<QuocVuongVanTueModel> deepJson({
    required String id,
    required Map<String, dynamic> json,
  }) async {
    final canhGioiJson =
        await rootBundle.loadString(json["canhGioi"] as String);

    return QuocVuongVanTueModel(
      id: id,
      canhGioi: QuocVuongVanTueCanhGioiModel.fromJson(jsonDecode(canhGioiJson)),
    );
  }
}

class QuocVuongVanTueCanhGioiModel extends TuLuyenCanhGioiModel {
  final CanhGioiModel tinhCap;
  final CanhGioiModel nguyetCap;

  QuocVuongVanTueCanhGioiModel({
    required super.phamNhan,
    required this.tinhCap,
    required this.nguyetCap,
  });

  factory QuocVuongVanTueCanhGioiModel.fromJson(Map<String, dynamic> json) {
    return QuocVuongVanTueCanhGioiModel(
      phamNhan: CanhGioiModel.fromJson(json["phamNhan"]),
      tinhCap: CanhGioiModel.fromJson(json["tinhCap"]),
      nguyetCap: CanhGioiModel.fromJson(json["nguyetCap"]),
    );
  }

  @override
  Map<String, CanhGioiModel> toJson() {
    return {
      "phamNhan": phamNhan,
      "tinhCap": tinhCap,
      "nguyetCap": nguyetCap,
    };
  }
}

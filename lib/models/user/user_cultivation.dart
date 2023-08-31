import 'package:equatable/equatable.dart';

class UserCultivationModel extends Equatable {
  final String idTuLuyen;
  final String idCanhGioi;
  final String xungHo;
  final int tuVi;

  const UserCultivationModel({
    required this.idTuLuyen,
    required this.idCanhGioi,
    required this.xungHo,
    required this.tuVi,
  });

  const UserCultivationModel.empty({
    this.idTuLuyen = "",
    this.idCanhGioi = "",
    this.xungHo = "Phàm Nhân",
    this.tuVi = 0,
  });

  factory UserCultivationModel.fromJson(Map<String, dynamic> json) {
    return UserCultivationModel(
      idTuLuyen: json["idTuLuyen"] as String,
      idCanhGioi: json["idCanhGioi"] as String,
      xungHo: json["xungHo"] as String,
      tuVi: json["tuVi"] as int,
    );
  }

  @override
  List<Object?> get props => [identityHashCode(this)];
}

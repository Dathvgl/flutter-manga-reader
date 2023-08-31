// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/tuTien/tu_tien.dart';
import 'package:meta/meta.dart';

part 'cultivation_state.dart';

class CultivationCubit extends Cubit<CultivationState> {
  List<TuTienModel> _tuTiens = [];

  CultivationCubit({required List<TuTienModel> tuTiens})
      : super(const CultivationInitial()) {
    _tuTiens = tuTiens;
    listen(TuLuyenGioi.quocVuongVanTue);
  }

  Future<void> listen(TuLuyenGioi idTuLuyen) async {
    final tuLuyen = await TuTienModel.tuLuyen(
      id: idTuLuyen.name,
      tuTiens: _tuTiens,
    );

    if (tuLuyen != null) {
      emit(CultivationInitial(
        idTuLuyen: idTuLuyen,
        tuLuyen: tuLuyen,
      ));
    }
  }
}

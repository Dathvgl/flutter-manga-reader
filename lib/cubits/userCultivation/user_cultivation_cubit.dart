// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_crawl/models/user/user.dart';
import 'package:flutter_crawl/models/user/user_cultivation.dart';
import 'package:flutter_crawl/resources/auth_repository.dart';
import 'package:flutter_crawl/resources/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_cultivation_state.dart';

class UserCultivationCubit extends Cubit<UserCultivationState> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  late final StreamSubscription<UserModel> _authSubscription;
  late final StreamSubscription<DatabaseEvent>? _userCultivationSubscription;

  UserCultivationCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : super(const UserCultivationInitial()) {
    _authRepository = authRepository;
    _userRepository = userRepository;
    _authSubscription = _authRepository.user.listen((authEvent) async {
      if (authEvent.isEmpty) {
        await _userRepository.updateTuLuyen();
        _userCultivationSubscription = null;

        listen();
      } else {
        _userCultivationSubscription = _userRepository
            .listenUserCultivation(uid: authEvent.id)
            ?.listen((userEvent) async {
          if (userEvent.snapshot.exists) {
            final data = userEvent.snapshot.value as Map;
            final json = Map<String, dynamic>.from(data);

            final cultivation = UserCultivationModel.fromJson(json);
            await _userRepository.updateTuLuyen(cultivation.idTuLuyen);

            listen(cultivation);
          } else {
            await _userRepository.updateTuLuyen("quocVuongVanTue");
            await _userRepository.setUserCultivation(uid: authEvent.id);
          }
        });
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _userCultivationSubscription?.cancel();
    return super.close();
  }

  void listen([UserCultivationModel? cultivation]) {
    if (_authRepository.currentUser != null && cultivation != null) {
      emit(UserCultivationInitial(cultivation: cultivation));
    } else {
      emit(const UserCultivationInitial());
    }
  }

  Future<void> update({
    required String idCanhGioi,
    required int tuVi,
    required int tuViTheo,
  }) async {
    if (_authRepository.currentUser != null) {
      await _userRepository.updateUserCultivation(
        uid: _authRepository.currentUser!.id,
        idCanhGioi: idCanhGioi,
        tuVi: tuVi,
        tuViTheo: tuViTheo,
      );
    }
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/user/user.dart';
import 'package:flutter_crawl/resources/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final AuthRepository _authRepository;
  late final StreamSubscription<UserModel> _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : super(AuthInitial(
            status: authRepository.currentUser == null
                ? AuthStatus.unauthenticated
                : AuthStatus.authenticated)) {
    on<AuthGoogle>((event, emit) async {
      try {
        await _authRepository
            .signInWithGoogle()
            .then((value) => event.callback());
      } catch (e) {
        emit(const AuthInitial(status: AuthStatus.unauthenticated));
      }
    });

    on<AuthOut>((event, emit) {
      unawaited(_authRepository.signOut());
    });

    on<AuthUserChanged>((event, emit) {
      emit(event.user.isNotEmpty
          ? AuthInitial(status: AuthStatus.authenticated, user: event.user)
          : const AuthInitial(status: AuthStatus.unauthenticated));
    });

    _authRepository = authRepository;
    _authSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

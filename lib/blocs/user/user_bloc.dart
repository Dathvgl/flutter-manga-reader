// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/manga/manga_chapter_image.dart';
import 'package:flutter_crawl/models/user/user.dart';
import 'package:flutter_crawl/models/user/user_follow_manga.dart';
import 'package:flutter_crawl/resources/auth_repository.dart';
import 'package:flutter_crawl/resources/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _userRepository = UserRepository();
  final _authRepository = AuthRepository();

  late final StreamSubscription<UserModel> _authSubscription;

  UserBloc() : super(UserInitial()) {
    on<GetUserFollowManga>((event, emit) async {
      final idToken = await _authRepository.currentUserIdToken;
      if (idToken != null && idToken.isNotEmpty) {
        final data = await _userRepository.getUserFollowManga(
          mangaId: event.mangaId,
          token: idToken,
          type: event.mangaType,
        );

        emit(UserFollowMangaState(
          model: data ?? UserFollowMangaModel.empty(),
        ));
      }
    });

    on<PutUserFollowManga>((event, emit) async {
      final idToken = await _authRepository.currentUserIdToken;
      if (idToken != null && idToken.isNotEmpty) {
        final data = await _userRepository.getUserFollowManga(
          mangaId: event.mangaId,
          token: idToken,
          type: event.mangaType,
        );

        emit(UserFollowMangaState(
          model: data != null
              ? UserFollowMangaModel(
                  id: data.id,
                  currentChapterId: event.currentChapterId,
                  lastestChapterId: data.lastestChapterId,
                  createdAt: data.createdAt,
                )
              : UserFollowMangaModel.empty(),
        ));

        if (data != null) {
          final current = event.chapters.firstWhere(
            (element) => element.id == event.currentChapterId,
            orElse: () => MangaChapterDetailModel.empty(),
          );

          final lastest = event.chapters.firstWhere(
            (element) => element.id == data.lastestChapterId,
            orElse: () => MangaChapterDetailModel.empty(),
          );

          await _userRepository.putUserFollowManga(
            id: event.mangaId,
            token: idToken,
            type: event.mangaType,
            replace:
                lastest.id == "" ? true : lastest.chapter < current.chapter,
            currentChapter: event.currentChapterId,
          );

          emit(UserFollowMangaState(
            model: UserFollowMangaModel(
              id: data.id,
              currentChapterId: event.currentChapterId,
              lastestChapterId: lastest.id == ""
                  ? event.currentChapterId
                  : lastest.chapter < current.chapter
                      ? current.id
                      : lastest.id,
              createdAt: data.createdAt,
            ),
          ));
        } else {
          emit(UserFollowMangaState(model: UserFollowMangaModel.empty()));
        }
      }
    });

    on<UserFollowMangaListen>((event, emit) async {
      final idToken = await _authRepository.currentUserIdToken;
      if (idToken != null && idToken.isNotEmpty) {
        if (event.isFollow) {
          await _userRepository.deleteUserFollowManga(
            id: event.id!,
            token: idToken,
            type: event.mangaType,
          );

          emit(UserFollowMangaState(model: UserFollowMangaModel.empty()));
        } else {
          await _userRepository.postUserFollowManga(
            mangaId: event.mangaId,
            token: idToken,
            type: event.mangaType,
          );

          final data = await _userRepository.getUserFollowManga(
            mangaId: event.mangaId,
            token: idToken,
            type: event.mangaType,
          );

          emit(UserFollowMangaState(
            model: data ?? UserFollowMangaModel.empty(),
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

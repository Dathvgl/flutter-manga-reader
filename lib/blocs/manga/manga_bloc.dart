// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/manga/manga_chapter.dart';
import 'package:flutter_crawl/models/manga/manga_chapter_image.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/models/manga/manga_list.dart';
import 'package:flutter_crawl/models/manga/manga_thumnail.dart';
import 'package:flutter_crawl/resources/manga_repository.dart';
import 'package:meta/meta.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final _repository = MangaRepository();

  MangaBloc() : super(MangaInitial()) {
    on<GetMangaList>((event, emit) async {
      try {
        emit(MangaLoading());
        final data = await _repository.getMangaList(type: event.type);
        emit(MangaListLoaded(data));
      } catch (e) {
        emit(MangaError("Failed to fetch data. is your device online?"));
      }
    });

    on<GetMangaThumnail>((event, emit) async {
      try {
        emit(MangaLoading());

        final data = await _repository.getMangaThumnail(
          id: event.id,
          type: event.type,
        );

        emit(MangaThumnailLoaded(data));
      } catch (e) {
        emit(MangaError("Failed to fetch data. is your device online?"));
      }
    });

    on<GetMangaDetail>((event, emit) async {
      try {
        emit(MangaLoading());

        final data = await _repository.getMangaDetail(
          id: event.id,
          type: event.type,
        );

        emit(MangaDetailLoaded(data));
      } catch (e) {
        emit(MangaError("Failed to fetch data. is your device online?"));
      }
    });

    on<GetMangaChapter>((event, emit) async {
      try {
        emit(MangaLoading());

        final data = await _repository.getMangaDetailChapter(
          id: event.id,
          type: event.type,
        );

        emit(MangaChapterLoaded(data));
      } catch (e) {
        emit(MangaError("Failed to fetch data. is your device online?"));
      }
    });

    on<GetMangaChapterImage>((event, emit) async {
      try {
        emit(MangaLoading());

        final data = await _repository.getMangaDetailChapterImage(
          detailId: event.detailId,
          chapterId: event.chapterId,
          type: event.type,
        );

        emit(MangaChapterImageLoaded(data));
      } catch (e) {
        emit(MangaError("Failed to fetch data. is your device online?"));
      }
    });
  }
}

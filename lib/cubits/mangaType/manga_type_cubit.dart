// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:meta/meta.dart';

part 'manga_type_state.dart';

class MangaTypeCubit extends Cubit<MangaTypeState> {
  MangaTypeCubit() : super(const MangaTypeInitial(type: MangaTypes.blogtruyen));
  void listen(MangaTypes type) => emit(MangaTypeInitial(type: type));
}

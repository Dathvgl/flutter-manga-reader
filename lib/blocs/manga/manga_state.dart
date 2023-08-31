part of 'manga_bloc.dart';

@immutable
sealed class MangaState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class MangaInitial extends MangaState {}

final class MangaLoading extends MangaState {}

final class MangaListLoaded extends MangaState {
  final MangaListModel model;
  MangaListLoaded(this.model);
}

final class MangaThumnailLoaded extends MangaState {
  final MangaThumnailModel model;
  MangaThumnailLoaded(this.model);
}

final class MangaDetailLoaded extends MangaState {
  final MangaDetailModel model;
  MangaDetailLoaded(this.model);
}

final class MangaChapterLoaded extends MangaState {
  final List<MangaChapterModel> model;
  MangaChapterLoaded(this.model);
}

final class MangaChapterImageLoaded extends MangaState {
  final MangaChapterImageModel model;
  MangaChapterImageLoaded(this.model);
}

final class MangaError extends MangaState {
  final String? message;
  MangaError(this.message);
}

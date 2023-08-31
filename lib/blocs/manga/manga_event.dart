part of 'manga_bloc.dart';

@immutable
sealed class MangaEvent {
  final MangaTypes type;
  const MangaEvent({required this.type});
}

final class GetMangaList extends MangaEvent {
  const GetMangaList({required super.type});
}

final class GetMangaThumnail extends MangaEvent {
  final String id;

  const GetMangaThumnail({
    required this.id,
    required super.type,
  });
}

final class GetMangaDetail extends MangaEvent {
  final String id;

  const GetMangaDetail({
    required this.id,
    required super.type,
  });
}

final class GetMangaChapter extends MangaEvent {
  final String id;

  const GetMangaChapter({
    required this.id,
    required super.type,
  });
}

final class GetMangaChapterImage extends MangaEvent {
  final String detailId;
  final String chapterId;

  const GetMangaChapterImage({
    required this.detailId,
    required this.chapterId,
    required super.type,
  });
}

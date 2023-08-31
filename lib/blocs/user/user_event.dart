part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class GetUserFollowManga extends UserEvent {
  final String mangaId;
  final MangaTypes mangaType;

  GetUserFollowManga({
    required this.mangaId,
    required this.mangaType,
  });
}

final class PutUserFollowManga extends UserEvent {
  final String mangaId;
  final MangaTypes mangaType;
  final String currentChapterId;
  final List<MangaChapterDetailModel> chapters;

  PutUserFollowManga({
    required this.mangaId,
    required this.mangaType,
    required this.currentChapterId,
    required this.chapters,
  });
}

final class UserFollowMangaListen extends UserEvent {
  final String? id;
  final bool isFollow;
  final String mangaId;
  final MangaTypes mangaType;

  UserFollowMangaListen({
    this.id,
    required this.isFollow,
    required this.mangaId,
    required this.mangaType,
  });
}

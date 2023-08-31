part of 'user_bloc.dart';

@immutable
sealed class UserState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class UserInitial extends UserState {}

final class UserFollowMangaState extends UserState {
  final UserFollowMangaModel model;
  UserFollowMangaState({required this.model});
}

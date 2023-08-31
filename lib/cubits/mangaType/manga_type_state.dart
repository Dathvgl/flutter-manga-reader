part of 'manga_type_cubit.dart';

@immutable
sealed class MangaTypeState extends Equatable {
  final MangaTypes type;
  const MangaTypeState({required this.type});

  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class MangaTypeInitial extends MangaTypeState {
  const MangaTypeInitial({required super.type});
}

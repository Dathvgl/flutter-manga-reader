part of 'user_cultivation_cubit.dart';

@immutable
sealed class UserCultivationState extends Equatable {
  final UserCultivationModel cultivation;
  const UserCultivationState({required this.cultivation});

  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class UserCultivationInitial extends UserCultivationState {
  const UserCultivationInitial({super.cultivation = const UserCultivationModel.empty()});
}
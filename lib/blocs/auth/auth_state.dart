part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  final UserModel user;
  final AuthStatus status;

  const AuthState({
    required this.status,
    this.user = UserModel.empty,
  });

  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class AuthInitial extends AuthState {
  const AuthInitial({
    required super.status,
    super.user,
  });
}

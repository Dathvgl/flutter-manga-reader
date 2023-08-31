part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthGoogle extends AuthEvent {
  final VoidCallback callback;
  AuthGoogle({required this.callback});
}

class AuthOut extends AuthEvent {}

final class AuthUserChanged extends AuthEvent {
  final UserModel user;
  AuthUserChanged(this.user);
}

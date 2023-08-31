part of 'theme_cubit.dart';

@immutable
sealed class ThemeState extends Equatable {
  final bool theme;
  final ThemeData useTheme;

  const ThemeState({
    required this.theme,
    required this.useTheme,
  });

  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial({
    required super.theme,
    required super.useTheme,
  });
}

// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

final _lightTheme = ThemeData.light(useMaterial3: true);
final _darkTheme = ThemeData.dark(useMaterial3: true);

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial(theme: false, useTheme: _lightTheme));

  void listen(bool theme) => emit(ThemeInitial(
        theme: theme,
        useTheme: theme ? _darkTheme : _lightTheme,
      ));
}

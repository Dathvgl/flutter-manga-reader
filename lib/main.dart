import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/auth/auth_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/cubits/cultivation/cultivation_cubit.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/cubits/theme/theme_cubit.dart';
import 'package:flutter_crawl/cubits/userCultivation/user_cultivation_cubit.dart';
import 'package:flutter_crawl/firebase_options.dart';
import 'package:flutter_crawl/resources/auth_repository.dart';
import 'package:flutter_crawl/resources/user_repository.dart';
import 'package:flutter_crawl/router.dart';

import 'models/tuTien/tu_tien.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "crawlStorage",
  );

  final tuTiens = await _initCultivation();

  runApp(MyApp(tuTiens: tuTiens));
}

Future<List<TuTienModel>> _initCultivation() async {
  final json = await rootBundle.loadString("assets/jsons/tuTien.json");
  return (jsonDecode(json) as List)
      .map((e) => TuTienModel.fromJson(e))
      .toList();
}

class MyApp extends StatelessWidget {
  final List<TuTienModel> tuTiens;

  MyApp({
    super.key,
    required this.tuTiens,
  });

  final _router = GoRouterDart.router;

  final _authRepository = AuthRepository();
  final _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    _userRepository.tuTiens = tuTiens;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _authRepository),
        RepositoryProvider(create: (context) => _userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CultivationCubit(tuTiens: tuTiens)),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => MangaTypeCubit()),
          BlocProvider(create: (context) {
            return AuthBloc(authRepository: _authRepository);
          }),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) {
            return UserCultivationCubit(
              authRepository: _authRepository,
              userRepository: _userRepository,
            );
          }),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "Flutter Demo",
              builder: (context, child) {
                return SafeArea(child: child ?? const SizedBox());
              },
              theme: state.useTheme,
              routerDelegate: _router.routerDelegate,
              routeInformationParser: _router.routeInformationParser,
              routeInformationProvider: _router.routeInformationProvider,
            );
          },
        ),
      ),
    );
  }
}

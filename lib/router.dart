import 'package:flutter/material.dart';
import 'package:flutter_crawl/pages/auth_page.dart';
import 'package:flutter_crawl/pages/home_page.dart';
import 'package:flutter_crawl/pages/mangaChapter/manga_chapter_page.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_page.dart';
import 'package:flutter_crawl/pages/setting_page.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

abstract class GoRouterDart {
  static final router = GoRouter(
    initialLocation: "/",
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: "/",
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "auth",
            builder: (context, state) => const AuthPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "setting",
            builder: (context, state) => const SettingPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: "manga",
            builder: (context, state) => const SizedBox(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "detail/:id",
                builder: (context, state) => MangaDetailPage(
                  id: state.pathParameters["id"],
                ),
              ),
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "chapter/:detailId/:chapterId",
                builder: (context, state) => MangaChapterPage(
                  detailId: state.pathParameters["detailId"],
                  chapterId: state.pathParameters["chapterId"],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

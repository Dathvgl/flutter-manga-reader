import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/auth/auth_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/components/shimmer.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_item.dart';

class MangaDetailBuildInherited extends InheritedWidget {
  final String id;
  final MangaDetailModel model;

  const MangaDetailBuildInherited({
    super.key,
    required super.child,
    required this.id,
    required this.model,
  });

  static MangaDetailBuildInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MangaDetailBuildInherited>();
  }

  @override
  bool updateShouldNotify(MangaDetailBuildInherited oldWidget) {
    return false;
  }
}

class MangaDetailBuild extends StatelessWidget {
  final String id;

  const MangaDetailBuild({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaBloc, MangaState>(
      builder: (context, mangaState) {
        switch (mangaState.runtimeType) {
          case MangaDetailLoaded:
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState.status == AuthStatus.authenticated) {
                  context.read<UserBloc>().add(GetUserFollowManga(
                        mangaId: id,
                        mangaType: context.read<MangaTypeCubit>().state.type,
                      ));
                }

                return MangaDetailBuildInherited(
                  id: id,
                  model: (mangaState as MangaDetailLoaded).model,
                  child: const MangaDetailItem(),
                );
              },
            );
          case MangaInitial:
          case MangaLoading:
          default:
            return const Padding(
              padding: EdgeInsets.all(16),
              child: CustomShimmer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomShimmerLine(),
                    SizedBox(height: 10),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomShimmerBox(),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomShimmerLine(),
                                SizedBox(height: 10),
                                CustomShimmerLine(),
                                SizedBox(height: 10),
                                CustomShimmerLine(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    CustomShimmerBox(),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}

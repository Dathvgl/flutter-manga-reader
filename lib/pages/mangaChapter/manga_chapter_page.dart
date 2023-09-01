import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/auth/auth_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/components/scaffold.dart';
import 'package:flutter_crawl/components/shimmer.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/manga/manga_chapter_image.dart';
import 'package:flutter_crawl/pages/mangaChapter/manga_chapter_end_drawer.dart';
import 'package:flutter_crawl/pages/mangaChapter/manga_chapter_item.dart';
import 'package:go_router/go_router.dart';

class MangaChapterPage extends StatelessWidget {
  final String? detailId;
  final String? chapterId;

  const MangaChapterPage({
    super.key,
    this.detailId,
    this.chapterId,
  });

  Widget _body({
    required String detailId,
    required MangaChapterImageModel model,
  }) {
    return MangaChapterItem(
      detailId: detailId,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (detailId == null || chapterId == null) {
      return const Center(
        child: Text("Manga chapter not found"),
      );
    } else {
      return BlocProvider(
        create: (context) => MangaBloc()
          ..add(GetMangaChapterImage(
            detailId: detailId!,
            chapterId: chapterId!,
            type: context.read<MangaTypeCubit>().state.type,
          )),
        child: BlocBuilder<MangaBloc, MangaState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case MangaChapterImageLoaded:
                final model = (state as MangaChapterImageLoaded).model;

                final status = context.read<AuthBloc>().state.status;
                if (status == AuthStatus.authenticated) {
                  context.read<UserBloc>().add(PutUserFollowManga(
                        mangaId: detailId!,
                        mangaType: context.read<MangaTypeCubit>().state.type,
                        currentChapterId: chapterId!,
                        chapters: model.chapters,
                      ));
                }

                return CustomScaffold(
                  endDrawer: MangaChapterEndDrawer(
                    detailId: detailId!,
                    chapterId: chapterId!,
                    chapters: model.chapters,
                  ),
                  endDrawerEnableOpenDragGesture: true,
                  body: _body(
                    detailId: detailId!,
                    model: model,
                  ),
                );
              case MangaInitial:
              case MangaLoading:
              default:
                return CustomScaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          height: AppBar().preferredSize.height,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => context.pop(),
                                child: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(width: 32),
                              const Expanded(
                                child: Text(
                                  "Loading...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomShimmerBox(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      );
    }
  }
}

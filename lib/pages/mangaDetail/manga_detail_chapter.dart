import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/components/shimmer.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/extensions/double.dart';
import 'package:flutter_crawl/extensions/int.dart';
import 'package:flutter_crawl/models/manga/manga_chapter.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/models/user/user_follow_manga.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_build.dart';
import 'package:go_router/go_router.dart';

class MangaDetailItemChapter extends StatefulWidget {
  const MangaDetailItemChapter({super.key});

  @override
  State<MangaDetailItemChapter> createState() => _MangaDetailItemChapterState();
}

class _MangaDetailItemChapterState extends State<MangaDetailItemChapter>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final inherited = MangaDetailBuildInherited.of(context) ??
        MangaDetailBuildInherited(
          id: "",
          model: MangaDetailModel.empty(),
          child: const SizedBox(),
        );

    return BlocBuilder<MangaTypeCubit, MangaTypeState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MangaBloc()
            ..add(GetMangaChapter(
              id: inherited.id,
              type: state.type,
            )),
          child: BlocBuilder<MangaBloc, MangaState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case MangaChapterLoaded:
                  final model = (state as MangaChapterLoaded).model;
                  return MangaDetailItemChapterDetail(model: model);
                case MangaInitial:
                case MangaLoading:
                default:
                  return const CustomShimmer(
                    child: CustomShimmerBox(),
                  );
              }
            },
          ),
        );
      },
    );
  }
}

class MangaDetailItemChapterDetail extends StatelessWidget {
  final List<MangaChapterModel> model;

  const MangaDetailItemChapterDetail({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        UserFollowMangaModel? follow;

        if (userState.runtimeType == UserFollowMangaState) {
          final model = (userState as UserFollowMangaState).model;
          follow = model.id.isEmpty ? null : model;
        }

        return MangaDetailItemChapterDetailItem(
          follow: follow,
          model: model,
        );
      },
    );
  }
}

class MangaDetailItemChapterDetailItem extends StatelessWidget {
  final UserFollowMangaModel? follow;
  final List<MangaChapterModel> model;

  const MangaDetailItemChapterDetailItem({
    super.key,
    this.follow,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final inherited = MangaDetailBuildInherited.of(context) ??
        MangaDetailBuildInherited(
          id: "",
          model: MangaDetailModel.empty(),
          child: const SizedBox(),
        );

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 3,
      ),
      itemCount: model.length,
      itemBuilder: (context, index) {
        final item = model[index];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runAlignment: WrapAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => context
                          .push("/manga/chapter/${inherited.id}/${item.id}"),
                      child: Text(
                        item.chapter.chapterManga(true),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (follow != null) ...[
                      if (follow?.lastestChapterId == item.id) ...[
                        const Icon(Icons.star, color: Colors.red),
                      ],
                      if (follow?.currentChapterId == item.id &&
                          follow?.lastestChapterId != item.id) ...[
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.watched.humanCompact()),
                    Text(
                      item.time.timestampMilli(),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

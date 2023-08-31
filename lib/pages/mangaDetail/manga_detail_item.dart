import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/components/manga_thumnail.dart';
import 'package:flutter_crawl/extensions/int.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/models/user/user_follow_manga.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_build.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_follow.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_tab.dart';
import 'package:go_router/go_router.dart';

class MangaDetailItem extends StatelessWidget {
  const MangaDetailItem({super.key});

  List<Widget> info(String mangaId, MangaDetailModel model) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: MangaThumnail(
                    id: model.id,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    runSpacing: 12,
                    children: [
                      if (model.altTitle != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.auto_stories),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "${model.altTitle}\n",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (model.authors.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                model.authors.map((e) => e.name).join(", "),
                              ),
                            ),
                          ],
                        ),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.menu_book),
                          const SizedBox(width: 12),
                          Text(model.status),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.screenshot_monitor),
                          const SizedBox(width: 12),
                          Text(model.watched.humanCompact()),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(width: 12),
                          Text(model.followed.humanCompact()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Wrap(
          spacing: 8,
          children: model.tags.map((e) {
            return ActionChip(
              label: Text(e.name),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              onPressed: () {},
            );
          }).toList(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 16,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Read first",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Read last",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const MangaDetailFollow(),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  UserFollowMangaModel? follow;

                  if (userState.runtimeType == UserFollowMangaState) {
                    final model = (userState as UserFollowMangaState).model;
                    follow = model.id.isEmpty ? null : model;
                  }

                  if (follow == null) {
                    return const SizedBox();
                  } else {
                    return InkWell(
                      onTap: () => context.push(
                          "/manga/chapter/$mangaId/${follow?.currentChapterId}"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final inherited = MangaDetailBuildInherited.of(context) ??
        MangaDetailBuildInherited(
          id: "",
          model: MangaDetailModel.empty(),
          child: const SizedBox(),
        );

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ...info(inherited.id, inherited.model),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedTabControl(
                      selectedTabTextColor: Colors.white70,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      tabs: const [
                        SegmentTab(
                          label: "Description",
                          color: Colors.blue,
                          textColor: Colors.black,
                        ),
                        SegmentTab(
                          label: "Chapters",
                          color: Colors.green,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    height: 0,
                    thickness: 3,
                    color: Colors.blue,
                  ),
                ],
              ),
            )
          ];
        },
        body: const MangaDetailItemTabView(),
      ),
    );
  }
}

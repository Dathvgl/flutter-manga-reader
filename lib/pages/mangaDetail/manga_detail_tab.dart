import 'package:flutter/material.dart';
import 'package:flutter_crawl/models/manga/manga_detail.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_build.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_chapter.dart';

class MangaDetailItemTabView extends StatefulWidget {
  const MangaDetailItemTabView({super.key});

  @override
  State<MangaDetailItemTabView> createState() => _MangaDetailItemTabViewState();
}

class _MangaDetailItemTabViewState extends State<MangaDetailItemTabView>
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

    return TabBarView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            inherited.model.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const MangaDetailItemChapter(),
      ],
    );
  }
}

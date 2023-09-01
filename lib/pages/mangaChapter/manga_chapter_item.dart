import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/user/user_bloc.dart';
import 'package:flutter_crawl/components/image.dart';
import 'package:flutter_crawl/cubits/userCultivation/user_cultivation_cubit.dart';
import 'package:flutter_crawl/extensions/double.dart';
import 'package:flutter_crawl/models/manga/manga_chapter_image.dart';
import 'package:flutter_crawl/models/user/user_follow_manga.dart';
import 'package:go_router/go_router.dart';

class MangaChapterItem extends StatefulWidget {
  final String detailId;
  final MangaChapterImageModel model;

  const MangaChapterItem({
    super.key,
    required this.detailId,
    required this.model,
  });

  @override
  State<MangaChapterItem> createState() => _MangaChapterItemState();
}

class _MangaChapterItemState extends State<MangaChapterItem> {
  final _controller = ScrollController();
  final _heightBar = AppBar().preferredSize.height;

  final _visible = ValueNotifier<bool>(true);
  final _scroll = ValueNotifier<bool>(true);

  late final List<MangaChapterCurrentImageModel> _images;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final scrollOffset = _controller.offset;
      final maxScrollHeight = _controller.position.maxScrollExtent;

      if (scrollOffset > _heightBar &&
          scrollOffset < maxScrollHeight - _heightBar) {
        _visible.value = false;
        _scroll.value = false;
      }

      if (scrollOffset <= _heightBar ||
          scrollOffset >= maxScrollHeight - _heightBar) {
        _visible.value = true;
        _scroll.value = true;
      }
    });

    final state = context.read<UserCultivationCubit>().state;
    context.read<UserCultivationCubit>().update(
          idCanhGioi: state.cultivation.idCanhGioi,
          tuVi: state.cultivation.tuVi,
          tuViTheo: 1,
        );

    _images = widget.model.current?.chapters ?? [];
  }

  @override
  void dispose() {
    _visible.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget header({
    required String detailId,
    required MangaChapterImageModel model,
  }) {
    return Positioned(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: _heightBar,
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          children: [
            InkWell(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Text(
                model.current?.chapter.chapterManga(true) ??
                    "Chapter not found",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(width: 32),
            InkWell(
              onTap: () => context.pushReplacement("/manga/detail/$detailId"),
              child: const Icon(Icons.info),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: const Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }

  Widget footer({
    UserFollowMangaModel? follow,
    required String detailId,
    required MangaChapterImageModel model,
  }) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: _heightBar,
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            children: [
              TextButton(
                onPressed: model.canPrev == null
                    ? null
                    : () => context.pushReplacement(
                        "/manga/chapter/$detailId/${model.canPrev?.id}"),
                child: const Text(
                  "Prev",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: model.canNext == null
                    ? null
                    : () => context.pushReplacement(
                        "/manga/chapter/$detailId/${model.canNext?.id}"),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Stack(
        children: [
          InteractiveViewer(
            child: GestureDetector(
              onTap: () {
                if (!_scroll.value) {
                  _visible.value = !_visible.value;
                }
              },
              child: ListView.builder(
                controller: _controller,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final item = _images[index];

                  if (index == 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: AppBar().preferredSize.height),
                        ImageAutoHeight(
                          url: item.src,
                        ),
                      ],
                    );
                  }

                  if (index == _images.length - 1) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageAutoHeight(
                          url: item.src,
                        ),
                        SizedBox(height: AppBar().preferredSize.height),
                      ],
                    );
                  }

                  return ImageAutoHeight(
                    url: item.src,
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _visible,
            builder: (BuildContext context, value, Widget? child) {
              return Visibility(
                visible: value,
                child: header(
                  detailId: widget.detailId,
                  model: widget.model,
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: _visible,
            builder: (BuildContext context, value, Widget? child) {
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  UserFollowMangaModel? follow;

                  if (state.runtimeType == UserFollowMangaState) {
                    final model = (state as UserFollowMangaState).model;
                    follow = model.id.isEmpty ? null : model;
                  }

                  return Visibility(
                    visible: value,
                    child: footer(
                      detailId: widget.detailId,
                      model: widget.model,
                      follow: follow,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

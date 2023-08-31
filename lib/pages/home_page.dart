import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/components/manga_dialog.dart';
import 'package:flutter_crawl/components/manga_thumnail.dart';
import 'package:flutter_crawl/components/scaffold.dart';
import 'package:flutter_crawl/components/shimmer.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/extensions/double.dart';
import 'package:flutter_crawl/extensions/int.dart';
import 'package:flutter_crawl/models/manga/manga_list.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<MangaTypeCubit, MangaTypeState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => MangaBloc()
              ..add(GetMangaList(
                type: state.type,
              )),
            child: BlocBuilder<MangaBloc, MangaState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case MangaListLoaded:
                    return HomeList(
                      model: (state as MangaListLoaded).model,
                    );
                  case MangaInitial:
                  case MangaLoading:
                  default:
                    return AlignedGridView.count(
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                      crossAxisCount: 2,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const CustomShimmer(
                          child: Column(
                            children: [
                              CustomShimmerBox(),
                              SizedBox(height: 10),
                              CustomShimmerLine(),
                              SizedBox(height: 10),
                              CustomShimmerLine(),
                            ],
                          ),
                        );
                      },
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class HomeList extends StatelessWidget {
  final MangaListModel model;

  const HomeList({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 16,
      crossAxisCount: 2,
      itemCount: model.data.length,
      itemBuilder: (context, index) {
        final item = model.data[index];
        return HomeItem(item: item);
      },
    );
  }
}

class HomeItem extends StatelessWidget {
  final MangaListDetailModel item;

  const HomeItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => context.push("/manga/detail/${item.id}"),
              onLongPress: () => showDialog(
                context: context,
                builder: (context) => MangaDialog(item: item),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MangaThumnail(
                    id: item.id,
                    height: 180,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Text(
                      "${item.title}\n",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 8,
                right: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: item.chapters.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context.push("/manga/chapter/${item.id}/${e.id}");
                        },
                        child: Text(
                          e.chapter.chapterManga(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        e.time.timestampMilli(),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

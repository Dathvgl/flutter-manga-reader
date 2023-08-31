import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/components/scaffold.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/pages/mangaDetail/manga_detail_build.dart';
import 'package:go_router/go_router.dart';

class MangaDetailPage extends StatelessWidget {
  final String? id;

  const MangaDetailPage({
    super.key,
    this.id,
  });

  Widget nullCheck() {
    if (id is String) {
      return BlocBuilder<MangaTypeCubit, MangaTypeState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => MangaBloc()
              ..add(GetMangaDetail(
                id: id!,
                type: state.type,
              )),
            child: MangaDetailBuild(id: id!),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          "Manga not found",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: nullCheck(),
    );
  }
}

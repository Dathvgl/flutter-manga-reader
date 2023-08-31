import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/manga/manga_bloc.dart';
import 'package:flutter_crawl/components/shimmer.dart';
import 'package:flutter_crawl/cubits/mangaType/manga_type_cubit.dart';
import 'package:flutter_crawl/models/manga/manga_thumnail.dart';

class MangaThumnail extends StatelessWidget {
  final String id;
  final double? height;
  final BoxFit? fit;

  const MangaThumnail({
    super.key,
    required this.id,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaTypeCubit, MangaTypeState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MangaBloc()
            ..add(GetMangaThumnail(
              id: id,
              type: state.type,
            )),
          child: BlocBuilder<MangaBloc, MangaState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case MangaThumnailLoaded:
                  final model = (state as MangaThumnailLoaded).model;
                  return MangaThumnailDetail(
                    height: height,
                    fit: fit,
                    model: model,
                  );
                case MangaInitial:
                case MangaLoading:
                default:
                  return SizedBox(
                    height: height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}

class MangaThumnailDetail extends StatelessWidget {
  final double? height;
  final BoxFit? fit;
  final MangaThumnailModel model;

  const MangaThumnailDetail({
    super.key,
    this.height,
    this.fit,
    required this.model,
  });

  Future<Size> _imageSize(String url) async {
    Completer<Size> completer = Completer();
    Image provider = Image(image: CachedNetworkImageProvider(url));

    provider.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );

    return completer.future;
  }

  Widget _loading() {
    return CustomShimmer(
      child: CustomShimmerBox(
        height: height,
      ),
    );
  }

  Widget _detailWidget(ImageProvider<Object> imageProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    );
  }

  Widget _detailThumnail(Size? size) {
    return CachedNetworkImage(
      height: height,
      imageUrl: model.src,
      imageBuilder: (context, imageProvider) {
        final child = _detailWidget(imageProvider);

        if (height != null) {
          return child;
        } else {
          if (size == null) return child;

          return AspectRatio(
            aspectRatio: size.aspectRatio,
            child: child,
          );
        }
      },
      placeholder: (context, url) => SizedBox(
        height: height,
        child: _loading(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return height != null
        ? _detailThumnail(null)
        : FutureBuilder(
            future: _imageSize(model.src),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return _loading();
                case ConnectionState.done:
                case ConnectionState.active:
                default:
                  if (snapshot.hasData) {
                    final size = snapshot.data!;
                    return _detailThumnail(size);
                  } else {
                    return _loading();
                  }
              }
            },
          );
  }
}

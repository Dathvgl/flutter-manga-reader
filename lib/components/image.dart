import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageAutoHeight extends StatelessWidget {
  final String url;

  const ImageAutoHeight({
    super.key,
    required this.url,
  });

  Future<Size> _imageSize() async {
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

  Widget _detailImage(Size size) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return AspectRatio(
          aspectRatio: size.aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return CircularProgressIndicator(value: downloadProgress.progress);
      },
      errorWidget: (context, url, error) => Container(
        height: 50,
        color: Colors.red.shade800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageSize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
          case ConnectionState.active:
          default:
            if (snapshot.hasData) {
              final size = snapshot.data!;
              return _detailImage(size);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class VideoSign extends StatelessWidget {
  final double signLanguageDimension;
  final ImageProvider? imageProvider;

  const VideoSign({
    super.key,
    required this.signLanguageDimension,
    this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: signLanguageDimension,
      height: signLanguageDimension,
      child: imageProvider != null
          ? GifView(
              image: imageProvider!,
            )
          : const SizedBox(),
    );
  }
}

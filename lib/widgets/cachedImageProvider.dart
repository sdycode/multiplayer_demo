// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CachedImageWidget extends StatelessWidget {
  final String image;

  final double width;
  final double height;
  final Color? circleColor;
  final double padding;
  final BoxFit fit;
  final double rad;
  final Widget? errorWidget;
  const CachedImageWidget({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
    this.circleColor,
    this.padding = 10,
    this.fit = BoxFit.fill,
    this.rad = 12,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: CachedNetworkImage(
        imageUrl: image,
        width: width,
        height: height,
        placeholder: (context, url) => CircularProgressIndicator(
          color: circleColor ?? Theme.of(context).primaryColor,
        ),
        fit: fit,
        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(seconds: 2),
        fadeOutCurve: Curves.easeOut,
        fadeOutDuration: const Duration(seconds: 2),
        errorWidget: (context, url, error) => errorWidget != null
            ? errorWidget!
            : Icon(
                Icons.image_not_supported_rounded,
                size: width * 0.4,
              ),
      ),
    );
  }
}

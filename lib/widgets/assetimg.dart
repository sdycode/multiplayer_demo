// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';

class AssetImgSizeWidget extends StatelessWidget {
  final String img;
  final double size;
  final BoxFit fit;
  final Color? color;
  final VoidCallback? onTap;
  final double roundRadius;
  const AssetImgSizeWidget({
    Key? key,
    this.img = "",
    this.size = 50,
    this.fit = BoxFit.contain,
    this.color,
    this.onTap,
    this.roundRadius = 0,
  }) : super(key: key);
  const AssetImgSizeWidget.tap({
    Key? key,
    this.img = "",
    this.size = 50,
    this.fit = BoxFit.contain,
    this.color,
    required this.onTap,
    this.roundRadius = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: _child())
        : _child();
  }

  Widget _child() {
    return Container(
      width: size,
      height: size,
      child: Image.asset(
        img,
        fit: fit,
        color: color,
      ),
    );
  }
}

class AssetImgRectWidget extends StatelessWidget {
  final String img;
  final double w;
  final double h;
  final BoxFit fit;
  final double pad;
  final Widget? child;
  final VoidCallback? onTap;
  final double roundRadius;
  final Color? color;
  const AssetImgRectWidget({
    Key? key,
    required this.img,
    this.w = 50,
    this.h = 50,
    this.fit = BoxFit.contain,
    this.pad = 0,
    this.child,
    this.onTap,
    this.roundRadius = 0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? _child()
        : InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: _child());
  }

  Widget _child() {
    return Container(
      width: w.abs(),
      height: h.abs(),
      constraints: BoxConstraints(maxHeight: h.abs(), maxWidth: w.abs()),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            img,
            fit: fit,
            color: color,
          ).paddingWidget(pad: pad),
          if (child != null) child!
        ],
      ).clipRoundToWidget(rad: roundRadius),
    );
  }
}

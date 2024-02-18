import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';

extension WidgetModify on Widget {
  Widget expnd({bool isExpand = true}) {
    return isExpand
        ? Expanded(
            child: this,
          )
        : this;
  }

  Widget leftAlignWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: this,
    );
  }

  Widget rightAlignWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: this,
    );
  }

  Widget scrollRowWidget({bool scroll = true}) {
    return scroll
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: this,
          )
        : this;
  }

  Widget scrollColumnWidget({bool scroll = true}) {
    return scroll
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: this,
          )
        : this;
  }

  Widget clipRoundToWidget({double rad = 12}) {
    return ClipRRect(
      borderRadius: rad.borderRadiusCircular(),
      child: this,
    );
  }

  Widget toprightAlignWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: this,
    );
  }

  Widget bottomLeftAlignWidget() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: this,
    );
  }

  Widget alignCenterWidget() {
    return Align(
      alignment: Alignment.center,
      child: this,
    );
  }

  Widget scaleWidget({double? s = 1.2}) {
    return Transform.scale(
      scale: s,
      child: this,
    );
  }

  Widget scaleXYWidget({double x = 1, double y = 1}) {
    return Transform.scale(
      scaleX: x,
      scaleY: y,
      child: this,
    );
  }

  Widget addBulletWidget({Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: color ?? Colors.white,
        ).paddingWidget(pad: 12),
        Expanded(child: this)
      ],
    );
  }

  Widget maxWidthForWidget(double maxW) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxW,
      ),
      child: this,
    );
  }

  Widget maxHeightForWidget(double maxH) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxH,
      ),
      child: this,
    );
  }

  Widget minWidthForWidget(double minW) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minW,
      ),
      child: this,
    );
  }

  Widget minHForWidget(double mihH) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: mihH,
      ),
      child: this,
    );
  }

  Widget minmaxHeightForWidget(double minH, double maxH) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minH,
        maxHeight: maxH,
      ),
      child: this,
    );
  }

  Widget widthOfWidget(double maxW) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW, minWidth: maxW),
      child: this,
    );
  }

  Widget heightOfWidget(double hei) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: hei, maxHeight: hei),
      child: this,
    );
  }

  Widget boxAroundWidget(double w, double h, {Alignment? alignment}) {
    return Container(
      width: w.abs(),
      height: h.abs(),
      alignment: alignment ?? Alignment.center,
      child: this,
    );
  }

  Widget topPadding({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.only(top: pad),
      child: this,
    );
  }

  Widget topNotchPadding(BuildContext context) {
    return Padding(
      padding: context.notchPadding(),
      child: this,
    );
  }

  Widget paddingWidget({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.all(pad),
      child: this,
    );
  }

  Widget verticalPadding({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: this,
    );
  }

  Widget bottomPadding({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: this,
    );
  }

  Widget leftPadding({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.only(left: pad),
      child: this,
    );
  }

  Widget rightPadding({double pad = 8}) {
    return Padding(
      padding: EdgeInsets.only(right: pad),
      child: this,
    );
  }

  Widget symmetricPadding({double horz = 18, double vert = 8}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horz, vertical: vert),
      child: this,
    );
  }

  Widget horzPadding({double horz = 12, double vert = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horz, vertical: vert),
      child: this,
    );
  }

  Widget onlyLeftRightPadding({double left = 0, double right = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: this,
    );
  }

  Widget vertPadding({double vert = 8}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: vert),
      child: this,
    );
  }

  Widget ignoreWidget({bool ignore = true}) {
    return IgnorePointer(
      child: this,
      ignoring: ignore,
    );
  }

  Widget withOpacity({double opacityValue = 1}) {
    return Opacity(
      child: this,
      opacity: opacityValue,
    );
  }

  Widget opaqueWithIgnore({double opacityValue = 0.5, bool ignore = true}) {
    return this
        .ignoreWidget(ignore: ignore)
        .withOpacity(opacityValue: ignore ? opacityValue : 1);
  }

  Widget hideWidget({bool hide = true}) {
    return Opacity(
      child: this,
      opacity: 0,
    );
  }

  Widget lableAbove(
      {required Widget lable,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [lable, this],
    ).verticalPadding(pad: vertPading);
  }

  Widget lableBelow(
      {required Widget lable,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        lable,
      ],
    ).verticalPadding(pad: vertPading);
  }

  Widget addToLeft(
      {required Widget? widget,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return widget == null
        ? this
        : Row(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [widget, this],
          ).verticalPadding(pad: vertPading);
  }

  Widget addToRight(
      {required Widget? widget,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return widget == null
        ? this
        : Row(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              this,
              widget,
            ],
          ).verticalPadding(pad: vertPading);
  }

  Widget addAbove(
      {required Widget widget,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [widget, this],
    ).verticalPadding(pad: vertPading);
  }

  Widget addBelow(
      {required Widget widget,
      CrossAxisAlignment? crossAxisAlignment,
      double vertPading = 6}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        widget,
      ],
    ).verticalPadding(pad: vertPading);
  }

  Widget colorBoxWidget({
    Color color = const Color(0xff0058A8),
  }) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: 12.borderRadiusCircular(),
      ),
      child: this,
    );
  }

  Widget borderedColorBoxWidget({
    Color borderColor = Colors.black,
    Color bgcolor = Colors.transparent,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: 12.borderRadiusCircular(),
          border: Border.all(color: borderColor, width: 1.5)),
      child: this,
    );
  }

  Widget borderedBoxWidget({double pad = 8}) {
    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: 12.borderRadiusCircular(),
          border: Border.all(
              color: const Color(0xff0058A8).withAlpha(100), width: 2)),
      child: this,
    );
  }

  Widget coloredBoxWidget(
      {Color color = Colors.white, double rad = 0, double pad = 8}) {
    return Container(
      padding: EdgeInsets.all(pad),
      decoration:
          BoxDecoration(color: color, borderRadius: rad.borderRadiusCircular()),
      child: this,
    );
  }
}

import 'package:flutter/material.dart';

extension SizeBox on num {
  SizedBox vertBox() {
    return SizedBox(
      height: this.toDouble(),
    );
  }

  SizedBox horzBox() {
    return SizedBox(
      width: this.toDouble(),
    );
  }

  Container horzLine({Color color = Colors.grey}) {
    return Container(
      width: this.toDouble(),
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 2,
      color: color,
    );
  }

  BorderRadius borderRadiusCircular() {
    return BorderRadius.circular(this.toDouble());
  }

  Container roundContainerWidget({double? width = 12, Color? color}) {
    return Container(
      width: width ?? this.toDouble(),
      height: this.toDouble(),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: width == null
            ? this.toDouble().borderRadiusCircular()
            : (width * 0.5).borderRadiusCircular(),
      ),
    );
  }

  Spacer spacer() {
    return Spacer(
      flex: this.toInt(),
    );
  }
}

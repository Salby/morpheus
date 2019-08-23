import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

class PageTransitionOpacityTween extends Tween<double> {
  PageTransitionOpacityTween({
    double begin,
    double end,
  }) : super(
          begin: begin,
          end: end,
        );

  double lerp(double t) {
    if (t < 1.0 / 3) {
      return lerpDouble(1.0, 0.0, t * 3);
    } else {
      return lerpDouble(0.0, 1.0, (t - 1.0 / 3) * 1.5);
    }
  }
}

import 'package:flutter/material.dart';

class VerticalTransitionChildTween extends Tween<Widget> {
  VerticalTransitionChildTween({
    Widget begin,
    Widget end,
  }) : super(
          begin: begin,
          end: end,
        );

  Widget lerp(double t) {
    if (t < 1.0 / 3) {
      return begin;
    } else {
      return end;
    }
  }
}

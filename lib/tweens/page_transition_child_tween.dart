import 'package:flutter/material.dart';

class PageTransitionChildTween extends Tween<Widget> {
  PageTransitionChildTween({
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

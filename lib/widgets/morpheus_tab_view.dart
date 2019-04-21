import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// A widget that plays a top-level transition whenever its
/// [child] changes.
///
/// You can set a custom [Curve] and [Duration] to tweak
/// the feel of the animation.
class MorpheusTabView extends ImplicitlyAnimatedWidget {
  MorpheusTabView({
    @required this.child,
    Curve curve = Curves.fastOutSlowIn,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
          curve: curve,
          duration: duration,
        );

  final Widget child;

  @override
  _MorpheusTabViewState createState() => _MorpheusTabViewState();
}

class _MorpheusTabViewState extends AnimatedWidgetBaseState<MorpheusTabView> {
  _TopLevelOpacityTween _opacityTween;
  _TopLevelScaleTween _scaleTween;
  _TopLevelChildTween _childTween;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Transform.scale(
        scale: _scaleTween.evaluate(animation),
        child: _childTween.evaluate(animation),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    _opacityTween = visitor(
        _opacityTween, 1.0, (opacity) => _TopLevelOpacityTween(begin: opacity));
    _scaleTween =
        visitor(_scaleTween, 1.0, (scale) => _TopLevelScaleTween(begin: scale));
    _childTween = visitor(_childTween, widget.child,
        (child) => _TopLevelChildTween(begin: child));
  }
}

class _TopLevelOpacityTween extends Tween<double> {
  _TopLevelOpacityTween({double begin, double end})
      : super(begin: begin, end: end);

  double lerp(double t) {
    if (t < 1.0 / 3) {
      return lerpDouble(1.0, 0.0, t);
    } else {
      return lerpDouble(0.0, 1.0, t);
    }
  }
}

class _TopLevelScaleTween extends Tween<double> {
  _TopLevelScaleTween({double begin, double end})
      : super(begin: begin, end: end);

  double lerp(double t) {
    if (t < 1.0 / 3) {
      return 1.0;
    } else {
      return lerpDouble(0.95, 1.0, t);
    }
  }
}

class _TopLevelChildTween extends Tween<Widget> {
  _TopLevelChildTween({Widget begin, Widget end})
      : super(begin: begin, end: end);

  Widget lerp(double t) {
    if (t < 1.0 / 3) {
      return begin;
    } else {
      return end;
    }
  }
}

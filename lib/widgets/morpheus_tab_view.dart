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

  /// Used to compare with the new [widget.child] to determine whether to
  /// animate a change or not.
  Key _currentKey;

  /// Returns true if [widget.child] is different from [_oldWidget].
  bool get _isOldWidget {
    if (widget.child.key == null && _currentKey == null) {
      return false;
    }
    return widget.child.key == _currentKey;
  }

  @override
  void initState() {
    super.initState();

    // Set initial [_currentKey] if [widget.child] has a key.
    if (widget.child.key != null) {
      setState(() => _currentKey = widget.child.key);
    }

    // Update [_oldWidget] when the animation ends.
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //setState(() => _oldWidget = widget.child);
        setState(() => _currentKey = widget.child.key);
      }
    });
  }

  /// Builds the top-level transition.
  ///
  /// The transition is only built when [widget.child] changes as defined by
  /// [_isNewWidget] and if [_initialBuild] is false.
  @override
  Widget build(BuildContext context) {
    // Build transition if a new widget has been supplied.
    final opacity = _isOldWidget ? 1.0 : _opacityTween.evaluate(animation);
    final scale = _isOldWidget ? 1.0 : _scaleTween.evaluate(animation);
    final child = _isOldWidget ? widget.child : _childTween.evaluate(animation);
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
    /*if (_isNewWidget && !_initialBuild) {
      return Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Transform.scale(
          scale: _scaleTween.evaluate(animation),
          child: _childTween.evaluate(animation),
        ),
      );
    } else {
      return widget.child;
    }*/
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
      return lerpDouble(1.0, 0.0, t * 3);
    } else {
      return lerpDouble(0.0, 1.0, (t - 1.0 / 3) * 1.5);
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
      return lerpDouble(0.95, 1.0, (t - 1.0 / 3) * 1.5);
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

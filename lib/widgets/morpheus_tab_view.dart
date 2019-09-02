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

  /// Change the value of this property after the initial build to make sure
  /// that the transition isn't built when the user hasn't changed screens.
  bool _initialBuild = true;

  /// Used to compare with the new [widget.child] to determine whether to
  /// animate a change or not.
  Widget _oldWidget;

  /// Returns true if [widget.child] is different from [_oldWidget].
  bool get _isNewWidget => !Widget.canUpdate(_oldWidget, widget.child);

  @override
  void initState() {
    super.initState();

    // Update [_oldWidget] when the animation ends.
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _oldWidget = widget.child);

        // Mark [_initialBuild] as false after the first screen has appeared.
        if (_initialBuild) {
          _initialBuild = false;
        }
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
    if (_isNewWidget && !_initialBuild) {
      return Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Transform.scale(
          scale: _scaleTween.evaluate(animation),
          child: _childTween.evaluate(animation),
        ),
      );
    } else {
      return widget.child;
    }
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

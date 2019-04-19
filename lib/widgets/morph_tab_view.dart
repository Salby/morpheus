import 'package:flutter/material.dart';

class MorphTabView extends ImplicitlyAnimatedWidget {
  @override
  _MorphTabViewState createState() => _MorphTabViewState();
}

class _MorphTabViewState extends ImplicitlyAnimatedWidgetState<MorphTabView> {
  Tween<double> _scale;
  Tween<double> _opacity;

  @override
  void forEachTween(visitor) {
    _scale = visitor(_scale, null, (value) => Tween<double>(begin: value));
    _opacity = visitor(_opacity, null, (value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

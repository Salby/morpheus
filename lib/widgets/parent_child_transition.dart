import 'package:flutter/material.dart';

class ParentChildTransition extends StatefulWidget {

  ParentChildTransition({
    @required this.child,
    @required this.parentKey,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final GlobalKey parentKey;
  final Duration duration;

  @override
  _ParentChildTransitionState createState() => _ParentChildTransitionState();

}

class _ParentChildTransitionState extends State<ParentChildTransition> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.value,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  RenderBox _getRenderObject() =>
      widget.parentKey.currentContext.findRenderObject();

  Size _getSize() => _getRenderObject().size;

  Offset _getOffset() => _getRenderObject().localToGlobal(Offset.zero);

}
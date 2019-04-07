import 'package:flutter/material.dart';
import './inherited_morph_scaffold.dart';

class MorphScaffold extends StatefulWidget {

  MorphScaffold({
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.scaffoldAnimationDuration = const Duration(milliseconds: 300),
  });

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget bottomNavigationBar;
  final Duration scaffoldAnimationDuration;

  static MorphScaffoldState of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(InheritedMorphScaffold) as InheritedMorphScaffold).data;

  @override
  MorphScaffoldState createState() => MorphScaffoldState();

}

class MorphScaffoldState extends State<MorphScaffold> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _opacity;
  Animation<double> _scale;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.scaffoldAnimationDuration,
      vsync: this,
    )
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _hidden = true;
          } else if (status == AnimationStatus.dismissed) {
            _hidden = false;
          }
        });
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    ))
        ..addListener(() { setState(() {}); });
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InheritedMorphScaffold(
      data: this,
      child: Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Scaffold(
            appBar: widget.appBar,
            body: widget.body,
            bottomNavigationBar: widget.bottomNavigationBar,
          ),
        ),
      ),
    );
  }

  bool get hidden => _hidden;

  Future<void> show() async {
    if (_hidden) {
      await _controller.reverse();
      return;
    } else {
      return;
    }
  }

  Future<void> hide() async {
    if (!_hidden) {
      await _controller.forward();
      return;
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
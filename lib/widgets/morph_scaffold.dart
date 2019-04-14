import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class _InheritedMorphScaffold extends InheritedWidget {

  _InheritedMorphScaffold({
    Key key,
    @required this.data,
    @required Widget child
  }) : super(key: key, child: child);

  final _MorphScaffoldState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}

class MorphScaffold extends StatefulWidget {

  MorphScaffold({
    this.appBar,
    this.backgroundColor,
    this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.scaffoldAnimationDuration = const Duration(milliseconds: 300),
    this.drawer,
    this.drawerDragStartBehavior = DragStartBehavior.down,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.scaffoldKey,
    this.persistentFooterButtons,
    this.primary = true,
    this.resizeToAvoidBottomInset,
    this.resizeToAvoidBottomPadding,
  });

  final PreferredSizeWidget appBar;
  final Color backgroundColor;
  final Widget body;
  final Widget bottomSheet;
  final Widget bottomNavigationBar;
  final Duration scaffoldAnimationDuration;
  final Widget drawer;
  final DragStartBehavior drawerDragStartBehavior;
  final Widget endDrawer;
  final Widget floatingActionButton;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Key scaffoldKey;
  final List<Widget> persistentFooterButtons;
  final bool primary;
  final bool resizeToAvoidBottomInset;
  final bool resizeToAvoidBottomPadding;

  static _MorphScaffoldState of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_InheritedMorphScaffold)
          as _InheritedMorphScaffold).data;

  @override
  _MorphScaffoldState createState() => _MorphScaffoldState();

}

class _MorphScaffoldState extends State<MorphScaffold> with SingleTickerProviderStateMixin {

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
    return _InheritedMorphScaffold(
      data: this,
      child: Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Scaffold(
            appBar: widget.appBar,
            backgroundColor: widget.backgroundColor,
            body: widget.body,
            bottomSheet: widget.bottomSheet,
            bottomNavigationBar: widget.bottomNavigationBar,
            drawer: widget.drawer,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            endDrawer: widget.endDrawer,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            key: widget.scaffoldKey,
            persistentFooterButtons: widget.persistentFooterButtons,
            primary: widget.primary,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
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
import 'package:flutter/material.dart';

class MorphPageRoute extends PageRouteBuilder {

  MorphPageRoute({
    @required this.child,
    @required this.parentKey,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) =>
        child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      print(_getAlignment(context, parentKey));
      return Align(
        alignment: _getAlignment(context, parentKey),
        child: SizeTransition(
          sizeFactor: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn,
          )),
          child: child,
        ),
      );
    },
    transitionDuration: duration,
  );

  final Widget child;
  final GlobalKey parentKey;
  final Duration duration;

  static RenderBox _getRenderObject(GlobalKey parentKey) =>
      parentKey.currentContext.findRenderObject();

  static Size _getSize(GlobalKey parentKey) =>
      MorphPageRoute._getRenderObject(parentKey).size;

  /*static Offset _getOffset(GlobalKey parentKey) =>
      MorphPageRoute._getRenderObject(parentKey).localToGlobal(Offset.zero);*/
  static Offset _getOffset(BuildContext context, GlobalKey parentKey) {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset boxOffset = 
        MorphPageRoute._getRenderObject(parentKey).localToGlobal(Offset.zero);
    return Offset(
      boxOffset.dx / screenSize.width,
      boxOffset.dy / screenSize.height,
    );
  }

  static Alignment _getAlignment(BuildContext context, GlobalKey parentKey) {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset boxOffset = _getRenderObject(parentKey)
        .localToGlobal(Offset.zero);
    print(boxOffset);
    final double alignmentX = boxOffset.dx < screenSize.width / 2
        ? -(boxOffset.dx / screenSize.width)
        : boxOffset.dx / screenSize.width;
    final double alignmentY = boxOffset.dy < screenSize.height / 2
        ? -(boxOffset.dy / screenSize.height)
        : boxOffset.dy / screenSize.height;
    return Alignment(alignmentX / 2, alignmentY / 2);
  }

}
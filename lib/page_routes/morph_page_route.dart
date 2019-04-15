import 'package:flutter/material.dart';
import '../utils/offset_to_alignment.dart';

class MorphPageRoute extends PageRouteBuilder {

  MorphPageRoute({
    @required this.child,
    @required this.parentKey,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) =>
        child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Align(
        alignment: _getAlignment(context, parentKey),
        child: SizeTransition(
          sizeFactor: Tween<double>(
            begin: _getSize(parentKey).height / MediaQuery
                .of(context).size.height * 100,
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
    final Size displaySize = MediaQuery.of(context).size;
    final Offset boxOffset = _getOffset(context, parentKey);
    return offsetToAlignment(boxOffset, displaySize);
  }

}
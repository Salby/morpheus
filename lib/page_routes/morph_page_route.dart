import 'package:flutter/material.dart';
import '../utils/offset_to_alignment.dart';

/// PageRouteBuilder that uses a parent-child transition.
class MorphPageRoute extends PageRouteBuilder {
  MorphPageRoute({
    @required this.child,
    @required this.parentKey,
    this.duration = const Duration(milliseconds: 600),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              alignment: _getAlignment(context, parentKey),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.0,
                    0.2,
                    curve: Curves.fastOutSlowIn,
                  ),
                  reverseCurve: Interval(
                    0.0,
                    0.2,
                    curve: Curves.fastOutSlowIn,
                  ),
                )),
                child: SizeTransition(
                  sizeFactor: Tween<double>(
                    begin: _getSizePercent(context, parentKey).height,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      0.2,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                    reverseCurve: Interval(
                      0.2,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  )),
                  child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: Tween<double>(
                      begin: _getSizePercent(context, parentKey).width,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.2,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                      reverseCurve: Interval(
                        0.2,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    )),
                    child: Container(color: Colors.green, child: child),
                  ),
                ),
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

  static Size _getSizePercent(BuildContext context, GlobalKey parentKey) {
    final Size displaySize = MediaQuery.of(context).size;
    final Size boxSize = _getSize(parentKey);
    final percentSize = Size(
      boxSize.width != displaySize.width
          ? double.parse(
              (boxSize.width / displaySize.width).toStringAsFixed(10))
          : 1.0,
      boxSize.height != displaySize.height
          ? double.parse(
              (boxSize.height / displaySize.height).toStringAsFixed(10))
          : 1.0,
    );
    return percentSize;
  }

  static Offset _getOffset(BuildContext context, GlobalKey parentKey) =>
      MorphPageRoute._getRenderObject(parentKey).localToGlobal(Offset.zero);

  static Alignment _getAlignment(BuildContext context, GlobalKey parentKey) {
    final Size displaySize = MediaQuery.of(context).size;
    final Offset boxOffset = _getOffset(context, parentKey);
    final Alignment alignment = offsetToAlignment(boxOffset, displaySize);
    return alignment;
  }
}
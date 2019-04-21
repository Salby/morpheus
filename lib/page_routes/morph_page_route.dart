import 'package:flutter/material.dart';
import '../utils/offset_to_alignment.dart';

/// PageRouteBuilder that uses a parent-child transition.
///
/// [MorphPageRoute] requires a child, which is the widget
/// you want to show after the transition is complete.
/// [parentKey] is a key that is attached to the widget you
/// want to animate from.
/// You can change the duration if you want to adjust the
/// speed of the transition.
/// If you have a widget that pushes [parentKey]'s widget's
/// parent, e.g. an [AppBar], you will want to set an
/// offset.
class MorphPageRoute extends PageRouteBuilder {
  MorphPageRoute({
    @required this.child,
    @required this.parentKey,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 0.0,
    this.elevation = 8.0,
    this.scrimColor = Colors.transparent,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Container(
              color: ColorTween(
                begin: scrimColor.withOpacity(0.0),
                end: scrimColor,
              )
                  .animate(CurvedAnimation(
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
                  ))
                  .value,
              child: Align(
                alignment: _getAlignment(context, parentKey, offset),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      0.0,
                      0.4,
                      curve: Curves.fastOutSlowIn,
                    ),
                    reverseCurve: Interval(
                      0.0,
                      0.4,
                      curve: Curves.fastOutSlowIn,
                    ),
                  )),
                  child: Material(
                    type: MaterialType.card,
                    elevation: Tween<double>(
                      begin: 0.0,
                      end: elevation,
                    )
                        .animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastOutSlowIn,
                          reverseCurve: Curves.fastOutSlowIn,
                        ))
                        .value,
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
                        child: FadeTransition(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Interval(
                              0.4,
                              0.8,
                              curve: Curves.fastOutSlowIn,
                            ),
                            reverseCurve: Interval(
                              0.4,
                              0.8,
                              curve: Curves.fastOutSlowIn,
                            ),
                          )),
                          child: child,
                        ),
                      ),
                    ),
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
  final double offset;
  final double elevation;
  final Color scrimColor;

  static RenderBox _getRenderObject(GlobalKey parentKey) =>
      parentKey.currentContext.findRenderObject();

  static Size _getSize(GlobalKey parentKey) =>
      MorphPageRoute._getRenderObject(parentKey).size;

  static Size _getSizePercent(BuildContext context, GlobalKey parentKey) {
    final Size displaySize = MediaQuery.of(context).size;
    final Size boxSize = _getSize(parentKey);
    final percentSize = Size(
      boxSize.width != displaySize.width
          ? boxSize.width / displaySize.width
          : 1.0,
      boxSize.height != displaySize.height
          ? boxSize.height / displaySize.height
          : 1.0,
    );
    return percentSize;
  }

  static Offset _getOffset(BuildContext context, GlobalKey parentKey) =>
      MorphPageRoute._getRenderObject(parentKey).localToGlobal(Offset.zero);

  static Alignment _getAlignment(
      BuildContext context, GlobalKey parentKey, double offset) {
    final Size displaySize = MediaQuery.of(context).size;
    final Offset boxOffset = _getOffset(context, parentKey);
    final Alignment alignment = offsetToAlignment(
        boxOffset, Size(displaySize.width, displaySize.height - offset));
    return alignment;
  }
}

import 'package:flutter/material.dart';
import '../utils/offset_to_alignment.dart';
import '../tweens/vertical_transition_child_tween.dart';
import '../tweens/vertical_transition_opacity_tween.dart';

/// PageRoute that implements a parent-child transition as defined in the
/// Material Design guidelines.
///
/// The type `T` specifies the return type of the route which can be supplied
/// as the route is popped from the stack via [Navigator.pop] by providing the
/// optional `result` argument.
class MorpheusPageRoute<T> extends PageRoute<T> {
  /// Construct a MorpheusPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [parentKey], [transitionDuration], [elevation],
  /// and [scrimColor] must not be null.
  MorpheusPageRoute({
    @required this.builder,
    @required this.parentKey,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.elevation = 8.0,
    this.scrimColor = Colors.transparent,
    this.shapeBorderTween,
    this.transitionColor,
  })  : assert(builder != null),
        assert(parentKey != null),
        assert(transitionDuration != null),
        assert(elevation != null),
        assert(scrimColor != null),
        _renderBoxOffset = _getOffset(parentKey),
        _renderBoxSize = _getSize(parentKey);

  /// Builds the contents of the route.
  final WidgetBuilder builder;

  /// A [GlobalKey] that is used to calculate the transition so that it looks
  /// like the element that [parentKey] is attached to turns into a new page
  /// with the contents of [builder].
  final GlobalKey parentKey;

  /// Defines the elevation of the MorpheusPageRoute at the end of the
  /// transition.
  final double elevation;

  /// Creates an overlay that covers the content outside of the
  /// MorpheusPageRoute.
  final Color scrimColor;

  /// Defines a transition between shapes, useful if you're transitioning from
  /// a shape other than a rectangle, e.g. a circle.
  final ShapeBorderTween shapeBorderTween;

  /// The color that is used when transitioning from the parent element to the
  /// contents of [builder].
  final Color transitionColor;

  /// Used to calculate the transition's [Offset]
  Offset _renderBoxOffset;

  /// Used to calculate the transition's [Size]
  Size _renderBoxSize;

  static RenderBox _findRenderBox(GlobalKey parentKey) =>
      parentKey.currentContext.findRenderObject();

  static Offset _getOffset(GlobalKey parentKey) {
    return _findRenderBox(parentKey).localToGlobal(Offset.zero);
  }

  static Size _getSize(GlobalKey parentKey) {
    return _findRenderBox(parentKey).size;
  }

  Alignment _getAlignment(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    final Alignment alignment = offsetToAlignment(
        _renderBoxOffset,
        Size(displaySize.width - _renderBoxSize.width,
            displaySize.height - _renderBoxSize.height));
    return alignment;
  }

  Widget _getWidget() {
    return parentKey.currentWidget;
  }

  @override
  final Duration transitionDuration;

  @override
  final bool opaque = true;

  @override
  final bool barrierDismissible = false;

  @override
  final Color barrierColor = null;

  @override
  final String barrierLabel = null;

  @override
  final bool maintainState = true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Container(
      color: ColorTween(
        begin: scrimColor.withOpacity(0.0),
        end: scrimColor,
      )
          .animate(CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.0,
              0.8,
              curve: Curves.fastOutSlowIn,
            ),
            reverseCurve: Interval(
              0.0,
              0.8,
              curve: Curves.fastOutSlowIn.flipped,
            ),
          ))
          .value,
      child: Align(
          alignment: _getAlignment(context),

          /// If [_renderBoxOffset.dx] is 0, build a
          /// vertical-only transition. If not, build a
          /// bidirectional transition that isn't as nice,
          /// but is more consistent with different sizes
          /// and offsets.
          child: _renderBoxOffset.dx == 0
              ? _verticalTransitionsBuilder(
                  context, animation, secondaryAnimation, child)
              : _bidirectionalTransitionsBuilder(
                  context, animation, secondaryAnimation, child)),
    );
  }

  Widget _bidirectionalTransitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
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
          curve: Curves.fastOutSlowIn.flipped,
        ),
      )),
      child: Container(
        width: Tween<double>(
          begin: _renderBoxSize.width,
          end: MediaQuery.of(context).size.width,
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
                curve: Curves.fastOutSlowIn.flipped,
              ),
            ))
            .value,
        height: Tween<double>(
          begin: _renderBoxSize.height,
          end: MediaQuery.of(context).size.height,
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
                curve: Curves.fastOutSlowIn.flipped,
              ),
            ))
            .value,
        child: Material(
          type: MaterialType.card,
          clipBehavior: Clip.antiAlias,
          color: transitionColor,
          shape: _shapeBorderTween(animation).value,
          elevation: Tween<double>(
            begin: 0.0,
            end: elevation,
          )
              .animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ))
              .value,
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
                curve: Curves.fastOutSlowIn.flipped,
              ),
            )),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _verticalTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Interval(
          0.0, 0.1,
          curve: Curves.fastOutSlowIn,
        ),
      )),
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.card,
        color: transitionColor,
        shape: _shapeBorderTween(animation).value,
        elevation: Tween<double>(
          begin: 0.0,
          end: elevation,
        )
            .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ))
            .value,
        child: Container(
          height: Tween<double>(
            begin: _renderBoxSize.height,
            end: MediaQuery.of(context).size.height,
          )
              .animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ))
              .value,
          child: FadeTransition(
            opacity: VerticalTransitionOpacityTween(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            )),
            child: VerticalTransitionChildTween(
              begin: _verticalTransitionWidget(),
              end: child,
            )
                .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ))
                .value,
          ),
        ),
      ),
    );
  }

  Widget _verticalTransitionWidget() {
    final Widget parentWidget = _getWidget();
    if (parentWidget is ListTile) {
      return ListTile(
        onTap: () => null,
        trailing: parentWidget.trailing,
        title: parentWidget.title,
        contentPadding: parentWidget.contentPadding,
        isThreeLine: parentWidget.isThreeLine,
        subtitle: parentWidget.subtitle,
        leading: parentWidget.leading,
        dense: parentWidget.dense,
        enabled: parentWidget.enabled,
        onLongPress: () => null,
        selected: parentWidget.selected,
      );
    } else {
      return Container(
        color: transitionColor,
      );
    }
  }

  Animation<ShapeBorder> _shapeBorderTween(Animation<double> animation) {
    final defaultTween = ShapeBorderTween(
      begin: RoundedRectangleBorder(),
      end: RoundedRectangleBorder(),
    );
    return (shapeBorderTween ?? defaultTween).animate(CurvedAnimation(
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
    ));
  }
}

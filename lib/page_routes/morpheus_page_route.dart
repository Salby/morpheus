import 'package:flutter/material.dart';

import 'package:morpheus/page_routes/morpheus_route_arguments.dart';
import 'package:morpheus/page_routes/morpheus_page_transition.dart';

/// PageRoute that implements a parent-child transition as defined in the
/// Material Design guidelines.
///
/// The type `T` specifies the return type of the route which can be supplied
/// as the route is popped from the stack via [Navigator.pop] by providing the
/// optional `result` argument.
///
/// See also:
///
/// * [PageRoute] which this class extends.
/// * [MaterialPageRoute] which is also based on [PageRoute].
class MorpheusPageRoute<T> extends PageRoute<T> {
  /// Construct a MorpheusPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [parentKey], [transitionDuration], [elevation],
  /// and [scrimColor] must not be null.
  MorpheusPageRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 450),
    this.parentKey,
    this.scrimColor = Colors.black45,
    this.borderRadius,
    this.transitionColor,
    this.transitionToChild = true,
    this.scaleChild = true,
    RouteSettings settings,
  })  : assert(builder != null),
        assert(transitionDuration != null),
        super(settings: settings);

  /// Builds the contents of the route.
  final WidgetBuilder builder;

  /// A [GlobalKey] that is used to calculate the transition so that it looks
  /// like the element that [parentKey] is attached to turns into a new page
  /// with the contents of [builder].
  final GlobalKey parentKey;

  /// The color of the overlay that covers the content behind the transition.
  final Color scrimColor;

  /// Defines the initial border-radius of the transition.
  final BorderRadiusGeometry borderRadius;

  /// The color that is used when transitioning from the parent element to the
  /// contents of [builder].
  final Color transitionColor;

  /// Defines whether the animation should transition from a temporary widget
  /// into the contents of [builder] or not.
  final bool transitionToChild;

  /// Defines whether the animation should scale in the contents of [builder]
  /// or not.
  ///
  /// This only affects bidirectional transitions.
  final bool scaleChild;

  RenderBox _findRenderBox() {
    final arguments = settings.arguments as MorpheusRouteArguments;
    final key = parentKey ?? arguments?.parentKey;

    // Return null if [key] is null.
    if (key == null) return null;

    // Find the [RenderBox] attached to [key].
    final renderBox = key.currentContext?.findRenderObject();

    // If [renderBox] is null but [_renderBox] isn't, return [_renderBox].
    if (renderBox == null) {
      if (_renderBox != null) {
        // Return the stored [RenderBox].
        return _renderBox;
      } else {
        return null;
      }
    } else {
      // Update local [RenderBox] values.
      _renderBox = renderBox;
      _size = _renderBox?.size;
      _offset = _renderBox?.localToGlobal(Offset.zero);
      return renderBox;
    }
  }

  /// A [RenderBox] used when building a parent-child transition to determine
  /// what, if any, origin to animate from.
  RenderBox _renderBox;

  /// Informs a parent-child transition what size the child-screen should
  /// animate from.
  Size _size;

  /// Informs a parent-child transition at what position the transition should
  /// originate from.
  Offset _offset;

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
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final routeSettings = settings.arguments as MorpheusRouteArguments;

    // Define transition settings.
    final transitionSettings = MorpheusRouteArguments(
      parentKey: routeSettings?.parentKey ?? parentKey,
      scrimColor: routeSettings?.scrimColor ?? scrimColor,
      borderRadius: routeSettings?.borderRadius ?? borderRadius,
      transitionColor: routeSettings?.transitionColor ?? transitionColor,
      transitionToChild: routeSettings?.transitionToChild ?? transitionToChild,
      scaleChild: routeSettings?.scaleChild ?? scaleChild,
    );

    // Find the renderBox stuff and store it for later.
    _findRenderBox();

    // Return page transition.
    return MorpheusPageTransition(
      renderBox: _renderBox,
      renderBoxSize: _size,
      renderBoxOffset: _offset,
      context: context,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
      settings: transitionSettings,
    );
  }
}

import 'package:flutter/material.dart';

/// Creates an object with properties needed for the [MorpheusPageRoute] class.
///
/// This class can be used to pass a [parentKey] to a [MorpheusPageRoute] when
/// using named routes.
///
/// This class can be extended with whatever other arguments you want to pass
/// to a route.
///
/// {@tool sample}
/// ```dart
/// final parentKey = GlobalKey();
/// Navigator.of(context).pushNamed(
///   '/profile',
///   arguments: MorpheusRouteArguments(
///     parentKey: parentKey,
///   ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
/// - [RouteSettings], which this class is meant to be used with.
class MorpheusRouteArguments {
  const MorpheusRouteArguments({
    this.parentKey,
    this.scrimColor = Colors.black45,
    this.borderRadius,
    this.transitionColor,
    this.transitionToChild = true,
    this.scaleChild = true,
  }) : assert(scrimColor != null);

  /// A [GlobalKey] that is used to calculate the transition so that it looks
  /// like the element that [parentKey] is attached to turns into a new page
  /// with the contents of a [MorpheusPageRoute.builder].
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
}

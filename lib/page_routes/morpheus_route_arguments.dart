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
    @required this.parentKey,
  })  : assert(parentKey != null);

  /// A [GlobalKey] that is used to calculate the transition so that it looks
  /// like the element that [parentKey] is attached to turns into a new page
  /// with the contents of a [MorpheusPageRoute.builder].
  final GlobalKey parentKey;
}

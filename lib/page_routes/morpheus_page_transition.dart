import 'package:flutter/material.dart';

import 'package:morpheus/page_routes/morpheus_route_arguments.dart';
import 'package:morpheus/tweens/page_transition_child_tween.dart';
import 'package:morpheus/tweens/page_transition_opacity_tween.dart';

/// Builds a parent-child material design navigation transition.
class MorpheusPageTransition extends StatelessWidget {
  MorpheusPageTransition({
    this.renderBox,
    this.renderBoxSize,
    this.renderBoxOffset,
    @required BuildContext context,
    @required this.animation,
    @required this.secondaryAnimation,
    @required this.child,
    @required this.settings,
  })  : assert(context != null),
        assert(animation != null),
        assert(secondaryAnimation != null),
        assert(child != null),
        assert(settings != null),
        transitionContext = context;

  /// The [RenderBox] used to calculate the origin of the parent-child
  /// transition. Used to determine which transition will be used.
  final RenderBox renderBox;

  final BuildContext transitionContext;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
  final MorpheusRouteArguments settings;

  /// The size of [renderBox]. Used by [buildVerticalTransition] or
  /// [buildBidirectionalTransition] to determine the initial size of the child
  /// screen.
  final Size renderBoxSize;

  /// The calculated [Offset] of [renderBox]. Used by [buildVerticalTransition]
  /// or [buildBidirectionalTransition] to determine the initial position of
  /// the child screen.
  final Offset renderBoxOffset;

  /// Returns true if the parent widget spans the entire width of the screen.
  ///
  /// returns false if [renderBox] is null.
  bool get useVerticalTransition {
    // Return null if [renderBox] is null.
    if (renderBox == null) return false;

    final screenWidth = MediaQuery.of(transitionContext).size.width;
    return renderBoxSize.width == screenWidth && renderBoxOffset.dx == 0.0;
  }

  /// Returns an [Animation] used to animate the transition from the parent widget
  /// to the child widget.
  Animation<double> get parentToChildAnimation {
    // Define when the animation should end.
    final animationEnd =
        transitionWidget == null ? 0.3 : useVerticalTransition ? 0.1 : 0.2;

    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Interval(
        0.0,
        animationEnd,
        curve: Curves.fastOutSlowIn,
      ),
      reverseCurve: Interval(
        0.0,
        animationEnd,
        curve: Curves.fastOutSlowIn.flipped,
      ),
    ));
  }

  /// Returns a [BorderRadiusTween] with an initial value of
  /// [settings.borderRadius].
  BorderRadiusTween get borderRadius => BorderRadiusTween(
        begin: settings.borderRadius ?? BorderRadius.circular(0.0),
        end: BorderRadius.circular(0.0),
      );

  /// Returns a curve that can be applied to all transitions that are
  /// synchronized with [positionTween].
  Animation<double> get positionAnimationCurve {
    // Define where on the timeline the animation should start.
    final animationStart =
        transitionWidget != null ? 0.0 : useVerticalTransition ? 0.1 : 0.2;

    return CurvedAnimation(
      parent: animation,
      curve: Interval(
        animationStart,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
      reverseCurve: Interval(
        animationStart,
        1.0,
        curve: Curves.fastOutSlowIn.flipped,
      ),
    );
  }

  /// Returns a [RelativeRectTween] that is used to animate from the origin
  /// of [renderBox] to the size of the screen.
  RelativeRectTween positionTween(BoxConstraints constraints) {
    final origin = renderBoxOffset & renderBoxSize;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          origin.left,
          origin.top,
          constraints.biggest.width - origin.right,
          constraints.biggest.height - origin.bottom),
      end: RelativeRect.fill,
    );
  }

  /// Builds the transition, uses either [buildVerticalTransition],
  /// [buildDefaultTransition], or [buildBidirectionalTransition]
  /// depending on [useVerticalTransition].
  ///
  /// This method is only responsible for building the animations that
  /// all the transitions use.
  @override
  Widget build(BuildContext context) {
    // Define at which point during the transition the scrim will start to
    // show.
    final scrimAnimationStart =
        useVerticalTransition ? 0.0 : transitionWidget != null ? 0.0 : 0.2;

    // Define the scrim animation.
    final Animation<Color> scrimAnimation = ColorTween(
      begin: settings.scrimColor.withOpacity(0.0),
      end: settings.scrimColor,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Interval(
        scrimAnimationStart,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
      reverseCurve: Interval(
        scrimAnimationStart,
        1.0,
        curve: Curves.fastOutSlowIn.flipped,
      ),
    ));

    if (renderBox == null) {
      return buildDefaultTransition();
    }

    final transitionColor = settings.transitionColor ??
        Theme.of(context).colorScheme?.surface ??
        Theme.of(context).cardTheme.color ??
        Theme.of(context).cardColor;

    // Return the animated scrim with the appropriate transition as child.
    return Container(
      color: scrimAnimation.value,
      child: LayoutBuilder(
        builder: (context, constraints) => FadeTransition(
          opacity: parentToChildAnimation,
          child: Stack(
            children: <Widget>[
              // Animate the position of the child screen from the origin of
              // [renderBox] to fill the entire screen.
              PositionedTransition(
                rect:
                    positionTween(constraints).animate(positionAnimationCurve),
                child: AnimatedBuilder(
                  animation: positionAnimationCurve,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                    maxHeight: constraints.maxHeight,
                    child: child,
                  ),
                  builder: (context, child) => ClipRRect(
                    borderRadius: borderRadius.evaluate(positionAnimationCurve),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: transitionColor,
                        ),
                        settings.transitionToChild
                            ? useVerticalTransition
                                ? buildVerticalTransition(child)
                                : buildBidirectionalTransition(child)
                            : child,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a vertical parent-child transition.
  ///
  /// If [transitionWidget] isn't null the transition will start from 0.0 on
  /// the timeline with the [transitionWidget] and then fade into the
  /// [childScreen] as defined by a [PageTransitionChildTween].
  ///
  /// If [transitionWidget] is null, an empty [Container] will be used as the
  /// transition widget.
  Widget buildVerticalTransition(Widget childScreen) {
    return FadeTransition(
      opacity: PageTransitionOpacityTween(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: PageTransitionChildTween(
        // Use an empty [Container] as parent widget if there is no
        // transition widget.
        begin: transitionWidget ?? Container(),
        end: childScreen,
      )
          .animate(CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ))
          .value,
    );
  }

  /// Builds a bidirectional parent-child transition.
  ///
  /// If [transitionWidget] isn't null the transition will start from 0.0 on
  /// the timeline with the [transitionWidget]. As the animation plays the
  /// [transitionWidget] is scaled up before it fades into the [childScreen]
  /// that ends up at full-size.
  Widget buildBidirectionalTransition(Widget childScreen) {
    // Controls the opacity of the [childScreen] in a transition where there is
    // no transition widget.
    final fadeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );

    // The animation that controls the scale of the parent widget.
    final Animation<double> scaleParentAnimation = Tween<double>(
      begin: 1.0,
      end: MediaQuery.of(transitionContext).size.width / renderBoxSize.width,
    ).animate(positionAnimationCurve);

    // The animation that controls the scale of the child screen.
    final Animation<double> scaleChildAnimation = Tween<double>(
      begin: renderBoxSize.width / MediaQuery.of(transitionContext).size.width,
      end: 1.0,
    ).animate(positionAnimationCurve);

    // If transitionWidget is null the parent widget will be an empty
    // [Container], otherwise the parent widget will be scaled up controlled by
    // [scaleParentAnimation].
    final parentWidget = transitionWidget != null
        ? ScaleTransition(
            alignment: Alignment.center,
            scale: scaleParentAnimation,
            child: transitionWidget,
          )
        : Container();

    // This transition is used in case there is no transition widget.
    if (transitionWidget == null)
      return FadeTransition(
        opacity: fadeInAnimation,
        child: ScaleTransition(
          alignment: Alignment.topCenter,
          scale: settings.scaleChild
              ? scaleChildAnimation
              : ConstantTween(1.0).animate(positionAnimationCurve),
          child: childScreen,
        ),
      );

    return FadeTransition(
      opacity: PageTransitionOpacityTween(
        begin: 0.0,
        end: 1.0,
      ).animate(positionAnimationCurve),
      child: PageTransitionChildTween(
        begin: parentWidget,
        end: ScaleTransition(
          alignment: Alignment.topCenter,

          // Scale the child screen if [settings.scaleChild] is true.
          scale: settings.scaleChild
              ? scaleChildAnimation
              : ConstantTween<double>(1.0).animate(animation),
          child: childScreen,
        ),
      ).animate(positionAnimationCurve).value,
    );
  }

  /// Builds a simple transition where a child screen is faded and scaled in
  /// with a colored scrim.
  ///
  /// The color of the scrim is defined by [settings.scrimColor].
  Widget buildDefaultTransition() {
    // Controls the color of the scrim, from fully transparent to
    // [settings.scrimColor].
    final Animation<Color> scrimAnimation = ColorTween(
      begin: settings.scrimColor.withOpacity(0.0),
      end: settings.scrimColor,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    ));

    // Controls the scale of the child screen.
    final Animation<double> scaleChildAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    ));

    // Controls the opacity of the child screen.
    final Animation<double> fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    ));

    return Container(
      color: scrimAnimation.value,
      child: FadeTransition(
        opacity: fadeInAnimation,
        child: ScaleTransition(
          scale: scaleChildAnimation,
          child: child,
        ),
      ),
    );
  }

  /// Returns a [Widget] that is an exact copy of the widget which
  /// [settings.parentKey] is attached to, if that widget is of a supported
  /// type. If the widget is not a supported type this getter will return null.
  ///
  /// If the widget type has gesture listeners, these will be disabled in the
  /// [Widget] that is returned.
  ///
  /// Currently supported widgets include:
  ///
  /// * [Container]
  /// * [ListTile]
  /// * [FloatingActionButton] (Not extended)
  Widget get transitionWidget {
    final parentWidget = settings.parentKey?.currentWidget;

    /// Return null if [settings.parentKey] is null.
    if (parentWidget == null) return null;

    switch (parentWidget.runtimeType) {
      case ListTile:
        final widget = parentWidget as ListTile;
        return Material(
          type: MaterialType.transparency,
          child: ListTile(
            onTap: () => null,
            trailing: widget.trailing,
            title: widget.title,
            contentPadding: widget.contentPadding,
            isThreeLine: widget.isThreeLine,
            subtitle: widget.subtitle,
            leading: widget.leading,
            dense: widget.dense,
            enabled: widget.enabled,
            onLongPress: () => null,
            selected: widget.selected,
          ),
        );
        break;
      case Container:
        final widget = parentWidget as Container;
        return Container(
          alignment: widget.alignment,
          padding: widget.padding,
          decoration: widget.decoration,
          foregroundDecoration: widget.foregroundDecoration,
          width: renderBoxSize.width,
          height: renderBoxSize.height,
          constraints: widget.constraints,
          margin: widget.margin,
          transform: widget.transform,
          child: widget.child,
        );
        break;
      case FloatingActionButton:
        final widget = parentWidget as FloatingActionButton;
        if (widget.isExtended) return null;
        final backgroundColor = widget.backgroundColor ??
            Theme.of(transitionContext)
                .floatingActionButtonTheme
                .backgroundColor ??
            Theme.of(transitionContext).accentColor;
        return Material(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56.0),
          ),
          child: Center(
            child: widget.child,
          ),
        );
        break;
      default:
        return null;
        break;
    }
  }
}

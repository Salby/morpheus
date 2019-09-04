# Changelog

## [1.2.2+1] - 2019-09-04

### Fixed
- Fixed some strange `MorpheusTabView` behaviour.

## [1.2.2] - 2019-09-03

### Changed
- `MorpheusTabView` will only ignore a new child if it has the same key as the previous child.

### Fixed
- Fixed issue where popping a `MorpheusPageRoute` that uses a `parentKey` would throw an exception.

## [1.2.1] - 2019-09-02

### Changed
- `MorpheusTabView` only transitions when a new child is provided.

## [1.2.0+6] - 2019-08-30

### Fixed
- Fixed change in `MorpheusPageRoute` default transition.

## [1.2.0+5] - 2019-08-30

### Changed
- Improved `MorpheusPageRoute` default transition.

## [1.2.0+4] - 2019-08-29

### Added
- Added documentation for `MorpheusPageRoute` transitions.

### Changed
- Improved `MorpheusPageRoute` bidirectional transition when there is no transition widget.

## [1.2.0+3] - 2019-08-26

### Changed
- Reverted some earlier "fixes".

## [1.2.0+2] - 2019-08-26

### Fixes
- Fixed a rendering error caused by the last fix :)

## [1.2.0+1] - 2019-08-26

### Fixes
- Fixed a bug where `MorpheusPageRoute` couldn't re-use the existing `RenderBox` and would throw an exception when popping a layer in the navigation stack.

## [1.2.0] - 2019-08-26

### Added
- Added a new 'default' transition for situations where no `parentKey` has been provided (This wasn't possible before).
- Added support for transitioning from `Container` and `FloatingActionButton` widgets.

### Changed
- Changed the default `MorpheusPageRoute` transition duration from 500ms to 450ms.

## [1.1.0] - 2019-08-21

### Added
- Improved documentation for `MorpheusPageRoute`.
- Added the `MorpheusRouteArguments` class that can be passed as the arguments when pushing a named route.

### Changed
- Changed the example to use named routes.

## [1.0.2] - 2019-06-22

### Added
- Added `scaleChild` toggle for disabling the scale animation of a `MorpheusPageRoute` transition.

## [1.0.1] - 2019-06-20

### Changed
- `MorpheusPageRoute` transitions scrim transitions has been changed so that it begins when the 'material' starts moving in bidirectional transitions.

## [1.0.0] - 2019-06-16

### Changed
- Changed all `MorpheusPageRoute` transitions so that they now should be more accurate to the Material Design guidelines.
- Bidirectional `MorpheusPageRoute` transitions scales its child screen in the animation.

### Removed
- Removed the `shapeBorderTween` parameter from `MorpheusPageRoute`. It has been replaced with a `borderRadius` parameter.
- Removed the `elevation` parameter from `MorpheusPageRoute`.

## [0.8.1] - 2019-06-09

### Changed
- Bidirectional `MorpheusPageRoute` transitions are now horizontally centered.

## [0.8.0] - 2019-06-01

### Added
- Added `RouteSettings` to `MorpheusPageRoute`.

### Changed
- Changed `MorpheusPageRoute`'s bidirectional transition so that the child screen is clipped instead of begin resized when animating.

## [0.7.1] - 2019-05-31

### Changed
- Changed `MorpheusPageRoute`'s vertical transition so that the child screen isn't resized when animating.

## [0.7.0] - 2019-05-30

### Added
- Added new tweens dedicated to vertical transitions in `MorpheusPageRoute`.
- Added `transitionToChild` property to `MorpheusPageRoute`.
- Added a brand new example of how to use the package.

### Changed
- Changed `MorpheusPageRoute`'s default `transitionDuration` from `550` to `500`.

## [0.6.7] - 2019-05-26

### Changed
- Changed scrim animation interval.

## [0.6.6] - 2019-05-23

### Added
- Added some more documentation for `MorpheusPageRoute`.

### Changed
- Changed `MorpheusPageRoute`'s elevation animation curves.

## [0.6.5] - 2019-05-15

### Changed
- Improved `MorpheusTabView` opacity and scale tweens.
- Improved example.

## [0.6.4] - 2019-05-05

### Added
- Added assertions in `MorpheusPageRoute`.

### Changed
- Changed `MorpheusPageRoute`'s default `transitionDuration`.

### Removed
- Removed redundant `SizeTransition` from `MorpheusPageRoute.verticalTransitionsBuilder`.

## [0.6.3] - 2019-04-27

### Changed
- Changed reverse curves in `MorpheusPageRoute`.

## [0.6.2] - 2019-04-26

### Added
- Small tweaks to `MorpheusPageRoute` transitions.

## [0.6.1] - 2019-04-25

### Fixes
- Fixed `MorpheusPageRoute` transition element not clipping the child screen.

## [0.6.0] - 2019-04-25

### Added
- Added `transitionColor` parameter to `MorpheusPageRoute` that lets you control the color of the transition element.
- `MorpheusPageRoute` can now be typed (e.g. `final Model model = await Navigator.of(context).push(MorpheusPageRoute(...))`).

## [0.5.0] - 2019-04-25

### Added
- Added `shapeBorderTween` parameter to `MorpheusPageRoute` that lets you control the shape of the child screen.
- (Under the hood) Split `MorpheusPageRoute.buildTransitions` into two seperate transitions, one specifically for vertical-only transitions, and another that's not as fancy, but is more consistent across different sizes and positions.

## [0.4.0] - 2019-04-22

### Removed
- `MorpheusPageRoute`'s `offset` parameter.

## [0.3.1] - 2019-04-22

### Added
- Added GIF examples.

### Fixed
- Fixed exception where `findRenderObject` was being called on null.

## [0.3.0] - 2019-04-22

### Changed
- Changed `MorpheusPageRoute`'s `child` parameter to a `Builder`.

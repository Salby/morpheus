# Changelog

## [Unreleased]

### Added
- Added assertions in `MorpheusPageRoute`.

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
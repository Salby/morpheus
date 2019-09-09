import 'package:morpheus/tweens/page_transition_opacity_tween.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  PageTransitionOpacityTween tween;

  setUp(() {
    tween = PageTransitionOpacityTween();
  });

  test('Fully opaque at beginning', () {
    final opacity = tween.lerp(0.0);

    expect(opacity, 1.0);
  });

  test('Fully opaque at end', () {
    final opacity = tween.lerp(1.0);

    expect(opacity, 1.0);
  });

  test('Fully transparent at 1/3', () {
    final opacity = tween.lerp(1.0 / 3);

    expect(opacity, 0.0);
  });

  test('Half transparent at 2/3', () {
    final opacity = tween.lerp(1.0 / 3 * 2);

    expect(opacity, 0.5);
  });

  test('Half transparent at .5/3', () {
    final opacity = tween.lerp(1.0 / 3 / 2);

    expect(opacity, 0.5);
  });
}

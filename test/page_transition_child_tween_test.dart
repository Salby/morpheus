import 'package:flutter/material.dart';

import 'package:morpheus/tweens/page_transition_child_tween.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  PageTransitionChildTween tween;
  Widget firstWidget;
  Widget secondWidget;

  setUp(() {
    firstWidget = Container(key: Key('first'));
    secondWidget = Container(key: Key('second'));
    tween = PageTransitionChildTween(
      begin: firstWidget,
      end: secondWidget,
    );
  });

  test('First widget is shown before 1/3 has been passed', () {
    // Before 1/3.
    final widget = tween.lerp(0.2);

    expect(widget, equals(firstWidget));
  });

  test('Second widget is shown after 1/3 has been passed', () {
    // After 1/3.
    final widget = tween.lerp(0.5);

    expect(widget, equals(secondWidget));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morpheus/utils/alignment_from_offset.dart';

void main() {
  final containerSize = Size(100.0, 100.0);
  final offset = Offset(0.0, 80.0);
  final testObject = AlignmentFromOffset(offset, containerSize);

  test('offset values are calculated into percent', () {
    final double percent = testObject.offsetValueToPercent(50.0, 100.0);
    expect(percent, 0.5);
  });

  test('Offset percent are morphed into alignment values', () {
    double axisValue = testObject.percentToAxisAlignment(0.5);
    expect(axisValue, 0.0);

    axisValue = testObject.percentToAxisAlignment(0.2);
    expect(axisValue, lessThan(0.0));

    axisValue = testObject.percentToAxisAlignment(0.6);
    expect(axisValue, greaterThan(0.0));
  });
}

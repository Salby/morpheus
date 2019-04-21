import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morpheus/utils/offset_to_alignment.dart';

void main() {
  final Size displaySize = Size(411.42857142857144, 774.8571428571429);
  final offset = Offset(0.0, 80.0);
  test('percentage of first widget', () {
    //final boxSize = Size(displaySize.width, 56.0);

    final double expectedPercentFromHeight = offset.dy / displaySize.height;
    final double actualPercentFromHeight =
        offsetToPercent(offset.dy, displaySize.height);
    expect(actualPercentFromHeight, expectedPercentFromHeight);
  });

  test('display part of first widget is on upper half', () {
    final double actualPercentFromHeight =
        offsetToPercent(offset.dy, displaySize.height);
    expect(actualPercentFromHeight, lessThan(0.5));
  });

  test('offset on upper half of first widget', () {
    final double actualPercentFromHeight =
        offsetToPercent(offset.dy, displaySize.height);
    final double expectedPercentOnUpperHalf =
        (actualPercentFromHeight * 2.0) - 1.0;
    expect(convertValue(actualPercentFromHeight), expectedPercentOnUpperHalf);
  });
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morph/utils/offset_to_alignment.dart';

void main() {
  final Size displaySize = Size(100.0, 100.0);
  test('Offset y-value should be inverted', () {
    final boxOffset = Offset(0.0, 0.1);
    final Alignment alignment =
        offsetToAlignment(Offset(boxOffset.dx, boxOffset.dy), displaySize);
    expect(alignment.y, -0.8);
  });
}

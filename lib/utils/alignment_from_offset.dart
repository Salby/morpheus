import 'package:flutter/material.dart';

/// Generates an [Alignment] object from an [Offset] and [Size].
class AlignmentFromOffset {
  AlignmentFromOffset(
    Offset offset,
    Size containerSize,
  ) : _containerSize = containerSize {
    final percentOffset = offsetToPercent(offset);
    _alignment = percentOffsetToAlignment(percentOffset);
  }

  final Size _containerSize;
  Alignment _alignment;

  Alignment get alignment => _alignment;

  @visibleForTesting
  Offset offsetToPercent(Offset offset) => Offset(
        offsetValueToPercent(offset.dx, _containerSize.width),
        offsetValueToPercent(offset.dy, _containerSize.height),
      );

  @visibleForTesting
  double offsetValueToPercent(double offset, double total) =>
      offset == 0.0 ? 0.0 : offset / total;

  @visibleForTesting
  Alignment percentOffsetToAlignment(Offset percentOffset) => Alignment(
        percentToAxisAlignment(percentOffset.dx),
        percentToAxisAlignment(percentOffset.dy),
      );

  @visibleForTesting
  double percentToAxisAlignment(double percent) {
    double converted;

    if (percent == 1.0) {
      converted = 1.0;
    } else if (percent == 0.5) {
      converted = 0.0;
    } else if (percent == 0.0) {
      converted = -1.0;
    } else if (percent < 0.5) {
      /// Multiply [percent] by 2 because its value is worth double when we're
      /// only working with one half of the display.
      final double multiplied = percent * 2.0;

      /// Find the difference between [multiplied] and 1.0, because we have to
      /// invert [multiplied].
      final double difference = 1.0 - multiplied;

      converted = -(difference);
    } else if (percent > 0.5) {
      /// Subtract 0.5 (50%) from [percent] because we're only working with the
      /// lower half of the display.
      final double half = percent - 0.5;

      /// Multiply [half] by 2 because its value is worth double when we're
      /// only working with one half of the display.
      converted = half * 2.0;
    }
    return converted;
  }
}

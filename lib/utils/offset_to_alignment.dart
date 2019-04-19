import 'package:flutter/widgets.dart';

/// Converts [Offset] to [Alignment].
Alignment offsetToAlignment(Offset offset, Size displaySize) {
  final double xOffsetPercent = offsetToPercent(offset.dx, displaySize.width);
  final double yOffsetPercent = offsetToPercent(offset.dy, displaySize.height);
  final double alignmentX = convertValue(xOffsetPercent);
  final double alignmentY = convertValue(yOffsetPercent);
  return Alignment(alignmentX, alignmentY);
}

double offsetToPercent(double value, double compareTo) {
  if (value == 0.0) {
    return 0.0;
  } else {
    return value / compareTo;
  }
}

///         -1.0
///           |
///           |            Upper half of the display.
///           |
/// -1.0-----0.0-----1.0   Center of the display.
///           |
///           |            Lower half of the display.
///           |
///          1.0
double convertValue(double percentValue) {
  double converted;
  if (percentValue == 1.0) {
    converted = 1.0;
  } else if (percentValue == 0.5) {
    converted = 0.0;
  } else if (percentValue == 0.0) {
    converted = -1.0;
  } else if (percentValue < 0.5) {
    /// Multiply [percentValue] by 2 because it's value is
    /// woth double when we're only working with one half
    /// of the display.
    converted = percentValue * 2.0;

    /// Find the difference between [converted] and
    /// 1.0, because we have to invert [converted].
    final double difference = 1.0 - converted;
    converted = -(difference);
  } else if (percentValue > 0.5) {
    /// Subtract 0.5 (50%) from [percentValue] because
    /// we're only working with the lower half of the
    /// display.
    converted = percentValue - 0.5;

    /// Multiply [converted] by 2 because it's value is
    /// worth double when we're only working with one half
    /// of the display.
    converted = converted * 2.0;
  }
  return converted;
}

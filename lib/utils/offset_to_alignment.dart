import 'package:flutter/widgets.dart';

Alignment offsetToAlignment(Offset offset, Size displaySize) {
  final double alignmentX = _convertValue(offset.dx / displaySize.width);
  final double alignmentY = _convertValue(offset.dy / displaySize.height);
  return Alignment(alignmentX, alignmentY);
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
double _convertValue(double percentValue) {
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
    converted = percentValue * 2;
    
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
    converted = converted * 2;
  }
  return converted;
}
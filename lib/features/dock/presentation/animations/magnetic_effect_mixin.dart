import 'package:flutter/material.dart';
import 'dart:math' as math;

mixin MagneticEffectMixin<T extends StatefulWidget> on State<T> {
  static const double magneticRange = 100.0;
  static const double maxMagneticPull = 20.0;

  double calculateMagneticPull(Offset itemPosition, Offset dragPosition) {
    final distance = (itemPosition - dragPosition).distance;

    if (distance > magneticRange) return 0.0;

    final normalizedDistance = distance / magneticRange;
    final pull = maxMagneticPull * (1 - math.pow(normalizedDistance, 2));

    return pull;
  }

  Offset getMagneticOffset(Offset itemPosition, Offset dragPosition) {
    if (dragPosition == Offset.zero) return Offset.zero;

    final pull = calculateMagneticPull(itemPosition, dragPosition);
    if (pull == 0) return Offset.zero;

    final difference = dragPosition - itemPosition;
    final distance = difference.distance;

    if (distance > 0) {
      final normalizedX = difference.dx / distance;
      final normalizedY = difference.dy / distance;
      return Offset(normalizedX * pull, normalizedY * pull);
    }

    return Offset.zero;
  }
}

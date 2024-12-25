import 'package:flutter/material.dart';

mixin MountainEffectMixin<T extends StatefulWidget> on State<T> {
  double calculateMountainScale(int index, int centerIndex) {
    final distance = (index - centerIndex).abs();
    const peakScale = 1.8;
    const shoulderScale = 1.3;
    const baseScale = 1.0;

    switch (distance) {
      case 0:
        return peakScale;
      case 1:
        return shoulderScale;
      case 2:
        return (shoulderScale + baseScale) / 2;
      default:
        return baseScale;
    }
  }

  double calculateSpacing(int index, int? draggedIndex) {
    if (draggedIndex == null) return 1.0;

    final distance = (index - draggedIndex).abs();
    const maxSpacing = 2.0;
    const minSpacing = 1.0;

    return distance <= 2 ? maxSpacing - (distance * 0.5) : minSpacing;
  }
}

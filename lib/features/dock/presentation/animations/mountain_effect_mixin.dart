import 'package:flutter/material.dart';

mixin MountainEffectMixin<T extends StatefulWidget> on State<T> {
  double calculateMountainScale(int index, int centerIndex) {
    final distance = (index - centerIndex).abs();
    const peakScale = 1.3; // центральная иконка
    const scale1 = 1.2; // ближайшие соседи
    const scale2 = 1.1; // следующие соседи
    const baseScale = 1.0; // все остальные

    switch (distance) {
      case 0:
        return peakScale;
      case 1:
        return scale1;
      case 2:
        return scale2;
      default:
        return baseScale;
    }
  }
}

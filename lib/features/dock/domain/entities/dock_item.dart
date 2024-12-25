import 'package:flutter/material.dart';

enum DockItemState { normal, hovered, dragging, dropping }

class DockItem {
  final String iconPath;
  final String label;
  final int index;
  final bool isRunning;
  final DockItemState state;
  final double scale;
  final double offsetY;
  final Offset? dragPosition;

  const DockItem({
    required this.iconPath,
    required this.label,
    required this.index,
    this.isRunning = false,
    this.state = DockItemState.normal,
    this.scale = 1.0,
    this.offsetY = 0.0,
    this.dragPosition,
  });

  DockItem copyWith({
    String? iconPath,
    String? label,
    int? index,
    bool? isRunning,
    DockItemState? state,
    double? scale,
    double? offsetY,
    Offset? dragPosition,
  }) {
    return DockItem(
      iconPath: iconPath ?? this.iconPath,
      label: label ?? this.label,
      index: index ?? this.index,
      isRunning: isRunning ?? this.isRunning,
      state: state ?? this.state,
      scale: scale ?? this.scale,
      offsetY: offsetY ?? this.offsetY,
      dragPosition: dragPosition ?? this.dragPosition,
    );
  }
}

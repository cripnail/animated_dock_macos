import 'package:flutter/material.dart';

enum DockItemState { normal, hovered, dragging, dropping }

class DockItem {
  final String iconPath;
  final String label;
  final int index;
  final bool isRunning;
  final DockItemState state;
  final double offsetY;
  final double offsetX;
  final bool isDragging;

  const DockItem({
    required this.iconPath,
    required this.label,
    required this.index,
    this.isRunning = false,
    this.state = DockItemState.normal,
    this.offsetY = 0.0,
    this.offsetX = 0.0,
    this.isDragging = false,
  });

  DockItem copyWith({
    String? iconPath,
    String? label,
    int? index,
    bool? isRunning,
    DockItemState? state,
    double? offsetY,
    double? offsetX,
    bool? isDragging,
  }) {
    return DockItem(
      iconPath: iconPath ?? this.iconPath,
      label: label ?? this.label,
      index: index ?? this.index,
      isRunning: isRunning ?? this.isRunning,
      state: state ?? this.state,
      offsetY: offsetY ?? this.offsetY,
      offsetX: offsetX ?? this.offsetX,
      isDragging: isDragging ?? this.isDragging,
    );
  }
}

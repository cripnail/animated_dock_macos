import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';
import '../../data/repositories/dock_repository.dart';

class DockController extends ChangeNotifier {
  final DockRepository repository;
  late List<DockItem> _items;
  int? _hoveredIndex;
  int? _draggedIndex;
  bool _isDragging = false;
  bool _isLeavingDock = false;
  double _dockScale = 1.0; // New field for dock scaling

  DockController({required this.repository}) {
    _items = repository.getInitialItems();
  }

  List<DockItem> get items => List.unmodifiable(_items);
  bool get isLeavingDock => _isLeavingDock;
  double get dockScale => _dockScale; // New getter for dock scale

  void onHover(int? index) {
    if (_hoveredIndex != index && !_isDragging) {
      _hoveredIndex = index;
      _updatePositions();
      notifyListeners();
    }
  }

  void startDragging(int index) {
    _isDragging = true;
    _draggedIndex = index;
    _hoveredIndex = null;

    final newItems = List<DockItem>.from(_items);
    newItems[index] = newItems[index].copyWith(
      isDragging: true,
      isRunning: true,
    );
    _items = newItems;
    notifyListeners();
  }

  void handleDockLeave(int index, double dragPositionY, double dockTopY) {
    if (_isDragging && dragPositionY < dockTopY - 50) {
      if (!_isLeavingDock) {
        _isLeavingDock = true;
        final newItems = List<DockItem>.from(_items);

        // Mark dragged icon
        newItems[index] = newItems[index].copyWith(
          isDragging: true,
          isRunning: true,
        );

        // Calculate distance from dock for scaling
        final distanceFromDock = (dockTopY - dragPositionY).clamp(0.0, 200.0);
        _dockScale = 1.0 - (distanceFromDock / 800.0).clamp(0.0, 0.2); // Gradual scaling

        // Adjust spacing between icons
        for (var i = 0; i < newItems.length; i++) {
          if (i == index) continue;

          double offsetX = 0.0;
          if (i < index) {
            offsetX = 8.0 * _dockScale; // Reduced spacing when leaving dock
          } else {
            offsetX = -8.0 * _dockScale; // Reduced spacing when leaving dock
          }

          newItems[i] = newItems[i].copyWith(
            offsetX: offsetX,
            state: DockItemState.normal,
          );
        }

        _items = newItems;
        notifyListeners();
      } else {
        // Update dock scale during drag
        final distanceFromDock = (dockTopY - dragPositionY).clamp(0.0, 200.0);
        _dockScale = 1.0 - (distanceFromDock / 800.0).clamp(0.0, 0.2);
        notifyListeners();
      }
    }
  }

  void handleDockReturn(double dragPositionY, double dockTopY) {
    if (_isLeavingDock && dragPositionY >= dockTopY - 50) {
      _isLeavingDock = false;
      _dockScale = 1.0;

      final newItems = List<DockItem>.from(_items);
      for (var i = 0; i < newItems.length; i++) {
        newItems[i] = newItems[i].copyWith(
          offsetX: 0.0,
          offsetY: 0.0,
          isDragging: false,
          state: DockItemState.normal,
        );
      }

      _items = newItems;
      notifyListeners();
    }
  }

  void updateDragPosition(int targetIndex) {
    if (_draggedIndex == null || targetIndex == _draggedIndex) return;

    final newItems = List<DockItem>.from(_items);
    final draggedItem = newItems.removeAt(_draggedIndex!);
    newItems.insert(targetIndex, draggedItem.copyWith(
      index: targetIndex,
      state: DockItemState.normal,
      offsetX: 0.0,
      offsetY: 0.0,
      isRunning: draggedItem.isRunning,
    ));

    for (var i = 0; i < newItems.length; i++) {
      if (i != targetIndex) {
        newItems[i] = newItems[i].copyWith(
          index: i,
          state: DockItemState.normal,
          offsetX: 0.0,
          offsetY: 0.0,
          isRunning: newItems[i].isRunning,
        );
      }
    }

    _items = newItems;
    _draggedIndex = targetIndex;
    _hoveredIndex = null;
    notifyListeners();
  }

  void resetState() {
    _hoveredIndex = null;
    _draggedIndex = null;
    _isDragging = false;
    _isLeavingDock = false;
    _dockScale = 1.0;

    final newItems = List<DockItem>.from(_items);
    for (var i = 0; i < newItems.length; i++) {
      newItems[i] = newItems[i].copyWith(
        state: DockItemState.normal,
        offsetY: 0.0,
        offsetX: 0.0,
        isDragging: false,
      );
    }

    _items = newItems;
    notifyListeners();
  }

  void _updatePositions() {
    if (_isLeavingDock) return;

    final newItems = List<DockItem>.from(_items);
    final targetIndex = _hoveredIndex;

    for (var i = 0; i < newItems.length; i++) {
      double offsetY = 0.0;

      if (targetIndex != null) {
        final distance = (i - targetIndex).abs();
        offsetY = switch (distance) {
          0 => -10.0,
          1 => -8.0,
          2 => -5.0,
          _ => 0.0
        };
      }

      newItems[i] = newItems[i].copyWith(
        offsetY: offsetY,
        state: i == targetIndex ? DockItemState.hovered : DockItemState.normal,
      );
    }

    _items = newItems;
  }
}
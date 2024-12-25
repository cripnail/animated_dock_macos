import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';
import '../../data/repositories/dock_repository.dart';


class DockController extends ChangeNotifier {
  final DockRepository repository;
  late List<DockItem> _items;
  int? _hoveredIndex;
  int? _draggedIndex;
  bool _isDragging = false;
  static const double _maxOffsetY = -10.0;
  static const double _neighborOffsetY = -6.0;

  DockController({required this.repository}) {
    _items = repository.getInitialItems();
  }

  List<DockItem> get items => List.unmodifiable(_items);

  void onHover(int? index) {
    if (_hoveredIndex != index) {
      _hoveredIndex = index;
      _updatePositions();
      notifyListeners();
    }
  }

  void startDragging(int index) {
    _isDragging = true;
    _draggedIndex = index;
    _updatePositions();
    notifyListeners();
  }

  void endDragging() {
    if (_isDragging) {
      _isDragging = false;
      _draggedIndex = null;
      _hoveredIndex = null;

      final newItems = List<DockItem>.from(_items);
      for (var i = 0; i < newItems.length; i++) {
        newItems[i] = newItems[i].copyWith(
          state: DockItemState.normal,
          offsetY: 0.0,
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
    newItems.insert(targetIndex, draggedItem);

    for (var i = 0; i < newItems.length; i++) {
      newItems[i] = newItems[i].copyWith(index: i);
    }

    _items = newItems;
    _draggedIndex = targetIndex;
    _updatePositions();
    notifyListeners();
  }

  void resetState() {
    _hoveredIndex = null;
    _draggedIndex = null;
    _isDragging = false;

    final newItems = List<DockItem>.from(_items);
    for (var i = 0; i < newItems.length; i++) {
      newItems[i] = newItems[i].copyWith(
        state: DockItemState.normal,
        offsetY: 0.0,
      );
    }

    _items = newItems;
    notifyListeners();
  }

  void handleDesktopDrop(DockItem item) {
    if (_draggedIndex != null) {
      final newItems = List<DockItem>.from(_items);
      newItems.removeAt(_draggedIndex!);

      for (var i = 0; i < newItems.length; i++) {
        newItems[i] = newItems[i].copyWith(index: i);
      }

      _items = newItems;
      _draggedIndex = null;
      notifyListeners();
    }
  }

  void _updatePositions() {
    final newItems = List<DockItem>.from(_items);
    final targetIndex = _hoveredIndex ?? _draggedIndex;

    for (var i = 0; i < newItems.length; i++) {
      double offsetY = 0.0;

      if (targetIndex != null && !_isDragging) {
        final distance = (i - targetIndex).abs();
        if (distance == 0) {
          offsetY = _maxOffsetY;
        } else if (distance <= 2) {
          offsetY = _neighborOffsetY * (1 - (distance / 3));
        }
      }

      newItems[i] = newItems[i].copyWith(
        offsetY: offsetY,
        state: i == targetIndex ? DockItemState.hovered : DockItemState.normal,
      );
    }

    _items = newItems;
  }
}

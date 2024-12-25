import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';
import '../../data/repositories/dock_repository.dart';

class DockController extends ChangeNotifier {
  final DockRepository repository;
  late List<DockItem> _items;
  int? _hoveredIndex;
  int? _draggedIndex;
  bool _isDragging = false;

  // static const double _maxOffsetY = -15.0;
  // static const double _neighborOffsetY = -10.0;
  static const double _maxOffsetY = -10.0;
  static const double _neighborOffsetY = -6.0;
  static const int _itemsAffected = 2;

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

  void _updatePositions() {
    final newItems = List<DockItem>.from(_items);
    final targetIndex = _hoveredIndex ?? _draggedIndex;

    for (var i = 0; i < newItems.length; i++) {
      double offsetY = 0.0;

      if (targetIndex != null) {
        final distance = (i - targetIndex).abs();
        if (distance == 0) {
          offsetY = _maxOffsetY;
        } else if (distance <= _itemsAffected) {
          final factor = 1 - (distance / (_itemsAffected + 1));
          offsetY = _neighborOffsetY * factor;
        }
      }

      newItems[i] = newItems[i].copyWith(
        offsetY: offsetY,
        state: i == targetIndex ? DockItemState.hovered : DockItemState.normal,
      );
    }

    _items = newItems;
  }

  void updateDragPosition(int targetIndex) {
    if (_draggedIndex == null || targetIndex == _draggedIndex) return;

    final newItems = List<DockItem>.from(_items);
    final draggedItem = newItems[_draggedIndex!];

    newItems.removeAt(_draggedIndex!);
    newItems.insert(targetIndex, draggedItem);

    for (var i = 0; i < newItems.length; i++) {
      newItems[i] = newItems[i].copyWith(
        index: i,
        state: DockItemState.normal,
        offsetY: 0.0,
      );
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
}

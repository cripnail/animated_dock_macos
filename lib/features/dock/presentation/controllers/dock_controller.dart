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

  DockController({required this.repository}) {
    _items = repository.getInitialItems();
  }

  List<DockItem> get items => List.unmodifiable(_items);
  bool get isLeavingDock => _isLeavingDock;

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
    // Начинаем смыкание раньше - когда иконка еще внутри дока
    final threshold = dockTopY;

    if (_isDragging && dragPositionY < threshold) {
      if (!_isLeavingDock) {
        _isLeavingDock = true;
        final newItems = List<DockItem>.from(_items);

        // Помечаем перетаскиваемую иконку
        newItems[index] = newItems[index].copyWith(
          isDragging: true,
          isRunning: true,
        );

        // Смещаем соседние иконки
        for (var i = 0; i < newItems.length; i++) {
          if (i == index) continue;

          double offsetX = 0.0;
          if (i < index) {
            offsetX = 6.0; // Уменьшенный просвет
          } else {
            offsetX = -6.0; // Уменьшенный просвет
          }

          // Вычисляем состояние подъема для иконки
          final distance = (i - index).abs();
          final offsetY = switch (distance) {
            0 => 0.0, // Перетаскиваемая иконка
            1 => -8.0, // Ближайшие соседи
            2 => -5.0, // Следующие соседи
            _ => 0.0
          };

          newItems[i] = newItems[i].copyWith(
            offsetX: offsetX,
            offsetY: offsetY, // Сохраняем эффект приподнятости
            state: DockItemState.normal,
          );
        }

        _items = newItems;
        notifyListeners();
      }
    }
  }

  void handleDockReturn(double dragPositionY, double dockTopY) {
    final threshold = dockTopY;

    if (_isLeavingDock && dragPositionY >= threshold) {
      _isLeavingDock = false;

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
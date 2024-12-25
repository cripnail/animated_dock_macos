import 'package:flutter/material.dart';
import '../dock/domain/entities/dock_item.dart';

class DesktopIconController extends ChangeNotifier {
  List<DockItem> _desktopIcons = [];
  final Map<DockItem, Offset> _iconPositions = {};

  List<DockItem> get desktopIcons => List.unmodifiable(_desktopIcons);

  Map<DockItem, Offset> get iconPositions => Map.unmodifiable(_iconPositions);

  void addIcon(DockItem item, Offset position) {
    _desktopIcons = List.from(_desktopIcons)..add(item);
    _iconPositions[item] = position;
    notifyListeners();
  }

  void updateIconPosition(DockItem item, Offset position) {
    if (_iconPositions.containsKey(item)) {
      _iconPositions[item] = position;
      notifyListeners();
    }
  }

  void removeIcon(DockItem item) {
    _desktopIcons.remove(item);
    _iconPositions.remove(item);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';

class DockItemWidget extends StatefulWidget {
  final DockItem item;
  final Function(int?) onHover;
  final Function(int) onDragStart;
  final Function(int?) onDragTargetMove;
  final VoidCallback onDragEnd;

  const DockItemWidget({
    super.key,
    required this.item,
    required this.onHover,
    required this.onDragStart,
    required this.onDragTargetMove,
    required this.onDragEnd,
  });

  @override
  State<DockItemWidget> createState() => _DockItemWidgetState();
}

class _DockItemWidgetState extends State<DockItemWidget> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHover(widget.item.index),
      onExit: (_) => widget.onHover(null),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutQuart,
              transform: Matrix4.identity()
                ..translate(0.0, widget.item.offsetY.clamp(-10.0, 10.0)),
              child: Image.asset(
                widget.item.iconPath,
                width: 50 * widget.item.scale,
                height: 50 * widget.item.scale,
                fit: BoxFit.contain,
              ),
            ),
            if (widget.item.isRunning)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

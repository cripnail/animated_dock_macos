import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';

class DockItemWidget extends StatefulWidget {
  final DockItem item;
  final Function(int?) onHover;
  final Function(int) onDragStart;
  final Function(int?) onDragTargetMove;
  final VoidCallback onDragEnd;

  const DockItemWidget({
    Key? key,
    required this.item,
    required this.onHover,
    required this.onDragStart,
    required this.onDragTargetMove,
    required this.onDragEnd,
  }) : super(key: key);

  @override
  State<DockItemWidget> createState() => _DockItemWidgetState();
}

Widget _buildDockItem(DockItem item) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeOutQuart,
    alignment: Alignment.center,
    transform: Matrix4.identity()
      ..translate(0.0, item.offsetY),
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(
            item.iconPath,
            fit: BoxFit.contain,
          ),
        ),
        if (item.isRunning)
          Positioned(
            bottom: -6,
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
  );
}
class _DockItemWidgetState extends State<DockItemWidget> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHover(widget.item.index),
      onExit: (_) => widget.onHover(null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuart,
        transform: Matrix4.identity()
          ..scale(widget.item.scale)
          ..translate(0.0, widget.item.offsetY),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Image.asset(
                widget.item.iconPath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              if (widget.item.isRunning)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';
import '../controllers/dock_controller.dart';

class DockContainer extends StatelessWidget {
  final DockController controller;

  const DockContainer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 70,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: ClipRect(
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < controller.items.length; i++)
                        _buildDraggableItem(i),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    final item = controller.items[index];
    return DragTarget<DockItem>(
      onWillAccept: (data) => data != item,
      onAccept: (data) => controller.updateDragPosition(index),
      builder: (context, candidateData, rejectedData) {
        return Draggable<DockItem>(
          data: item,
          feedback: _buildFeedback(item),
          childWhenDragging: _buildPlaceholder(),
          onDragStarted: () => controller.startDragging(index),
          onDragEnd: (details) {
            if (!details.wasAccepted) {
              controller.resetState();
            } else {
              controller.endDragging();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: MouseRegion(
              onEnter: (_) => controller.onHover(index),
              onExit: (_) => controller.onHover(null),
              child: _buildDockItem(item),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDockItem(DockItem item) {
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutQuart,
            transform: Matrix4.identity()..translate(0.0, item.offsetY),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                item.iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (item.isRunning)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeedback(DockItem item) {
    return Opacity(
      opacity: 0.8,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          item.iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Opacity(
      opacity: 0.3,
      child: SizedBox(
        width: 50,
        height: 50,
      ),
    );
  }
}

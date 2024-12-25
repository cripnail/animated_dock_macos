import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/dock_item.dart';
import '../controllers/dock_controller.dart';

class DockContainer extends StatelessWidget {
  final DockController controller;

  const DockContainer({super.key, required this.controller});

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
              height: 70,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < controller.items.length; i++)
                    _buildDraggableItem(i),
                ],
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
      width: 50,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, item.offsetY.clamp(-8.0, 8.0)) // Уменьшили с 10 до 8
                ..scale(1.0 + (item.offsetY.abs().clamp(0.0, 8.0) / 60)), // Уменьшили масштаб с 50 до 60
              transformAlignment: Alignment.center,
              child: Image.asset(
                item.iconPath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (item.isRunning)
            Align(
              alignment: const Alignment(0.0, 0.9),
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
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
    return const Opacity(
      opacity: 0.3,
      child: SizedBox(
        width: 50,
        height: 50,
      ),
    );
  }
}

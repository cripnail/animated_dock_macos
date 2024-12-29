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
                    Colors.white.withAlpha((0.3 * 255).round()),
                    Colors.white.withAlpha((0.2 * 255).round()),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return DragTarget<DockItem>(
                    onWillAcceptWithDetails: (details) => true,
                    onAcceptWithDetails: (details) {
                      controller.updateDragPosition(index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400), // Увеличенная длительность
                        curve: Curves.easeOutCubic, // Более плавная кривая
                        transform: Matrix4.identity()
                          ..translate(item.offsetX, item.offsetY),
                        child: Draggable<DockItem>(
                          data: item,
                          feedback: _buildFeedback(item),
                          // Анимированное изменение просвета
                          childWhenDragging: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: controller.isLeavingDock ? 12 : 62,
                            curve: Curves.easeOutCubic,
                          ),
                          onDragStarted: () {
                            controller.startDragging(index);
                          },
                          onDragUpdate: (details) {
                            final RenderBox box =
                            context.findRenderObject() as RenderBox;
                            final dockPosition = box.localToGlobal(Offset.zero);
                            final dockTopY = dockPosition.dy;

                            controller.handleDockLeave(
                              index,
                              details.globalPosition.dy,
                              dockTopY,
                            );

                            controller.handleDockReturn(
                              details.globalPosition.dy,
                              dockTopY,
                            );
                          },
                          onDragEnd: (details) {
                            controller.resetState();
                          },
                          onDraggableCanceled: (velocity, offset) {
                            controller.resetState();
                          },
                          child: MouseRegion(
                            onEnter: (_) => controller.onHover(index),
                            onExit: (_) => controller.onHover(null),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: _buildDockItem(item),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
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
            child: Image.asset(
              item.iconPath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
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
}
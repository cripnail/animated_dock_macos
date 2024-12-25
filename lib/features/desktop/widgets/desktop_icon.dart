import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dock/domain/entities/dock_item.dart';
import '../desktop_icon_controller.dart';

class DesktopIcon extends StatelessWidget {
  final DockItem item;

  const DesktopIcon({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<DockItem>(
      data: item,
      feedback: _buildFeedback(),
      childWhenDragging: Container(),
      onDragEnd: (details) {
        if (details.wasAccepted) return;
        if (details.offset.dy < MediaQuery.of(context).size.height - 100) {
          context.read<DesktopIconController>().updateIconPosition(
                item,
                details.offset,
              );
        }
      },
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(
            item.iconPath,
            width: 48,
            height: 48,
          ),
          Text(
            item.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Opacity(
      opacity: 0.8,
      child: _buildIcon(),
    );
  }
}

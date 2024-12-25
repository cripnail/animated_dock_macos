import 'package:flutter/material.dart';

import '../../domain/entities/dock_item.dart';

class MacOSDockIcon extends StatelessWidget {
  final DockItem item;

  const MacOSDockIcon({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          item.iconPath,
          width: 50 * item.scale,
          height: 50 * item.scale,
        ),
        if (item.isRunning)
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

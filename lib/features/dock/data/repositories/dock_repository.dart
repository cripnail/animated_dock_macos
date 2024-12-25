import 'package:flutter/foundation.dart';

import '../../domain/entities/dock_item.dart';

class DockRepository {
  List<DockItem> getInitialItems() {
    if (kDebugMode) {
      print('Loading dock items...');
    }

    return [
      DockItem(
        iconPath: 'assets/icons/files.png',
        label: 'Files',
        index: 0,
        isRunning: true,
      ),
      DockItem(
        iconPath: 'assets/icons/control.png',
        label: 'Control',
        index: 1,
      ),
      DockItem(
        iconPath: 'assets/icons/twitch.png',
        label: 'Twitch',
        index: 2,
        isRunning: true,
      ),
      DockItem(
        iconPath: 'assets/icons/twitter.png',
        label: 'Twitter',
        index: 3,
      ),
      DockItem(
        iconPath: 'assets/icons/vlc.png',
        label: 'VLC',
        index: 4,
        isRunning: true,
      ),
      DockItem(
        iconPath: 'assets/icons/wreckfest.png',
        label: 'Wreckfest',
        index: 5,
      ),
      DockItem(
        iconPath: 'assets/icons/xonotic.png',
        label: 'Xonotic',
        index: 6,
      ),
      DockItem(
        iconPath: 'assets/icons/discord.png',
        label: 'Discord',
        index: 7,
      ),
      DockItem(
        iconPath: 'assets/icons/disneyplus.png',
        label: 'Disneyplus',
        index: 8,
      ),
      DockItem(
        iconPath: 'assets/icons/netflix.png',
        label: 'Netflix',
        index: 9,
      ),
    ];
  }
}

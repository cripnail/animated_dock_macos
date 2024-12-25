import '../../domain/entities/dock_item.dart';

class DockRepository {
  List<DockItem> getInitialItems() {
    print('Loading dock items...');

    return [
      DockItem(
        iconPath: 'assets/icons/cmd.png',
        label: 'Cmd',
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
    ];
  }
}

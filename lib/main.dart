import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/desktop/desktop_icon_controller.dart';
import 'features/desktop/widgets/desktop_icon.dart';
import 'features/dock/presentation/controllers/dock_controller.dart' as dock;
import 'features/dock/data/repositories/dock_repository.dart';
import 'features/dock/presentation/widgets/dock_container.dart';

void main() {
  final dockRepository = DockRepository();
  final dockController = dock.DockController(repository: dockRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<dock.DockController>.value(
          value: dockController,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => dock.DockController(repository: DockRepository())),
          ChangeNotifierProvider(create: (_) => DesktopIconController()),
        ],
        child: const DesktopScreen(),
      ),
    );
  }
}

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2E5DD1),
                  Color(0xFF97BBE9),
                  Color(0xFFF1F5FB),
                ],
              ),
            ),
          ),
          // Desktop Icons Layer
          Consumer<DesktopIconController>(
            builder: (context, desktopController, _) {
              return Stack(
                children: [
                  for (final entry in desktopController.iconPositions.entries)
                    Positioned(
                      left: entry.value.dx,
                      top: entry.value.dy,
                      child: DesktopIcon(item: entry.key),
                    ),
                ],
              );
            },
          ),
          // Dock
          Consumer<dock.DockController>(
            builder: (context, dockController, _) => Align(
              alignment: Alignment.bottomCenter,
              child: DockContainer(controller: dockController),
            ),
          ),
        ],
      ),
    );
  }
}

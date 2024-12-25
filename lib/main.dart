import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/desktop/desktop_icon_controller.dart';
import 'features/desktop/widgets/desktop_icon.dart';
import 'features/dock/domain/entities/dock_item.dart';
import 'features/dock/presentation/controllers/dock_controller.dart';
import 'features/dock/presentation/widgets/dock_container.dart';
import 'features/dock/data/repositories/dock_repository.dart';

void main() {
  final dockRepository = DockRepository();
  final dockController = DockController(repository: dockRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DockController>.value(
          value: dockController,
        ),
      ],
      child: MyApp(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFF2E5DD1),
//                     Color(0xFF97BBE9),
//                     Color(0xFFF1F5FB),
//                   ],
//                 ),
//               ),
//             ),
//             DragTarget<DockItem>(
//               onWillAccept: (data) => data != null,
//               onAccept: (data) {
//                 context.read<DockController>().handleDesktopDrop(data);
//               },
//               builder: (context, candidateData, rejectedData) {
//                 return const SizedBox.expand();
//               },
//             ),
//             Consumer<DockController>(
//               builder: (context, controller, _) => Align(
//                 alignment: Alignment.bottomCenter,
//                 child: DockContainer(
//                   controller: controller,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => DockController(repository: DockRepository())),
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
          Consumer<DockController>(
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

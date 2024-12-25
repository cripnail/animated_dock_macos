// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../../features/dock/data/repositories/dock_repository.dart';
import '../../features/dock/presentation/controllers/dock_controller.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Repositories
  getIt.registerLazySingleton<DockRepository>(
    () => DockRepository(),
  );

  // Controllers
  getIt.registerLazySingleton<DockController>(
    () => DockController(repository: getIt()),
  );
}

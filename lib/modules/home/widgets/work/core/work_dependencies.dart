import 'package:esteticy/index.dart';

void setupWorkDependencies() {
  getIt.registerLazySingleton<WorkRepository>(() => WorkRepository());
  getIt.registerLazySingleton<WorkProvider>(() => WorkProvider());
}

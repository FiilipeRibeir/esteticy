import 'package:esteticy/index.dart';

void setupHomeDependencies() {
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepository());
  getIt.registerLazySingleton<HomeProvider>(() => HomeProvider());
}

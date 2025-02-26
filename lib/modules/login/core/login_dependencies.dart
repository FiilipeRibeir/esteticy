import 'package:esteticy/index.dart';

void setupLoginDependencies() {
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository());
  getIt.registerLazySingleton<LoginProvider>(() => LoginProvider());
}

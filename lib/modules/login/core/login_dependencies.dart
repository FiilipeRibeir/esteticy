import 'package:get_it/get_it.dart';
import 'package:esteticy/index.dart';

final getIt = GetIt.instance;

void setupLoginDependencies() {
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository());
  getIt.registerLazySingleton<LoginProvider>(() => LoginProvider());
}

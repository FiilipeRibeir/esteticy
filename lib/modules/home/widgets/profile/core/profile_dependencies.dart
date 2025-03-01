import 'package:esteticy/index.dart';

void setupProfileDependencies() {
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  getIt.registerLazySingleton<ProfileProvider>(() => ProfileProvider());
}

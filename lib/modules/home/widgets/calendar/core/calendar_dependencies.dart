import 'package:esteticy/index.dart';

void setupCalendarDependencies() {
  getIt.registerLazySingleton<CalendarRepository>(() => CalendarRepository());
  getIt.registerLazySingleton<CalendarProvider>(() => CalendarProvider());
}

import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await initializeDateFormatting('pt_BR', null);

  WidgetsFlutterBinding.ensureInitialized();
  setupLoginDependencies();
  setupProfileDependencies();
  setupWorkDependencies();
  setupHomeDependencies();
  setupCalendarDependencies();

  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<WorkProvider>()),
      ],
      child: const AppPage(),
    ),
  );
}

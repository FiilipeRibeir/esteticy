import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLoginDependencies();
  setupProfileDependencies();

  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
      ],
      child: const AppPage(),
    ),
  );
}

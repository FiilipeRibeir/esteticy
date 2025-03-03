import 'package:esteticy/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final _router = AppRouter.init();

  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Esteticy',
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: '.SF Pro Text',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 17),
          bodyMedium: TextStyle(fontSize: 15),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CupertinoColors.systemBackground,
          foregroundColor: CupertinoColors.label,
          elevation: 0,
        ),
      ),
      routerConfig: _router,
    );
  }
}

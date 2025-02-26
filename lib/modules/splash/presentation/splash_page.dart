import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashController _splashController = SplashController();

  @override
  void initState() {
    super.initState();
    _splashController.checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8E2DE2),
              Color(0xFFDA4453),
              Color(0xFFF37335),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'Esteticy',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 48,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

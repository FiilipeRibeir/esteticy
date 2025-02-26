import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashController {
  final LoginProvider loginProvider = getIt<LoginProvider>();

  Future<void> checkLoginStatus(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await loginProvider.checkLoginStatus();
    context.go(isLoggedIn ? '/home' : '/login');
  }
}

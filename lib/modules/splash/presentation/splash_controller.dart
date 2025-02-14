import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashController {
  Future<void> checkLoginStatus(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)); 

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    bool isLoggedIn = await loginProvider.checkLoginStatus();

    if (isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }
}

import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginProvider extends ChangeNotifier {
  final LoginRepository loginRepository = getIt<LoginRepository>();
  final storage = FlutterSecureStorage();
  bool isloading = false;
  String? jwt;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isloading = true;
      notifyListeners();

      final token = await loginRepository.signInWithGoogle();

      if (token == null) {
        throw Exception('Erro ao obter token de autenticação.');
      }

      jwt = token;
      await storage.write(key: 'jwt', value: jwt!);

      context.go('/home');
    } catch (e) {
      print("Erro de login: $e");
      if (context.mounted) {
        showErrorDialog(context, 'Erro', e.toString());
      }
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await loginRepository.signOut(); 
    jwt = null; 
    await storage.delete(key: 'jwt'); 
    notifyListeners(); 
    context.go('/login');
  }

  Future<bool> checkLoginStatus() async {
    final storedJwt = await storage.read(key: 'jwt');
    if (storedJwt == null) {
      return false;
    } else {
      jwt = storedJwt;
      notifyListeners();
      return true;
    }
  }
}

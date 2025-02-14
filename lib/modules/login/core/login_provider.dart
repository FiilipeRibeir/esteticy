import 'dart:convert';

import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  final storage = FlutterSecureStorage();

  String? _jwt;
  bool _isLoading = false;

  String? get jwt => _jwt;
  bool get isLoading => _isLoading;

  Future<void> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _loginRepository.signInWithGoogle();
      _jwt = token;

      if (_jwt != null) {
        final googleUser = await _getGoogleUserInfo();

        if (googleUser != null) {
          final createdUser = await _createUserInBackend(googleUser);

          if (createdUser != null) {
            context.go('/home');
          } else {
            showErrorDialog(context, 'Erro ao criar usuário',
                'Falha ao criar usuário no backend. Tente novamente mais tarde.');
          }
        } else {
          showErrorDialog(context, 'Erro ao obter informações do Google',
              'Não foi possível obter as informações do usuário. Tente novamente mais tarde.');
        }
      } else {
        showErrorDialog(context, 'Erro ao fazer login',
            'Houve um erro ao tentar autenticar. Tente novamente mais tarde.');
      }
    } catch (e) {
      if (context.mounted) {
        showErrorDialog(context, 'Erro de autenticação', 'Erro: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>?> _getGoogleUserInfo() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final userInfo = {
        'name': googleUser.displayName ?? 'Sem nome',
        'nickname': googleUser.displayName?.split(' ').first ?? 'Sem apelido',
        'email': googleUser.email,
      };

      return userInfo;
    } catch (e) {
      print("Erro ao obter informações do Google: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _createUserInBackend(
      Map<String, String> googleUser) async {
    final url =
        Uri.parse('https://esteticy-backend-production.up.railway.app/user');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': googleUser['name'],
        'nickname': googleUser['nickname'],
        'email': googleUser['email'],
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await _loginRepository.signOut();
    _jwt = null;
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    String? token = await storage.read(key: 'jwt');
    return token != null && token.isNotEmpty;
  }
}

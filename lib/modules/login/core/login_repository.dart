import 'package:esteticy/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final storage = FlutterSecureStorage();

  Future<String?> signInWithGoogle() async {
    final supabase = Supabase.instance.client;

    try {
      // Inicializa o GoogleSignIn
      const webClientId = Config.googleClientId;
      final googleSignIn = GoogleSignIn(serverClientId: webClientId);

      // Faz o login com o Google
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Falha ao obter token de autenticação.';
      }

      // Autentica no Supabase com os tokens do Google
      final authResponse = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Armazena o JWT no FlutterSecureStorage
      final session = authResponse.session;
      if (session?.accessToken != null) {
        final accessToken = session!.accessToken;
        await storage.write(key: 'jwt', value: accessToken);
        return accessToken;
      } else {
        throw 'Falha ao obter token de autenticação';
      }
    } catch (e) {
      print("Erro de autenticação com Google: $e");
      throw Exception("Falha ao autenticar com Google: $e");
    }
  }

  Future<void> signOut() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    await storage.delete(key: 'jwt');
  }
}

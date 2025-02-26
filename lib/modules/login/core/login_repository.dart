import 'package:esteticy/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final storage = FlutterSecureStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final http = HttpService();

  Future<String?> signInWithGoogle() async {
    final supabase = Supabase.instance.client;

    try {
      const webClientId = Config.googleClientId;
      const androidClientId = Config.androidClientId;
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: androidClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final userData = {
        'name': googleUser.displayName!,
        'nickname': googleUser.displayName!.split(' ')[0],
        'email': googleUser.email,
      };

      await createUser(userData);

      final jwtUserData = {
        'idToken': googleAuth.idToken!,
      };

      final userJwt = await jwtUser(jwtUserData);

      if (userJwt == null || !userJwt.containsKey('access_token')) {
        throw 'Erro ao obter access_token do backend.';
      }

      final accessTokenFromBackend = userJwt['access_token'];
      await storage.write(key: 'jwt', value: accessTokenFromBackend);

      print(accessTokenFromBackend);

      return accessTokenFromBackend;
    } catch (e) {
      throw Exception("Erro no login com Google: $e");
    }
  }

  Future<void> signOut() async {
    final supabase = Supabase.instance.client;
    await googleSignIn.signOut();
    await supabase.auth.signOut();
    await storage.delete(key: 'jwt');
  }

  Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> googleUser) async {
    try {
      final response = await http.postWithoutAuth('/user', googleUser);
      return response;
    } catch (e) {
      throw Exception("Erro ao criar usuário no backend: $e");
    }
  }

  Future<Map<String, dynamic>?> jwtUser(Map<String, String> jwtUser) async {
    try {
      final response = await http.postWithoutAuth('/oauth/user', jwtUser);
      return response;
    } catch (e) {
      throw Exception("Erro ao criar jwt no backend: $e");
    }
  }
}

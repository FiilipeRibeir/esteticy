import 'package:esteticy/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider {
  final HomeRepository homeRepository = HomeRepository();
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final email = user.email;
    try {
      final userData = await homeRepository.getUserData(email!);
      return userData;
    } catch (e) {
      throw Exception("Erro ao buscar dados do usuário: $e");
    }
  }
}

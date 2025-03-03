import 'package:esteticy/index.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository = ProfileRepository();
  final supabase = Supabase.instance.client;

  int _agendamentosHoje = 0;
  int get agendamentosHoje => _agendamentosHoje;

  Future<void> fetchData() async {
    try {
      final List appointments = await profileRepository.fetchData();
      _agendamentosHoje = appointments.length;

      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao buscar dados: $e");
    }
  }
}

import 'package:esteticy/index.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List _works = [];
  List get works => _works;

  Future<void> createWork(Map<String, dynamic> workData) async {
    try {
      await getIt<WorkRepository>().createWork(workData);
      await fetchWorkData();
    } catch (e) {
      throw Exception("Erro ao criar trabalho: $e");
    }
  }

  Future<void> fetchWorkData() async {
    try {
      final userData = await getIt<HomeProvider>().getUser();
      final userid = userData['id'];
      _works = await getIt<WorkRepository>().getWorkData(userid);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao buscar dados: $e");
    }
  }

  Future<void> updateWork(String id, Map<String, dynamic> workData) async {
    try {
      await getIt<WorkRepository>().updateWork(id, workData);
      await fetchWorkData();
    } catch (e) {
      throw Exception("Erro ao buscar dados: $e");
    }
  }

  Future<void> deleteWork(String workId) async {
    try {
      await getIt<WorkRepository>().deleteWork(workId);
      await fetchWorkData();
    } catch (e) {
      throw Exception("Erro ao deletar trabalho: $e");
    }
  }
}

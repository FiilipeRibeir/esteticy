import 'package:esteticy/index.dart';

class WorkRepository {
  final http = HttpService();

  Future<Map<String, dynamic>> createWork(Map<String, dynamic> workData) async {
    try {
      final response = await http.post('/work', workData);
      return response;
    } catch (e) {
      throw Exception("Erro ao criar trabalho: $e");
    }
  }

  Future<List> getWorkData(String id) async {
    try {
      final response = await http.get(
        '/work',
        queryParameters: {'userId': id},
      );
      return response;
    } catch (e) {
      throw Exception("Erro ao buscar dados do trabalho: $e");
    }
  }

  Future<Map<String, dynamic>> updateWork(
      String id, Map<String, dynamic> workData) async {
    try {
      final response = await http.put(
        '/work/$id',
        workData,
      );
      return response;
    } catch (e) {
      throw Exception("Erro ao atualizar trabalho: $e");
    }
  }

  Future<void> deleteWork(String id) async {
    try {
      await http.delete('/work/$id');
    } catch (e) {
      throw Exception("Erro ao deletar trabalho: $e");
    }
  }
}

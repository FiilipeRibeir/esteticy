import 'package:esteticy/modules/shared/index.dart';

class CalendarRepository {
  final http = HttpService();

  Future<Map<String, dynamic>> getClientData(String id) async {
    try {
      final response = await http.get('/clients/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Erro ao buscar dados do cliente: $e");
    }
  }

  Future<List> getAppointmentData(String id, String date) async {
    try {
      final response = await http.get(
        '/appointment/filtered',
        queryParameters: {'userId': id, 'date': date},
      );
      return response;
    } catch (e) {
      throw Exception("Erro ao buscar dados do trabalho: $e");
    }
  }
}

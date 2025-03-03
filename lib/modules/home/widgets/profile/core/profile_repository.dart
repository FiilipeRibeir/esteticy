import 'package:esteticy/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final http = HttpService();
  final supabase = Supabase.instance.client;

  Future<List> fetchData() async {
    try {
      final userData = await HomeProvider().getUser();
      final dataLocal =
          DateTime.now().toUtc().subtract(const Duration(hours: 3));
      final userid = userData['id'];
      return await getAppointmentsData(dataLocal, userid);
    } catch (e) {
      throw Exception("Erro no home com fetchData: $e");
    }
  }

  Future<List> getAppointmentsData(DateTime data, String id) async {
    try {
      final response =
          await http.get('/appointment/filtered', queryParameters: {
        'userId': id,
        'date': data.toString().split(' ')[0],
      });
      return response is List<dynamic>
          ? response
          : throw Exception("Resposta inesperada: ${response.runtimeType}");
    } catch (e) {
      throw Exception("Erro ao buscar dados do compromisso: $e");
    }
  }
}

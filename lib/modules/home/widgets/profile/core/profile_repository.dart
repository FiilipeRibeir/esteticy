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

  Future<double> getTotalPaidByUser(String userId) async {
    const tableName = 'appointments';
    const paid = 'paidAmount';

    try {
      final response =
          await supabase.from(tableName).select(paid).eq('"userId"', userId);

      final List<dynamic> data = response as List<dynamic>;
      if (data.isEmpty) return 0.0;

      double total = data.fold(0.0, (prev, e) {
        double amount = (e['paidAmount'] as num?)?.toDouble() ?? 0.0;
        return prev + amount;
      });

      return total;
    } catch (e) {
      throw Exception("Erro ao calcular o total de pagamentos: $e");
    }
  }
}

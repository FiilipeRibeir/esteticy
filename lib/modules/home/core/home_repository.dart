import 'package:esteticy/modules/shared/network/index.dart';

class HomeRepository {
  final http = HttpService();
  
  Future<Map<String, dynamic>> getUserData(String emailUser) async {
    try {
      return await http.get('/user', queryParameters: {'email': emailUser});
    } catch (e) {
      throw Exception("Erro ao buscar dados do usuário: $e");
    }
  }
}

import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarProvider extends ChangeNotifier {
  List _appointments = [];
  List get appointments => _appointments;

  final List _clientData = [];
  List get clientData => _clientData;

  Future<Map<String, dynamic>?> fetchClientData(String id) async {
    try {
      final clientData = await getIt<CalendarRepository>().getClientData(id);
      return clientData;
    } catch (e) {
      throw Exception("Erro ao buscar dados do cliente: $e");
    }
  }

  Future<List> fetchAppointmentData(DateTime selectedDate) async {
    try {
      final userData = await getIt<HomeProvider>().getUser();
      final userId = userData['id'];

      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      _appointments = await getIt<CalendarRepository>()
          .getAppointmentData(userId, formattedDate);

      notifyListeners();
      return _appointments;
    } catch (e) {
      throw Exception("Erro ao buscar dados: $e");
    }
  }
}

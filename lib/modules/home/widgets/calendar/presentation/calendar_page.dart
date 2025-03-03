import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 90, bottom: 140),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TableCalendar(
                  locale: 'pt_BR',
                  firstDay:
                      DateTime.now().subtract(const Duration(days: 5 * 365)),
                  lastDay: DateTime.now().add(const Duration(days: 5 * 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    rightChevronVisible: true,
                    leftChevronVisible: true,
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leftChevronIcon: IconButton(
                      icon: const Icon(Icons.today, color: Colors.purple),
                      onPressed: () {
                        setState(() {
                          _selectedDay = DateTime.now();
                          _focusedDay = DateTime.now();
                        });
                      },
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder<List>(
              future:
                  getIt<CalendarProvider>().fetchAppointmentData(_selectedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return CustomCard(
                    title: "Erro",
                    child: Text(
                      "Erro ao carregar os dados: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const CustomCard(
                    title: "Nenhum compromisso",
                    child: Text("Nenhum compromisso agendado para essa data."),
                  );
                }

                snapshot.data!.sort((a, b) {
                  DateTime timeA = DateTime.parse(a['date'] ?? '');
                  DateTime timeB = DateTime.parse(b['date'] ?? '');
                  return timeA.compareTo(timeB);
                });

                return CustomCard(
                  title: 'Compromissos',
                  titleColor: Colors.white,
                  color: Colors.white.withOpacity(0.01),
                  child: Column(
                    children: snapshot.data!.map((appointment) {
                      final clientId = appointment['clientId'] ?? '';
                      final title = appointment['title'] ?? 'Não informado';
                      final appointmentStatus =
                          appointment['status'] ?? 'Não informado';

                      String appointmentTime = "Horário não informado";
                      if (appointment['date'] != null) {
                        DateTime appointmentTimeDate =
                            DateTime.parse(appointment['date']);
                        appointmentTime =
                            "${DateFormat('HH:mm').format(appointmentTimeDate)}h";
                      }

                      return FutureBuilder<Map<String, dynamic>?>(
                        future:
                            getIt<CalendarProvider>().fetchClientData(clientId),
                        builder: (context, clientSnapshot) {
                          if (clientSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (clientSnapshot.hasError) {
                            return const Center(
                              child: Text(
                                "Erro ao carregar cliente",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          final clientData = clientSnapshot.data;
                          final clientName =
                              clientData?['name'] ?? 'Não informado';

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.calendar_today, size: 40),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cliente: $clientName",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Titulo: $title",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        "Status: $appointmentStatus",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    appointmentTime,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

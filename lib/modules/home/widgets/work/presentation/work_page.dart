import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorksPage extends StatefulWidget {
  const WorksPage({super.key});

  @override
  State<WorksPage> createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  @override
  void initState() {
    super.initState();
    getIt<WorkProvider>().fetchWorkData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Stack(
        children: [
          Consumer<WorkProvider>(
            builder: (context, workProvider, child) {
              final works = workProvider.works;

              if (works.isEmpty) {
                return const Center(
                  child: Text("Nenhum trabalho cadastrado"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                itemCount: works.length,
                itemBuilder: (context, index) {
                  final work = works[index];
                  final name = work["name"];
                  final description = work["description"];
                  final price = work["price"];
                  final id = work["id"];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () => showUpdateWorkCard(
                          context,
                          id,
                          work,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (description != null)
                              Text(
                                description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              "Preço: R\$ ${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        leading: const Icon(Icons.work, color: Colors.purple),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteWorkCard(context, id),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.65,
            child: FloatingActionButton.extended(
              onPressed: () {
                showCreateWorkCard(context);
              },
              label: const Text('Serviço'),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

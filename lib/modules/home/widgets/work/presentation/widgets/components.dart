import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';

void showCreateWorkCard(BuildContext context) {
  showOverlay(context, (onClose) => _CreateWorkCard(onClose: onClose));
}

void showUpdateWorkCard(
    BuildContext context, String id, Map<String, dynamic> work) {
  showOverlay(context,
      (onClose) => _UpdateWorkCard(workId: id, work: work, onClose: onClose));
}

void showDeleteWorkCard(BuildContext context, String workId) {
  showOverlay(
      context, (onClose) => _DeleteWorkCard(workId: workId, onClose: onClose));
}

class _CreateWorkCard extends StatefulWidget {
  final VoidCallback onClose;

  const _CreateWorkCard({required this.onClose});

  @override
  State<_CreateWorkCard> createState() => _CreateWorkCardState();
}

class _CreateWorkCardState extends State<_CreateWorkCard> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "Criar Serviço",
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              label: "Nome",
              validator: (value) =>
                  value!.isEmpty ? "Por favor, insira um nome." : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
                controller: descriptionController, label: "Descrição"),
            const SizedBox(height: 12),
            _buildTextField(
              controller: priceController,
              label: "Preço",
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? "Por favor, insira um preço." : null,
            ),
            const SizedBox(height: 16),
            _buildButtonRow(
              onCancel: widget.onClose,
              onConfirm: () async {
                if (formKey.currentState!.validate()) {
                  final user = await getIt<HomeProvider>().getUser();
                  final workProvider = getIt<WorkProvider>();

                  await workProvider.createWork({
                    'userId': user['id'],
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                  });

                  widget.onClose();
                }
              },
              confirmText: "Criar",
              confirmColor: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateWorkCard extends StatefulWidget {
  final String workId;
  final Map<String, dynamic> work;
  final VoidCallback onClose;

  const _UpdateWorkCard({
    required this.workId,
    required this.work,
    required this.onClose,
  });

  @override
  State<_UpdateWorkCard> createState() => _UpdateWorkCardState();
}

class _UpdateWorkCardState extends State<_UpdateWorkCard> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.work["name"]);
    descriptionController =
        TextEditingController(text: widget.work["description"]);
    priceController =
        TextEditingController(text: widget.work["price"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "Editar Serviço",
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              label: "Nome",
              validator: (value) =>
                  value!.isEmpty ? "Por favor, insira um nome." : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: descriptionController,
              label: "Descrição",
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: priceController,
              label: "Preço",
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? "Por favor, insira um preço." : null,
            ),
            const SizedBox(height: 16),
            _buildButtonRow(
              onCancel: widget.onClose,
              onConfirm: () async {
                if (formKey.currentState!.validate()) {
                  final workProvider = getIt<WorkProvider>();

                  await workProvider.updateWork(
                    widget.workId,
                    {
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                    },
                  );

                  widget.onClose();
                }
              },
              confirmText: "Salvar",
              confirmColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteWorkCard extends StatelessWidget {
  final String workId;
  final VoidCallback onClose;

  const _DeleteWorkCard({required this.workId, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: "Excluir Serviço",
      child: Column(
        children: [
          const Text(
            "Tem certeza que deseja excluir este serviço? Esta ação não pode ser desfeita.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildButtonRow(
            onCancel: onClose,
            onConfirm: () async {
              final workProvider = getIt<WorkProvider>();
              await workProvider.deleteWork(workId);
              onClose();
            },
            confirmText: "Excluir",
            confirmColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({required String title, required Widget child}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(child: child),
        ],
      ),
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    validator: validator,
  );
}

Widget _buildButtonRow({
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
  required String confirmText,
  required Color confirmColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildButton(
        text: "Cancelar",
        color: Colors.grey[300]!,
        textColor: Colors.black,
        onPressed: onCancel,
      ),
      _buildButton(
        text: confirmText,
        color: confirmColor,
        textColor: Colors.white,
        onPressed: onConfirm,
      ),
    ],
  );
}

Widget _buildButton({
  required String text,
  required Color color,
  required Color textColor,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  );
}

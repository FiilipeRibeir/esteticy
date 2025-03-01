import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildInfoTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Future<void> confirmSignOut(BuildContext context) async {
  final bool? shouldLogout = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Sair"),
      content: const Text("Tem certeza que deseja sair da conta?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Sair"),
        ),
      ],
    ),
  );

  if (shouldLogout == true) {
    // ignore: use_build_context_synchronously
    await getIt<LoginProvider>().signOut(context);

    if (context.mounted) {
      context.go('/login');
    }
  }
}

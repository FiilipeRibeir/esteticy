import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getIt<ProfileProvider>().fetchData();
  }

  Future<void> _refreshData() async {
    await getIt<ProfileProvider>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Usuário não autenticado."),
      );
    }

    final String userName = user.userMetadata?['full_name'] ?? "Usuário";
    final String userEmail = user.email ?? "Email não encontrado";
    final String userPhotoUrl =
        user.userMetadata?['avatar_url'] ?? "https://via.placeholder.com/150";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => confirmSignOut(
                context), // Chamando a função de logout do novo arquivo
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8E2DE2),
                    Color(0xFFDA4453),
                    Color(0xFFF37335)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 100),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      userPhotoUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://via.placeholder.com/150",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Olá, $userName!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  userEmail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      return Column(
                        children: [
                          buildInfoTile(
                            // Usando a função de buildInfoTile importada
                            "📅 Agendamentos hoje",
                            "${profileProvider.agendamentosHoje}",
                          ),
                          buildInfoTile(
                            // Usando a função de buildInfoTile importada
                            "💰 Saldo disponível",
                            "R\$ future...",
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:esteticy/index.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    const PaymentsPage(),
    const ClientsPage(),
    const CalendarPage(),
    const WorksPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipPath(
            clipper: BottomClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8E2DE2),
                    Color(0xFFDA4453),
                    Color(0xFFF37335),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: _currentIndex == 2 ? Colors.purple : Colors.grey,
                  size: 35,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavIcon(Icons.payment, 0),
                _buildNavIcon(Icons.people, 1),
                const SizedBox(width: 70),
                _buildNavIcon(Icons.work_outline, 3),
                _buildNavIcon(Icons.account_circle, 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Icon(
        icon,
        color: _currentIndex == index ? Colors.purple : Colors.grey,
        size: 30,
      ),
    );
  }
}

// Clipper personalizado para criar uma curva côncava com uma curva mais profunda no centro
class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Inicia no canto superior esquerdo
    path.lineTo(0, 0);

    // Vai até o canto superior direito
    path.lineTo(size.width, 0);

    // Desce até o ponto antes de iniciar a curva do lado direito
    path.lineTo(
      size.width,
      size.height - 90,
    );

    // Curva do lado direito - ajuste o ponto final para controlar a largura da curva central
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40, // Ponto de controle direito
      size.width * 0.5 + 50,
      size.height - 60, // Aumente este valor para a direita da curva central
    );

    // Curva central (mais profunda para a bolinha)
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height, // Ponto de controle central
      size.width * 0.5 - 50,
      size.height - 60, // Aumente este valor para a esquerda da curva central
    );

    // Curva do lado esquerdo - ajuste o ponto final para controlar a largura da curva central
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 40, // Ponto de controle esquerdo
      0,
      size.height - 90, // Ponto final da curva esquerda
    );

    // Fecha o caminho
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

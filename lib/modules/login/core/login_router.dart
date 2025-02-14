import 'package:esteticy/index.dart';
import 'package:go_router/go_router.dart';

class LoginRouter {
  static const root = '/login';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      builder: (context, state) {
        return const LoginPage();
      },
    );
  }
}
import 'package:esteticy/index.dart';
import 'package:go_router/go_router.dart';

class HomeRouter {
  static const root = '/home';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      builder: (context, state) {
        return const HomePage();
      },
    );
  }
}

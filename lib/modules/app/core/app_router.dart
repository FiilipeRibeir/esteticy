import 'package:esteticy/index.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter init() {
    return GoRouter(
      redirect: (context, state) {
        return null;
      },
      routes: [
        SplashRouter.routes(),
        LoginRouter.routes(),
      ],
    );
  }
}

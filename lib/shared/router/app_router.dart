import 'package:go_router/go_router.dart';
import 'package:mapnavigatorapp/features/home/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', name: 'home', builder: (context, state) => const HomePage())],
  );
}

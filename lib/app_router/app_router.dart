import 'package:go_router/go_router.dart';
import 'package:password_manager/screen/loader/loader.dart';

class AppRouter {
  late final GoRouter app_router =
      GoRouter(debugLogDiagnostics: true, initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      name: 'loader',
      builder: (context, state) => const Loader(),
    )
  ]);
}

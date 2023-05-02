import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class AppRouter {
  final auth = FirebaseAuth.instance;
  late final GoRouter appRouter = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/local_auth',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithBottomNavigationBar(
            child: WillPopScope(
              onWillPop: () async {
                final goRouter = GoRouter.of(context);
                if (goRouter.location == '/home') {
                  return true;
                } else {
                  context.go(context.namedLocation('home'));
                  return false;
                }
              },
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            redirect: (context, state) {
              final auth = FirebaseAuth.instance;
              if (auth.currentUser?.uid != null || state.location == '/home') {
                return '/home';
              }
              return '/';
            },
            builder: (context, state) => const Home(),
          ),
          GoRoute(
            path: '/volt',
            name: 'volt',
            builder: (context, state) => const Volt(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) =>
                Profile(uid: state.queryParameters['uid']!),
          ),
        ],
      ),
      GoRoute(
        path: '/local_auth',
        name: 'local_auth',
        builder: (context, state) => const LocalAuth(),
      ),
      GoRoute(
        path: '/',
        name: 'email',
        builder: (context, state) => const Email(),
        redirect: (context, state) {
          if (auth.currentUser != null) {
            return '/local_auth';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const Register(),
          ),
          GoRoute(
            path: 'password',
            name: 'password',
            builder: (context, state) =>
                Password(email: state.queryParameters['email']!),
          ),
        ],
      ),
    ],
  );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class AppRouter {
  final auth = FirebaseAuth.instance;
  late final GoRouter appRouter = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
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
                if (auth.currentUser?.uid == null) {
                  return '/';
                }
                return null;
              },
              builder: (context, state) => const Home(),
              routes: [
                GoRoute(
                  path: 'save-password',
                  name: 'save password',
                  builder: (context, state) => SavePassword(
                      generatedPassword:
                          state.queryParameters['generatedPassword'] ?? ''),
                ),
              ]),
          GoRoute(
            path: '/volt',
            name: 'volt',
            builder: (context, state) => const Volt(),
            routes: [
              GoRoute(
                path: 'view-group-password',
                name: 'view group password',
                builder: (context, state) => ViewGroupPassword(
                    groupId: state.queryParameters['groupId']!),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) =>
                Profile(uid: state.queryParameters['uid']!),
            routes: [
              GoRoute(
                path: 'update-profile',
                name: 'update profile',
                builder: (context, state) => const UpdateProfile(),
              ),
              GoRoute(
                path: 'account-settings',
                name: 'account settings',
                builder: (context, state) => const AccountSettings(),
              ),
              GoRoute(
                path: 'change-password',
                name: 'change password',
                builder: (context, state) => const ChangePassword(),
              ),
              GoRoute(
                path: 'master-key',
                name: 'master key',
                builder: (context, state) => const MasterKey(),
              ),
              GoRoute(
                path: 'help-center',
                name: 'help center',
                builder: (context, state) => const HelpCenter(),
              ),
              GoRoute(
                path: 'report-bug',
                name: 'report bug',
                builder: (context, state) => const ReportBug(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/local_auth',
        name: 'local_auth',
        builder: (context, state) => const AccountSettings(),
        redirect: (context, state) {
          if (auth.currentUser == null) {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/',
        name: 'email',
        builder: (context, state) => const Email(),
        redirect: (context, state) {
          if (auth.currentUser != null) {
            return '/home';
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
                Password(email: state.queryParameters['email'] ?? ''),
          ),
        ],
      ),
    ],
  );
}

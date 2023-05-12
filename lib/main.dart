import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            },
          ),
          useMaterial3: true,
          colorScheme: lightColorScheme,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              // material color
              borderSide: BorderSide(
                color: lightColorScheme.primary,
              ),
            ),
            filled: true,
            fillColor: lightColorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(lightColorScheme.primary),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(lightColorScheme.primary),
              foregroundColor:
                  MaterialStateProperty.all<Color>(lightColorScheme.onPrimary),
            ),
          ),
          switchTheme: SwitchThemeData(
            trackOutlineColor: MaterialStateProperty.all<Color>(
              lightColorScheme.primary,
            ),
          ),
        ),
        darkTheme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            },
          ),
          useMaterial3: true,
          colorScheme: darkColorScheme,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              // material color
              borderSide: BorderSide(
                color: darkColorScheme.primary,
              ),
            ),
            filled: true,
            fillColor: darkColorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(darkColorScheme.primary),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(darkColorScheme.primary),
              foregroundColor:
                  MaterialStateProperty.all<Color>(darkColorScheme.onPrimary),
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().appRouter,
      ),
    );
  }
}

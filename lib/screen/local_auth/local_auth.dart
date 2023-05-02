import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth extends StatefulWidget {
  const LocalAuth({super.key});

  @override
  State<LocalAuth> createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      _showErrorDialog(
        context,
        'Unfortunately, it seems like your device does not support biometric authentication. This app requires a biometric authentication method such as fingerprint to ensure security. We apologize for any inconvenience this may cause.',
      );
      return;
    }

    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      if (!mounted) {
        return;
      }
      _showErrorDialog(
        context,
        'It looks like biometric authentication is not registered on this device. To use this app, please register a biometric authentication method such as fingerprint. Without biometric authentication, this app cannot be used for security reasons. Thank you for your understanding.',
      );
      return;
    }

    bool authenticated = await _authenticate(context);

    if (authenticated) {
      if (!mounted) {
        return;
      }
      context.goNamed('home');
      return;
    }
  }

  Future<bool> _authenticate(BuildContext context) async {
    int failedAttempts = 0;
    while (failedAttempts < 5) {
      try {
        final authenticated = await _localAuth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
        if (authenticated) {
          return true;
        }
      } on PlatformException catch (e) {
        _showErrorDialog(
          context,
          e.message.toString() +
              '. Please try register your biometric authentication',
        );
        return false;
      }

      failedAttempts++;
      _showDialog(
        context,
        'Authentication failed, Please try again',
      );
    }

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }

  void _showDialog(BuildContext context, String message) {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Oops!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              // Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Oops!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              // Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Security & Privacy'),
        // ),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Center(
        //       child: CircleAvatar(
        //         radius: 100,
        //         backgroundImage: NetworkImage(
        //           "https://api.multiavatar.com/$uid Bond.png",
        //         ),
        //         onBackgroundImageError: (exception, stackTrace) => const Center(
        //           child: Icon(Icons.error_outline),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(height: 20),
        //     ElevatedButton(
        //       onPressed: () {
        //         _checkBiometrics();
        //       },
        //       child: const Text('Authenticate with Biometrics'),
        //     ),
        //     const SizedBox(height: 20),
        //     ElevatedButton(
        //       onPressed: () {
        //         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        //       },
        //       child: const Text('Close App'),
        //     ),
        //   ],
        // ),
        );
  }
}

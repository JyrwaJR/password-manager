import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> checkBiometrics(BuildContext context) async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unfortunately, it seems like your device does not support biometric authentication. This app requires a biometric authentication method such as fingerprint to ensure security. We apologize for any inconvenience this may cause.',
          ),
        ),
      );
      return;
    }

    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty ||
        availableBiometrics.contains(BiometricType.fingerprint)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'It looks like biometric authentication is not registered on this device. To use this app, please register a biometric authentication method such as fingerprint. Without biometric authentication, this app cannot be used for security reasons. Thank you for your understanding.',
          ),
        ),
      );
      return;
    }

    bool authenticated = await _authenticate(context);

    if (authenticated) {
      await Future.delayed(Duration.zero);
      context.goNamed('home');
    }
  }

  Future<bool> _authenticate(BuildContext context) async {
    int failedAttempts = 0;
    bool authenticated = false;
    while (failedAttempts < 5 && !authenticated) {
      try {
        authenticated = await _localAuth.authenticate(
            localizedReason: '''Verify that it's you''',
            options: const AuthenticationOptions(
              biometricOnly: true,
            ));
      } on PlatformException catch (e) {
        _showErrorDialog(context, e.message!);
        return false;
      } catch (e) {
        return false;
      }

      failedAttempts++;
    }

    if (!authenticated) {
      _showErrorDialog(context, 'You need to authenticate to use this app.');
    }
    return authenticated;
  }

  void _showErrorDialog(BuildContext context, String message) {
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
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

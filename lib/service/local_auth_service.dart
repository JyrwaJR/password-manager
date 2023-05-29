import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final instance = LocalAuthentication();

  // Check if the device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    return await instance.canCheckBiometrics;
  }

  // Check if biometric authentication is enabled on the device
  Future<bool> isBiometricAuthenticationEnabled() async {
    List<BiometricType> availableBiometrics =
        await instance.getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }

  // Get the available biometric types on the device
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await instance.getAvailableBiometrics();
  }

  // Check if fingerprint is available as a biometric option
  Future<bool> isFingerprintAvailable() async {
    List<BiometricType> availableBiometrics = await getAvailableBiometrics();
    return !availableBiometrics.contains(BiometricType.fingerprint);
  }

  // Show a dialog indicating biometric lockout
  Future<void> _showBiometricLockedOutAlert(
      BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometric Locked Out'),
          content: Text(
            'You have exceeded the maximum number of attempts. Please try again later.\n\n$message',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => SystemNavigator.pop(),
            ),
          ],
        );
      },
    );
  }

  // Show a generic biometric alert dialog
  Future<void> _showBiometricAlert(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oops!'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
            // TextButton(
            //   onPressed: () async {
            //     Navigator.of(context).pop();
            //     await authenticateWithBiometrics(context);
            //   },
            //   child: const Text('Try Again'),
            // ),
          ],
        );
      },
    );
  }

  // Show the biometric verification dismissed alert box
  Future<void> _showBiometricDismissedAlert(BuildContext context) async {
    bool shouldRetry = true;

    while (shouldRetry) {
      shouldRetry = false;
      await showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent closing the alert box by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Biometric Verification'),
            content:
                const Text('You have dismissed the biometric verification.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                child: const Text('Exit App'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  shouldRetry = true; // Retry authentication
                },
                child: const Text('Try Again'),
              ),
            ],
          );
        },
      );

      if (shouldRetry) {
        await authenticateWithBiometrics(context);
        shouldRetry = false; //is this new line correct
      }
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics(BuildContext context) async {
    try {
      if (!await isDeviceSupported()) {
        await _showBiometricAlert(
          context,
          'Device does not support biometric authentication.',
        );
        return false;
      }

      bool isBiometricEnabled = await isBiometricAuthenticationEnabled();
      if (!isBiometricEnabled) {
        await _showBiometricAlert(
          context,
          'Biometric authentication is not enabled or your account is locked out.',
        );
        return false;
      }

      List<BiometricType> availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        await _showBiometricAlert(
          context,
          'Fingerprint biometric authentication is not available.',
        );
        return false;
      }

      bool isAuthenticated = await instance.authenticate(
          localizedReason: 'Authenticate with biometrics to continue',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));

      if (isAuthenticated) {
        return true;
      } else {
        await _showBiometricDismissedAlert(context);
        return false;
      }
    } on PlatformException catch (e) {
      if (e.code == 'lockout') {
        await _showBiometricLockedOutAlert(context, e.message!);
      } else if (e.code == 'NotEnrolled') {
        await _showBiometricAlert(
            context, 'No biometric is enrolled on this device.');
      } else if (e.code == 'PasscodeNotSet') {
        await _showBiometricAlert(
            context, 'Passcode is not set on this device.');
      } else {
        await _showBiometricAlert(context, 'Authentication failed.');
      }
      return false;
    }
  }
}

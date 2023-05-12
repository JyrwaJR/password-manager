import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final instance = LocalAuthentication();

  // is device supported
  Future<bool> isDeviceSupported() async {
    return await instance.canCheckBiometrics ? true : false;
  }

  Future<bool> isBiometricAuthenticationEnabled() async {
    List<BiometricType> availableBiometrics =
        await instance.getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await instance.getAvailableBiometrics();
    return availableBiometrics;
  }

  // check if device fingerprint is available
  Future<bool> isFingerprintAvailable() async {
    List<BiometricType> availableBiometrics =
        await instance.getAvailableBiometrics();
    if (!availableBiometrics.contains(BiometricType.fingerprint)) {
      return true;
    }
    return false;
  }

  final int _lockoutTimeInSeconds = 30;

  Future<void> _showBiometricLockedOutAlert(
      BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometric Locked Out'),
          content: Text(
              'You have exceeded the maximum number of attempts. Please try again after $_lockoutTimeInSeconds seconds.\n\n$message'),
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

  Future<void> _showBiometricAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometric Locked Out'),
          content: Text(
              '\n$message\n\nPlease try again after $_lockoutTimeInSeconds seconds.'),
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

  Future<bool> authenticateWithBiometrics(BuildContext context) async {
    try {
      if (!await isDeviceSupported()) {
        await _showBiometricAlert(
            context, 'Device does not support biometric authentication.');
        return false;
      }

      bool isBiometricEnabled = await isBiometricAuthenticationEnabled();
      if (!isBiometricEnabled) {
        await _showBiometricAlert(context,
            'Biometric authentication is not enabled or your account has biometric LockedOut.');
        return false;
      }

      List<BiometricType> availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        await _showBiometricAlert(
            context, 'Fingerprint biometric authentication is not available.');
        return false;
      }

      bool isAuthenticated = await instance.authenticate(
          localizedReason: 'Authenticate with biometrics to continue',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ));
      if (isAuthenticated) {
        return true;
      } else {
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

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

  Future<bool> authenticateWithBiometrics() async {
    // Authenticate with biometrics
    if (await isBiometricAuthenticationEnabled()) {
      bool didAuthenticate = await instance.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          // biometricOnly: true,
        ),
      );

      if (!didAuthenticate) {
        return false;
      }

      return didAuthenticate;
    } else {
      return false;
    }
  }
}

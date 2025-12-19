import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException catch (e) {
      print('Error checking device support: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Por favor autentíquese para continuar',
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        print('Biometrics not available');
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    return await authenticate(
      localizedReason: 'Autentíquese con Face ID o huella digital',
    );
  }
}

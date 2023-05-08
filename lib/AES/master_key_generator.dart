import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class MasterKeyGenerator {
  static const int _keyLength = 32;

  static String generateKey() {
    final random = Random.secure();
    final values = List<int>.generate(_keyLength, (_) => random.nextInt(256));
    final key = Uint8List.fromList(values);
    return base64.encode(key);
  }
}

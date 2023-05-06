import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class MasterKeyGenerator {
  Uint8List generateEncryptionKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    return Uint8List.fromList(values);
  }

  Uint8List hashKey(String key) {
    final bytes = utf8.encode(key);
    final digest = sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  Uint8List generateKeyFromPassword(String password) {
    final encryptionKey = generateEncryptionKey();
    final hashedKey = hashKey(password);
    final key = Uint8List(32);
    for (var i = 0; i < 32; i++) {
      key[i] = encryptionKey[i] ^ hashedKey[i];
    }
    return key;
  }
}


// void main() {
//   final key = generateEncryptionKey();
//   final hashedKey = hashKey(base64.encode(key));
//   print('Key: ${base64.encode(key)}');
//   print('Hashed key: ${base64.encode(hashedKey)}');
// }

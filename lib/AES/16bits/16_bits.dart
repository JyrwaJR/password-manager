import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/pointycastle.dart';

class AesEncryption {
  final String _masterKey;

  AesEncryption(this._masterKey);

  String encrypt(String plainText) {
    final key = _generateKey();
    final iv = _generateIv();
    final cipher = _createCipher();
    final params = ParametersWithIV<KeyParameter>(
        KeyParameter(Uint8List.fromList(key)), iv);
    cipher.init(true, params);
    final encrypted =
        cipher.process(Uint8List.fromList(utf8.encode(plainText)));
    final encryptedString = '${base64.encode(iv)}:${base64.encode(encrypted)}';
    return encryptedString;
  }

  String decrypt(String cipherText) {
    final parts = cipherText.split(':');
    final iv = base64.decode(parts[0]);
    final encrypted = base64.decode(parts[1]);
    final key = _generateKey();
    final cipher = _createCipher();
    final params = ParametersWithIV<KeyParameter>(
        KeyParameter(Uint8List.fromList(key)), iv);
    cipher.init(false, params);
    final decrypted = cipher.process(Uint8List.fromList(encrypted));
    return utf8.decode(decrypted);
  }

  List<int> _generateKey() {
    final key = utf8.encode(_masterKey);
    final sha256 = SHA256Digest().process(Uint8List.fromList(key));
    final truncatedSha256 = sha256.sublist(0, 16);
    if (truncatedSha256.length < 16) {
      final paddedKey = Uint8List(16);
      paddedKey.setRange(0, truncatedSha256.length, truncatedSha256);
      return paddedKey;
    }
    return truncatedSha256;
  }

  Uint8List _generateIv() {
    final bytes = List<int>.generate(16, (i) => Random.secure().nextInt(256));
    return Uint8List.fromList(bytes);
  }

  BlockCipher _createCipher() {
    final cipher = BlockCipher('AES/CTR');
    return cipher;
  }
}

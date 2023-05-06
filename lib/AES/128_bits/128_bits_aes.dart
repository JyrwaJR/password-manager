import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';

class AES128Bits {
  static String encrypt(String plainText, String secretKey) {
    final key = _generateKey(secretKey);
    final iv = _generateIV();
    final encrypter =
        Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return base64.encode(encrypted.bytes);
  }

  static String decrypt(String encryptedText, String secretKey) {
    final key = _generateKey(secretKey);
    final iv = _generateIV();
    final encrypter =
        Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.cbc));
    final encrypted = Encrypted(base64.decode(encryptedText));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static Uint8List _generateKey(String secretKey) {
    final sha = sha256.convert(utf8.encode(secretKey));
    return Uint8List.fromList(sha.bytes);
  }

  static IV _generateIV() {
    return IV.fromLength(16);
  }
}

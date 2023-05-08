import 'dart:convert';
import 'package:crypto/crypto.dart'; // for hashing function
import 'package:encrypt/encrypt.dart'; // for encryption/decryption
import 'dart:typed_data';

class AES192Bits {
  static String encrypt(String plainText, String secretKey) {
    final key =
        _generateKey(secretKey, 24); // generate 192-bit key using secretKey
    final iv = _generateIV(); // generate a random initialization vector
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key)),
        mode: AESMode.cbc)); // create encrypter with AES algorithm and CBC mode
    final encrypted = encrypter.encrypt(plainText,
        iv: iv); // encrypt plainText with key and iv
    return base64
        .encode(encrypted.bytes); // encode encrypted bytes as base64 string
  }

  static String decrypt(String encryptedText, String secretKey) {
    final key =
        _generateKey(secretKey, 24); // generate 192-bit key using secretKey
    final iv = _generateIV(); // generate a random initialization vector
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key)),
        mode: AESMode.cbc)); // create encrypter with AES algorithm and CBC mode
    final encrypted = Encrypted(base64.decode(
        encryptedText)); // decode encryptedText from base64 and create Encrypted object
    final decrypted = encrypter.decrypt(encrypted,
        iv: iv); // decrypt encrypted text with key and iv
    return decrypted; // return decrypted text
  }

  static Uint8List _generateKey(String secretKey, int length) {
    final sha = sha256.convert(
        utf8.encode(secretKey)); // hash secretKey with SHA-256 algorithm
    return Uint8List.fromList(sha.bytes.sublist(0,
        length)); // convert first length bytes of hash to a Uint8List (truncate if longer) and return as key
  }

  static IV _generateIV() {
    return IV
        .fromLength(16); // generate a random 16-byte initialization vector (IV)
  }
}

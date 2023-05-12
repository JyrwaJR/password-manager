import 'package:flutter/services.dart';
import 'package:password_manager/AES/256_bits/256_bits_aes.dart';

// ! Capitalize first letter
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return '';
  }
  return text.substring(0, 1).toUpperCase() + text.substring(1);
}

// ! Encrypt field
String encryptField(dynamic value, String key) {
  return value != null ? AES256Bits.encrypt(value, key) : '';
}

// ! Decrypt field
String decryptField(dynamic value, String key) {
  return value != null ? AES256Bits.decrypt(value, key) : '';
}

// ! Copy to clipboard
void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

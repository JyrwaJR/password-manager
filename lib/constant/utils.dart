import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/export.dart';

// ! Capitalize first letter
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return '';
  }
  return text.substring(0, 1).toUpperCase() + text.substring(1);
}

// ! Encrypt field
String encryptField(dynamic value, String key, BuildContext context) {
  try {
    return value != null ? AES256Bits.encrypt(value, key) : '';
  } catch (e) {
    BrandSnackbar.showSnackBar(context, e.toString());
    return '';
  }
}

// ! Decrypt field
String decryptField(dynamic value, String key, BuildContext context) {
  try {
    return value != null ? AES256Bits.decrypt(value, key) : '';
  } catch (e) {
    BrandSnackbar.showSnackBar(context, e.toString());
    return '';
  }
}

// ! Copy to clipboard
void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

import 'dart:math';

import 'package:flutter/material.dart';

class GeneratePasswordService {
  static const String _letters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = '!"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~\$';

  static String generatePassword({
    required bool includeLetters,
    required bool includeNumbers,
    required bool includeSymbols,
    required int length,
    required BuildContext context,
  }) {
    String allowedChars = '';
    if (includeLetters) allowedChars += _letters;
    if (includeNumbers) allowedChars += _numbers;
    if (includeSymbols) allowedChars += _symbols;

    if (allowedChars.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text(
              'You must select at least one option. From setting below'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return '';
    }

    return List.generate(length, (index) {
      final randomIndex = Random().nextInt(allowedChars.length);
      return allowedChars[randomIndex];
    }).join();
  }
}

import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final String _plaintext = "Hello, world!";
  final String _secretKey = "mySecretKeys";
  String _encryptedText = "";
  String _decryptedText = "";

  void _encryptText() {
    setState(() {
      _encryptedText = AES192Bits.encrypt(_plaintext, _secretKey);
    });
  }

  void _decryptText() {
    setState(() {
      _decryptedText = AES192Bits.decrypt(_encryptedText, _secretKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AES Encryption"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Plaintext: $_plaintext"),
            const SizedBox(height: 16),
            Text("Encrypted text: $_encryptedText"),
            const SizedBox(height: 16),
            Text("Decrypted text: $_decryptedText"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _encryptText,
              child: const Text("Encrypt"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _decryptText,
              child: const Text("Decrypt"),
            ),
          ],
        ),
      ),
    );
  }
}

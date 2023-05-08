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
        body: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const CircleAvatar(
                          radius: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jyrwaharrison@gmail.com',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                                'This is a project description This is a project description',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                )),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.copy))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

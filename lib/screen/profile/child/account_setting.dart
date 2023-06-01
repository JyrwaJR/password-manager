import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> terms = [
      {
        "title": "1. Account Creation and Security",
        "content": [
          "1.1 You must create an account to use the App. You are responsible for maintaining the confidentiality of your account information, including your username and password.",
          "1.2 You agree to provide accurate and up-to-date information during the account creation process. You are solely responsible for any activity that occurs under your account.",
          "1.3 You must notify Company immediately if you become aware of any unauthorized use of your account or any other breach of security."
        ],
      },
      {
        "title": "2. Data Privacy and Security",
        "content": [
          "2.1 The App securely stores and encrypts your passwords and other sensitive information. However, you understand and acknowledge that no security measures are completely foolproof, and Company cannot guarantee the absolute security of your data.",
          "2.2 Company will not sell, share, or disclose your personal information to third parties without your explicit consent, except as required by law or as outlined in the Privacy Policy."
        ],
      },
      {
        "title": "3. Use of the App",
        "content": [
          "3.1 The App is intended for personal use only. You may not use the App for any commercial or unauthorized purposes.",
          "3.2 You agree not to use the App in any manner that violates applicable laws or regulations.",
          "3.3 You shall not attempt to gain unauthorized access to any part of the App, its systems, or the accounts of other users."
        ],
      },
      {
        "title": "4. Intellectual Property",
        "content": [
          "4.1 The App, including its design, features, and content, is protected by intellectual property laws. All rights, title, and interest in the App belong to Company.",
          "4.2 You may not modify, reproduce, distribute, or create derivative works based on the App without Company's prior written consent."
        ],
      },
      {
        "title": "5. Limitation of Liability",
        "content": [
          "5.1 The App is provided 'as is' without any warranties, express or implied. Company disclaims all warranties, including but not limited to merchantability, fitness for a particular purpose, and non-infringement.",
          "5.2 Company shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the App, including but not limited to loss of data, loss of profits, or interruption of business."
        ],
      },
      {
        "title": "6. Modifications to the Terms",
        "content": [
          "6.1 Company reserves the right to modify these Terms at any time. The updated Terms will be posted on the App or provided to you in another appropriate manner. Your continued use of the App after such modifications constitutes your acceptance of the revised Terms."
        ],
      },
      {
        "title": "7. Termination",
        "content": [
          "7.1 Company may, at its sole discretion, suspend or terminate your access to the App at any time and for any reason, without prior notice.",
          "7.2 Upon termination, your right to use the App will cease, and you must uninstall the App from all your devices."
        ],
      },
      {
        "title": "8. Governing Law",
        "content": [
          "8.1 These Terms shall be governed by and construed in accordance with the laws of [Jurisdiction]. Any disputes arising out of or in connection with these Terms shall be subject to the exclusive jurisdiction of the courts of [Jurisdiction]."
        ],
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Delete Account'),
        actions: [
          IconButton(
            onPressed: () async {
              final store = FirestoreService();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                      'Are you sure you want to delete your account?'),
                  content: const Text(
                      'This action cannot be undone.\n\n All your data will be deleted and cannot be recovered.'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await store.deleteAccount(widget.uid, context);
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: terms.length,
        itemBuilder: (context, index) {
          final term = terms[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term['title']!,
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize!,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: term['content']
                        .map<Widget>(
                          (content) => Text(
                            content,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .fontSize! -
                                  2,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

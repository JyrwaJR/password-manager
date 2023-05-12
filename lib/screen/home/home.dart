import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:password_manager/export.dart';
import 'package:password_manager/widget/save_password_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int passLength = 16;
  bool _includeNumber = false;
  bool _includeLetter = false;
  bool _includeSymbol = false;
  String generatedPassword = '';
  final local = LocalAuthService();
  void isSupported() async {
    if (await local.isDeviceSupported()) {
      print('is supported');
      if (await local.isBiometricAuthenticationEnabled()) {
        print('is Enabled');
        if (await local.authenticateWithBiometrics()) {
          print('is Authenticated');
        } else {
          SystemNavigator.pop();
        }
      } else {
        _showErrorDialog('Biometric authentication is not enabled');
      }
    } else {
      _showErrorDialog('Your device is not supported');
    }
  }

  void _showErrorDialog(String content) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('OK'))
          ],
        ),
      );
    }
    return;
  }

  @override
  void initState() {
    isSupported();
    super.initState();

    // Reset the authentication status when the app is resumed from the recent view
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        isSupported();
      }
      return null;
    });
  }

  void _generate() {
    String password = GeneratePasswordService.generatePassword(
      includeLetters: _includeLetter,
      includeNumbers: _includeNumber,
      includeSymbols: _includeSymbol,
      length: passLength,
      context: context,
    );
    setState(() {
      generatedPassword = password;
    });
  }

  //! call back function to update include sumbols
  void _handleIncludeNumberChanged(bool value) {
    setState(() {
      _includeNumber = value;
    });
  }

  void _handleIncludeLetterChanged(bool value) {
    setState(() {
      _includeLetter = value;
    });
  }

  void _handleIncludeSymbolChanged(bool value) {
    setState(() {
      _includeSymbol = value;
    });
  }

  //! call back function to update password length
  void _updatePasswordLength(int length) {
    setState(() {
      passLength = length;
    });
  }

  void _onPressedSavePassword() {
    if (generatedPassword.length < 5) {
      if (!mounted) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Oops!'),
            content: const Text(
              'Please generate a password first and then save your password',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    } else {
      if (!mounted) {
        return;
      }
      showCupertinoDialog(
        context: context,
        builder: (context) =>
            SavePassword(generatedPassword: generatedPassword),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder<bool>(
      future: SharedPreferences.getInstance().then(
        (prefs) => prefs.getBool('isAuthenticated') ?? false,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: const AppBarTitle(title: 'DASHBOARD'),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrandTitle(title: 'Generate Passwords', id: uid!),
                      const SizedBox(height: 15),
                      BrandPasswordDisplay(password: generatedPassword),
                      const SizedBox(height: 10),
                      BrandSwitch(
                          length: passLength,
                          onLengthChanged: _updatePasswordLength),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'SETTING',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BrandTextWithSwitch(
                          title: 'Include Numbers',
                          onChanged: _handleIncludeNumberChanged),
                      BrandTextWithSwitch(
                          title: 'Include Letters',
                          onChanged: _handleIncludeLetterChanged),
                      BrandTextWithSwitch(
                          title: 'Include Symbols',
                          onChanged: _handleIncludeSymbolChanged),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BrandButton(
                        onPressed: _generate,
                        title: 'GENERATE ',
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                      SavePasswordButton(
                          onPressed: _onPressedSavePassword, title: 'SAVE'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

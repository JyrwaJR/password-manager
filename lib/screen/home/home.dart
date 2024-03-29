import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:password_manager/export.dart';
import 'package:password_manager/widget/save_password_button.dart';

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

  void _generate() {
    if (_includeLetter || _includeNumber || _includeSymbol) {
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
    } else {
      brandAlertDialogSingleButton(
          'Password cannot be generate without any Symbol, Number or Letter . \n\n Please include at least one setting from Below',
          context);
    }
  }

  //! call back function to update include symbols
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
    if (_includeLetter || _includeSymbol || _includeNumber) {
      setState(() {
        passLength = length;
        _generate();
      });
    } else {
      setState(() {
        passLength = length;
      });
    }
  }

  void _onPressedSavePassword() {
    if (generatedPassword.isEmpty) {
      if (!mounted) {
        return;
      }
      brandAlertDialogSingleButton(
          'Please generate a password to continue. \n\n Please include at least one setting from Below',
          context);
      return;
    }
    if (!mounted) {
      return;
    }
    showCupertinoDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) => SavePassword(generatedPassword: generatedPassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'DASHBOARD'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandTitle(title: 'Generate Passwords', id: uid ?? ''),
              const SizedBox(height: 15),
              BrandPasswordDisplay(password: generatedPassword),
              const SizedBox(height: 10),
              BrandSwitch(
                  length: passLength, onLengthChanged: _updatePasswordLength),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'SETTING',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                    fontWeight:
                        Theme.of(context).textTheme.labelLarge?.fontWeight,
                    color: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.color
                        ?.withOpacity(0.6),
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
          const BrandSizeBox(height: 20),
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
          const BrandSizeBox(height: 5),
        ],
      ),
    );
  }
}

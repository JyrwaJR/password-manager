import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:uuid/uuid.dart';

class AddCredential extends StatefulWidget {
  const AddCredential({super.key, required this.groupId});
  final String groupId;

  @override
  State<AddCredential> createState() => _AddCredentialState();
}

class _AddCredentialState extends State<AddCredential> {
  final store = FirestoreService();
  bool useGeneratedPassword = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String isWebsite = '';
  String isInputPassword = '';
  String isInputUsername = '';
  String? generatedPassword; // Store the generated password separately

  String generateNewPassword() {
    return GeneratePasswordService.generatePassword(
      includeLetters: true,
      includeNumbers: true,
      includeSymbols: true,
      length: 32,
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    generatedPassword = generateNewPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          scrollDirection: Axis.vertical,
          children: [
            BrandTitle(title: 'Add Credential', id: widget.groupId),
            const SizedBox(height: 20),
            const Text('Please add your detail below'),
            const SizedBox(height: 20),
            BrandTextWithSwitch(
                onChanged: (value) {
                  setState(() {
                    useGeneratedPassword = value;
                  });
                },
                title: 'Use Generated Password'),
            const SizedBox(height: 20),
            useGeneratedPassword
                ? BrandPasswordDisplay(password: generatedPassword ?? '')
                : TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length > 100) {
                        return 'Password length should not be more than 100 characters long';
                      }
                      if (value.length < 8) {
                        return 'Password length should not be less than 8 characters long';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      setState(() {
                        isInputPassword = value;
                      });
                    },
                    maxLines: 5,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                  ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 40,
              onChanged: (value) {
                setState(() {
                  isInputUsername = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter username';
                }
                if (value.length > 40) {
                  return 'Username length should not be more than 100 characters long';
                }
                if (value.length < 4) {
                  return 'Username length should not be less than 4 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email/Username',
                hintText: 'Enter your username',
                helperText: 'your email or username',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 20,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter website name';
                }
                if (value.length > 20) {
                  return 'Website name length should not be more than 100 characters long';
                }
                if (value.length < 4) {
                  return 'Website name length should not be less than 8 characters long';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  isWebsite = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Website',
                  hintText: 'Enter website name',
                  helperText:
                      'the website which you need to login with these detail'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            final passwordId = const Uuid().v1();
                            await store
                                .addPassword(
                                    PasswordDTO(
                                        passwordId: passwordId,
                                        password: useGeneratedPassword
                                            ? generatedPassword ?? ''
                                            : isInputPassword,
                                        userName: isInputUsername,
                                        website: isWebsite),
                                    widget.groupId,
                                    uid ?? '',
                                    context)
                                .then((value) => Navigator.pop(context));
                          }
                        },
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        )
                      : const Text('Add Password')),
            )
          ],
        ),
      ),
    );
  }
}

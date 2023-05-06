import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/AES/master_key_generator.dart';
import 'package:password_manager/export.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    final firestore = FirestoreService();
    @override
    void dispose() {
      _emailController.dispose();
      _passwordController.dispose();
      _confirmPasswordController.dispose();
      _nameController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Please enter your detail",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  if (value.length < 3) {
                    return 'username must contain more than 3 character';
                  }
                  if (value.length > 20) {
                    return 'username must contain less than 20 character';
                  }
                  if (value == ' ') {
                    return 'Please enter a valid username';
                  }
                  if (value.contains(' ')) {
                    return 'user name should not contain spaces';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _nameController.text = newValue!;
                },
                onChanged: (value) {
                  setState(() {
                    value = _nameController.text;
                  });
                },
                style: const TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'User Name',
                  hintText: 'example',
                  suffixIcon: _emailController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _emailController.clear();
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                        ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!email_regex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _emailController.text = newValue!;
                },
                onChanged: (value) {
                  setState(() {
                    value = _emailController.text;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'youremail@domain.com',
                  suffixIcon: _emailController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _emailController.clear();
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                        ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    value = _passwordController.text;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!password_regex.hasMatch(value)) {
                    return 'Please enter a valid password';
                  }
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    return '''Password don't match''';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '**********',
                  suffixIcon: _passwordController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                onChanged: (value) {
                  setState(() {
                    value = _confirmPasswordController.text;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!password_regex.hasMatch(value)) {
                    return 'Please enter a valid password';
                  }
                  if (_confirmPasswordController.text !=
                      _passwordController.text) {
                    return '''Password don't match''';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: '**********',
                  suffixIcon: _confirmPasswordController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              final result =
                                  await auth.createUserWithEmailAndPassword(
                                      _passwordController.text,
                                      context,
                                      _emailController.text);
                              if (result != null) {
                                if (!mounted) {
                                  return;
                                }
                                final key = MasterKeyGenerator()
                                    .generateKeyFromPassword(
                                        _passwordController.text)
                                    .toString();
                                final uid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                await firestore
                                    .registerUser(
                                        UserDTO(
                                          userName: _nameController.text,
                                          email: _emailController.text,
                                          masterKey: key,
                                          uid: uid!,
                                        ),
                                        context)
                                    .then((value) => context.goNamed('home'));
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text('Submit')),
              ),
              const SizedBox(
                height: 50,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                  Text(
                    "or",
                    style: TextStyle(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(),
                  ),
                  TextButton(
                    onPressed: () => context.go(context.namedLocation('email')),
                    child: const Text("Sign in"),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

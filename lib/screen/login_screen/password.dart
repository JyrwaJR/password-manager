// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Password extends StatefulWidget {
  final String email;
  const Password({super.key, required this.email});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp _passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$');
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();

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
                "Password goes here",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
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
                  if (!_passwordRegex.hasMatch(value)) {
                    return 'Please enter a valid password';
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
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result =
                                    await auth.signInWithEmailAndPassword(
                                        widget.email,
                                        _passwordController.text,
                                        context);
                                if (result != null) {
                                  if (!mounted) {
                                    return;
                                  }
                                  context.go(
                                    context.namedLocation('local_auth'),
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          )
                        : const Text('Continue')),
              ),
              const SizedBox(
                height: 30,
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
                    "Don't have an account?",
                    style: TextStyle(),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.go(context.namedLocation('register')),
                    child: const Text(
                      "Sign Up",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

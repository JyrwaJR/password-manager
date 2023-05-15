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
              Text(
                "Password goes here",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                  fontWeight: FontWeight.bold,
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
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => context
                          .push(context.namedLocation('change password')),
                      child: Text(
                        'forget password?',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
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
                                    context.namedLocation('home'),
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
                        : Text(
                            'Continue'.toUpperCase(),
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                  Text(
                    "or",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize),
                  ),
                  const Expanded(
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
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.go(context.namedLocation('register')),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize),
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

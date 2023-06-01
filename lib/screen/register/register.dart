import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        automaticallyImplyLeading: true,
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
                "Please enter your detail",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                  fontWeight: FontWeight.bold,
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
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'User Name',
                  hintText: 'example',
                  suffixIcon: _nameController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _nameController.clear();
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                          ),
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
                          ),
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
                          ),
                        ),
                ),
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
                                try {
                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (uid != null) {
                                    await firestore
                                        .registerUser(
                                          UserDTO(
                                            userName: _nameController.text,
                                            email: _emailController.text,
                                            uid: uid,
                                          ),
                                          context,
                                        )
                                        .then(
                                            (value) => context.goNamed('home'));
                                  } else {
                                    BrandSnackbar.showSnackBar(
                                        context, 'Please try again');
                                  }
                                } on FirebaseAuthException catch (e) {
                                  BrandSnackbar.showSnackBar(
                                      context, e.message.toString());
                                } catch (e) {
                                  BrandSnackbar.showSnackBar(
                                      context, e.toString());
                                }
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
                        : Text(
                            'SUBMIT',
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
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                  TextButton(
                    onPressed: () => context.go(context.namedLocation('email')),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize),
                    ),
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

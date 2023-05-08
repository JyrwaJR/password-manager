import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/constant/regex.dart';
import 'package:password_manager/export.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
                "Enter your email",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
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
                style: const TextStyle(
                  color: Colors.black87,
                ),
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
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.go(context.namedLocation('password',
                          queryParameters: {'email': _emailController.text}));
                    }
                  },
                  child: const Text('Continue'),
                ),
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
                      style: TextStyle(),
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

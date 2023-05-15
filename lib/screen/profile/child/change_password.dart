import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    _emailController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _emailController.text = auth.currentUser!.email ?? '';
    super.initState();
  }

  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
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
              BrandTitle(title: 'Change Password', id: uid ?? ''),
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
                  helperText: 'Enter your email to change your password',
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Change Password'),
                            content: const Text(
                                'Are you sure you want to change your password?'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    final auth = FirebaseAuthService();
                                    await auth
                                        .resetPassword(
                                            _emailController.text, context)
                                        .then(
                                          (value) => showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Opp!'),
                                              content: Text(
                                                  'Email sent success-full to your email address ${_emailController.text}'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    _emailController.clear();
                                                    _formKey.currentState!
                                                        .reset();
                                                    context.go('/home');
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ok'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Send'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

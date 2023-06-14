import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              CachedNetworkImage(
                imageUrl:
                    "https://img.freepik.com/free-vector/privacy-policy-concept-illustration_114360-7853.jpg?w=360&t=st=1686744267~exp=1686744867~hmac=f61652f32910f811d8ae4374128fc5542f82e3813df7985d358af06db565d7f6",
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  if (error is SocketException) {
                    return const Center(child: Icon(Icons.error_outline));
                  } else if (error is TimeoutException) {
                    return const Center(child: Icon(Icons.error_outline));
                  } else {
                    return const Center(child: Icon(Icons.error_outline));
                  }
                },
                imageBuilder: (context, imageProvider) {
                  return Image.network(
                    "https://img.freepik.com/free-vector/privacy-policy-concept-illustration_114360-7853.jpg?w=360&t=st=1686744267~exp=1686744867~hmac=f61652f32910f811d8ae4374128fc5542f82e3813df7985d358af06db565d7f6",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      if (error is SocketException) {
                        return const Center(child: Icon(Icons.error_outline));
                      } else if (error is TimeoutException) {
                        return const Center(child: Icon(Icons.error_outline));
                      } else {
                        return const Center(child: Icon(Icons.error_outline));
                      }
                    },
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'A better way to manage your password and note'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge?.fontSize),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                    onPressed: () async {
                      final _auth = FirebaseAuthService();
                      await _auth.signInWithGoogle(context);
                      if (FirebaseAuth.instance.currentUser != null) {
                        if (!mounted) {
                          return;
                        }
                        context.goNamed('home');
                      }
                    },
                    icon: Icon(Icons.login),
                    label: Text('Continue With Google')),
              )
            ],
          ),
        ));
  }
}

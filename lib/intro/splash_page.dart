import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ugbs_dawuro_ios/authentication/signup_and_signin.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = 'splash page';

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
          context, SignUpAndSignIn.id, (route) => false),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Image.asset(
            'images/download.png',
          ),
        ),
      ),
    );
  }
}

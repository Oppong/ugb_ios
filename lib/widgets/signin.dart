import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugbs_dawuro_ios/apppages/homepage.dart';
import 'package:ugbs_dawuro_ios/authentication/signup_and_signin.dart';

import '../constant.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  String? email, password;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kMainColor,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !(value.contains('@ug.edu.gh') ||
                              value.contains('@st.ug.edu.gh'))) {
                        return 'Enter Your Student Email Address or Staff Email Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(
                        Icons.email,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      hintText: 'Email Address',
                      hintStyle:
                          TextStyle(fontSize: 11, color: Colors.grey.shade400),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be more than 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(
                        Icons.lock,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await _auth
                              .signInWithEmailAndPassword(
                                  email: email!, password: password!)
                              .catchError((e) {
                            setState(() {
                              isLoading = false;
                            });

                            var message = 'enter valid credentials';
                            if (e.message != null) {
                              message = e.message;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          });

                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('email', email!);

                          Navigator.pushNamedAndRemoveUntil(
                              context, HomePage.id, (route) => false);
                          setState(() {
                            isLoading = false;
                          });
                          _emailController.clear();
                          _passwordController.clear();
                        } catch (e) {
                          // print(e);

                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        'Sign In ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: kMainColor,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

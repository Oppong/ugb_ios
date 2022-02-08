import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugbs_dawuro_ios/apppages/homepage.dart';
import 'package:ugbs_dawuro_ios/authentication/signup_and_signin.dart';
import 'package:ugbs_dawuro_ios/widgets/signin.dart';

import '../constant.dart';

// for forms
String? email, password, fullName, confirmPassword, studentId;
bool isLoading = false;
final GlobalKey<FormState> _formSignUpKey = GlobalKey<FormState>();

// TextEditingControllers
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
final _fullNameController = TextEditingController();
final _phoneNumberController = TextEditingController();
final _studentIdController = TextEditingController();

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class SignUpWidget extends StatefulWidget {
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  // const SignUpWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kMainColor,
            ),
          )
        : Form(
            key: _formSignUpKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                physics: ScrollPhysics(),
                children: [
                  TextFormField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter fullName';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.supervisor_account,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      hintText: 'FullName',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _fullNameController,
                  ),
                  SizedBox(height: 20),
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
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      studentId = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Student Id';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(
                        Icons.explore,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      hintText: 'Student Id / Staff Id',
                      hintStyle:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _studentIdController,
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
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be more than 6 characters';
                      }

                      if (value != password) {
                        return 'Passwords do not match';
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
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    controller: _confirmPasswordController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formSignUpKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final newUser = await _auth
                              .createUserWithEmailAndPassword(
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
                          await _firestore
                              .collection('profiles')
                              .doc(newUser.user?.uid)
                              .set({
                            'email': email,
                            'fullName': fullName,
                            'studentId': studentId,
                            'imageUrl':
                                'https://images.unsplash.com/photo-1639745297141-347515fdb8aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80',
                            'userId': newUser.user?.uid,
                            'createdAt': DateTime.now(),
                            'userType': 'student',
                            'programme': 'Your Programme of Study'
                          }).then((value) async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('email', email!);
                          });

                          Navigator.pushNamedAndRemoveUntil(
                              context, HomePage.id, (route) => false);

                          setState(() {
                            isLoading = false;
                          });

                          _fullNameController.clear();
                          _emailController.clear();
                          _studentIdController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        } catch (e) {
                          // print(e);

                        }
                      }
                    },
                    child: Text(
                      'Sign Up ',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

/*
 TextFormField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                phoneNumber = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Phone Number';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(
                  Icons.phone,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
                hintText: 'Phone Number',
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              style: TextStyle(color: Colors.black),
              controller: _phoneNumberController,
            ),
            SizedBox(height: 20),
 */

/*

 */

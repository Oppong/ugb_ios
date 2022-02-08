import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

//Form variables
String? email, fullName, imageUrl, userId, programme, studentId;

final _formFullNameKey = GlobalKey<FormState>();
final _formStudentIdKey = GlobalKey<FormState>();
final _formEmailKey = GlobalKey<FormState>();
final _formProgrammeKey = GlobalKey<FormState>();

class UpdateFullName extends StatelessWidget {
  const UpdateFullName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formFullNameKey,
        child: ListView(
          children: [
            TextFormField(
              onChanged: (val) {
                fullName = val;
              },
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'enter fullName';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: kMainColor,
              ),
              onPressed: () async {
                if (_formFullNameKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  await _firestore
                      .collection('profiles')
                      .doc(_auth.currentUser?.uid)
                      .update({
                    'fullName': fullName,
                  });

                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update FullName',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateEmail extends StatelessWidget {
  const UpdateEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formEmailKey,
        child: ListView(
          children: [
            TextFormField(
              onChanged: (val) {
                email = val;
              },
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'enter Email';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: kMainColor,
              ),
              onPressed: () async {
                if (_formEmailKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  await _firestore
                      .collection('profiles')
                      .doc(_auth.currentUser?.uid)
                      .update({
                    'email': email,
                  });

                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update Email',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateStudentId extends StatelessWidget {
  const UpdateStudentId({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formStudentIdKey,
        child: ListView(
          children: [
            TextFormField(
              onChanged: (val) {
                studentId = val;
              },
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'enter Student Id';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter Student Id',
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: kMainColor,
              ),
              onPressed: () async {
                if (_formStudentIdKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  await _firestore
                      .collection('profiles')
                      .doc(_auth.currentUser?.uid)
                      .update({
                    'studentId': studentId,
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update Student Id',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateProgramme extends StatelessWidget {
  const UpdateProgramme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formProgrammeKey,
        child: ListView(
          children: [
            TextFormField(
              onChanged: (val) {
                programme = val;
              },
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'enter Programme';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: 'Programme',
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: kMainColor,
              ),
              onPressed: () async {
                if (_formProgrammeKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  await _firestore
                      .collection('profiles')
                      .doc(_auth.currentUser?.uid)
                      .update({
                    'programme': programme,
                  });

                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update Programme',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

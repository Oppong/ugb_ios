import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails(
      {this.fullName,
      this.imageUrl,
      this.email,
      this.programme,
      this.studentId,
      this.userId,
      Key? key})
      : super(key: key);

  static const String id = 'student details screen';

  final String? email, fullName, programme, imageUrl, studentId, userId;

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: kMainColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.imageUrl!),
                )),
            child: Container(
              padding: EdgeInsets.only(top: 5, left: 5),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 18,
              color: kMainColor,
            ),
            title: Text(
              'FullName',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              '${widget.fullName}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.email,
              size: 18,
              color: kMainColor,
            ),
            title: Text(
              'Email',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              '${widget.email}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.bolt,
              size: 18,
              color: kMainColor,
            ),
            title: Text(
              'Programme of Study',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              '${widget.programme}',
              style: TextStyle(
                height: 1.5,
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.sticky_note_2_outlined,
              size: 18,
              color: kMainColor,
            ),
            title: Text(
              'Student Id',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              '${widget.studentId}',
              style: TextStyle(
                height: 1.5,
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

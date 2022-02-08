import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ugbs_dawuro_ios/apppages/students/one_to_one_students_chat_page.dart';
import 'package:ugbs_dawuro_ios/apppages/students/student_details.dart';

import '../../constant.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);
  static const String id = 'students screen';

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsList;

  dynamic members;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentsList = _firestore
        .collection('profiles')
        .where('userId', isNotEqualTo: _auth.currentUser!.uid)
        .where('userType', isEqualTo: 'student')
        .snapshots();
  }

  String chatRoomId(String? user1, String? user2) {
    if (user1![0].toLowerCase().codeUnits[0] >
        user2![0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'UGBS CHAT CORNER',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getStudentsList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  final students = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          String roomId = chatRoomId(_auth.currentUser!.uid,
                              students[index].data()['userId']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OneToOneStudentsChatPage(
                                imageUrl: students[index].data()['imageUrl'],
                                fullName: students[index].data()['fullName'],
                                studentId: students[index].data()['studentId'],
                                userId: students[index].data()['userId'],
                                status: students[index].data()['status'],
                                lastSeen:
                                    students[index].data()['lastSeen'].toDate(),
                                roomId: roomId,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(students[index].data()['imageUrl']),
                        ),
                        title: Text(
                          students[index].data()['fullName'],
                          style: TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          students[index].data()['email'],
                          style: TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}

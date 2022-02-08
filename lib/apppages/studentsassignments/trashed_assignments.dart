import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

class TrashedAssignmentss extends StatefulWidget {
  static const String id = 'trashed_assignments';
  @override
  _TrashedAssignmentssState createState() => _TrashedAssignmentssState();
}

class _TrashedAssignmentssState extends State<TrashedAssignmentss> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getTrashedAssignments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrashedAssignments = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('assignments')
        .where('pending', isEqualTo: true)
        .snapshots();
  }

  var dated = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'TRASHED ASSIGNMENTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getTrashedAssignments,
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                backgroundColor: kMainColor,
              );
            }
            final assignments = snapshots.data!.docs;
            return ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Container(
                          height: 15,
                          color: Color(assignments[index].data()['colors']),
                        ),
                        SizedBox(height: 7),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${assignments[index].data()['title']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                        assignments[index].data()['colors'])),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${assignments[index].data()['details']}',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 12),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Deadline: ',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    dated.format(
                                      DateTime.parse(assignments[index]
                                          .data()['deadline']
                                          .toDate()
                                          .toString()),
                                    ),
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await _firestore
                                          .collection('profiles')
                                          .doc(_auth.currentUser!.uid)
                                          .collection('assignments')
                                          .doc(assignments[index].id)
                                          .update({
                                        'pending': false,
                                      });
                                      showFlushBarRestore();
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        color: Colors.teal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        child: Text(
                                          'Restore',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await _firestore
                                          .collection('profiles')
                                          .doc(_auth.currentUser!.uid)
                                          .collection('assignments')
                                          .doc(assignments[index].id)
                                          .delete()
                                          .then((value) => showFlushBar());
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  showFlushBar() {
    return Flushbar(
      title: 'Delete Successful',
      message: 'Your assignment has been deleted successfully',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.redAccent,
      leftBarIndicatorColor: Colors.white,
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.white,
      ),
    )..show(context);
  }

  showFlushBarRestore() {
    return Flushbar(
      title: 'Restore Successful',
      message: 'Your assignment has been Restored successfully',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: kMainColor,
      leftBarIndicatorColor: Colors.white,
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.white,
      ),
    )..show(context);
  }
}

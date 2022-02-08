import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';

class TrashedTermPapers extends StatefulWidget {
  static const String id = 'termPapers';
  @override
  _TrashedTermPapersState createState() => _TrashedTermPapersState();
}

class _TrashedTermPapersState extends State<TrashedTermPapers> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getTrashedTermPapers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTrashedTermPapers = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('termPapers')
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
          'TRASHED TERM PAPERS',
          style: GoogleFonts.montserrat(
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
          stream: getTrashedTermPapers,
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                backgroundColor: kMainColor,
              );
            }
            final termpapers = snapshots.data!.docs;
            return ListView.builder(
                itemCount: termpapers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          color: Color(termpapers[index].data()['colors']),
                        ),
                        SizedBox(height: 7),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${termpapers[index].data()['title']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${termpapers[index].data()['details']}',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 12),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Deadline: '),
                                  Text(dated.format(
                                    DateTime.parse(termpapers[index]
                                        .data()['deadline']
                                        .toDate()
                                        .toString()),
                                  )),
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
                                          .collection('termPapers')
                                          .doc(termpapers[index].id)
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
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
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
                                          .collection('termPapers')
                                          .doc(termpapers[index].id)
                                          .delete();
                                      showFlushBar();
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
      message: 'Your Term Paper has been deleted successfully',
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
      message: 'Your Term Paper has been Restored successfully',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Color(0xff0a5e51),
      leftBarIndicatorColor: Color(0xffffd428),
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Color(0xffffd428),
      ),
    )..show(context);
  }
}

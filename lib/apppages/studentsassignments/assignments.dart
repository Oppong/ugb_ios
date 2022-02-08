import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ugbs_dawuro_ios/apppages/studentsassignments/trashed_assignments.dart';

import '../../constant.dart';
import 'add_assignments.dart';
import 'assignment_details.dart';

class AssignmentsPage extends StatefulWidget {
  static const String id = 'assignments_page';
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getAssignments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignments = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('assignments')
        .where('pending', isEqualTo: false)
        .snapshots();
  }

  var dated = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'ASSIGNMENTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.pushNamed(context, TrashedAssignmentss.id);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getAssignments,
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                backgroundColor: kMainColor,
              );
            }
            final assignments = snapshots.data!.docs;
            return assignments.isEmpty
                ? Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/assign.png'),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No assignments yet, Tap on the button below to add assignment',
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              color: Color(assignments[index].data()['colors']),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Text(
                                    'Pending',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  Spacer(),
                                  PopupMenuButton(
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.white),
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            onTap: () async {
                                              await _firestore
                                                  .collection('profiles')
                                                  .doc(_auth.currentUser!.uid)
                                                  .collection('assignments')
                                                  .doc(assignments[index].id)
                                                  .update({
                                                'pending': true,
                                              }).then((value) =>
                                                      showFlushBarTrash());
                                              cancelSchedule(assignments[index]
                                                  .data()['notifyId']);
                                            },
                                            child: Text(
                                              'Trash Assignment',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              notifyEveryFourHours(
                                                title: assignments[index]
                                                    .data()['title'],
                                                notifyId: assignments[index]
                                                    .data()['notifyId'],
                                                details: assignments[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 4hrs for'
                                                      ' Your ${assignments[index].data()['title']} Assignment'),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Notify Every 4hrs',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              notifyEveryEightHours(
                                                title: assignments[index]
                                                    .data()['title'],
                                                notifyId: assignments[index]
                                                    .data()['notifyId'],
                                                details: assignments[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 8hrs for'
                                                      ' Your ${assignments[index].data()['title']} Assignment'),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Notify Every 8hrs',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              notifyEveryTwentyFourHours(
                                                title: assignments[index]
                                                    .data()['title'],
                                                notifyId: assignments[index]
                                                    .data()['notifyId'],
                                                details: assignments[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 24hrs for'
                                                      ' Your ${assignments[index].data()['title']} Assignment'),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Notify Every 24hrs',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              cancelSchedule(assignments[index]
                                                  .data()['notifyId']);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Your Scheduled Notification(s) for'
                                                      ' ${assignments[index].data()['title']} Assignments has been Canceled'),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Cancel Notifications',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ];
                                      })
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignmentsDetails(
                                        title:
                                            assignments[index].data()['title'],
                                        colors:
                                            assignments[index].data()['colors'],
                                        details: assignments[index]
                                            .data()['details'],
                                        deadline: assignments[index]
                                            .data()['deadline']
                                            .toDate(),
                                        assignmentId: assignments[index].id,
                                        time: assignments[index]
                                            .data()['time']
                                            .toDate(),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${assignments[index].data()['title']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(assignments[index]
                                            .data()['colors']),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${assignments[index].data()['details']}',
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          'Deadline:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
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
                                              color: Colors.redAccent,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainColor,
        onPressed: () {
          Navigator.pushNamed(context, AddAssignmentsPage.id);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showFlushBarTrash() {
    return Flushbar(
      title: 'Trashed Successful',
      message: 'Your assignment has been Trashed successfully',
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

  showFlushBarNotification({String? hrs}) {
    return Flushbar(
      title: 'Notification Scheduled',
      message: hrs,
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

  void notifyEveryFourHours(
      {String? title, String? details, int? notifyId}) async {
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifyId!,
        channelKey: 'assignment',
        title: title,
        body: details,
        autoDismissible: true,
      ),
      schedule: NotificationInterval(
        interval: 14400,
        allowWhileIdle: true,
        timeZone: timezone,
        repeats: true,
      ),
    );
  }

  void notifyEveryEightHours(
      {String? title, String? details, int? notifyId}) async {
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifyId!,
        channelKey: 'assignment',
        title: title,
        body: details,
        autoDismissible: true,
      ),
      schedule: NotificationInterval(
        interval: 28800,
        allowWhileIdle: true,
        timeZone: timezone,
        repeats: true,
      ),
    );
  }

  void notifyEveryTwentyFourHours(
      {String? title, String? details, int? notifyId}) async {
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifyId!,
        channelKey: 'assignment',
        title: title,
        body: details,
        autoDismissible: true,
      ),
      schedule: NotificationInterval(
        interval: 86400,
        allowWhileIdle: true,
        timeZone: timezone,
        repeats: true,
      ),
    );
  }

  Future<void> cancelSchedule(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}

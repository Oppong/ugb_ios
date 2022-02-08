import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ugbs_dawuro_ios/apppages/studentstermpaper/termpaper_details.dart';
import 'package:ugbs_dawuro_ios/apppages/studentstermpaper/trashed_termpaper.dart';

import '../../constant.dart';
import 'addTermPaper.dart';

class TermPapers extends StatefulWidget {
  static const String id = 'termpapers';
  @override
  _TermPapersState createState() => _TermPapersState();
}

class _TermPapersState extends State<TermPapers> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var dated = DateFormat.yMMMd();

  int? notifyId;
  String? title;
  String? details;
  DateTime? deadline;
  DateTime? time;

  late Stream<QuerySnapshot<Map<String, dynamic>>> getTermPapers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTermPapers = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('termPapers')
        .where('pending', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'TERM PAPER',
          style: GoogleFonts.montserrat(
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
                Navigator.pushNamed(context, TrashedTermPapers.id);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getTermPapers,
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                backgroundColor: kMainColor,
              );
            }
            final termPapers = snapshots.data!.docs;
            return termPapers.isEmpty
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('images/term.png'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No Term Paper(s) yet, \n Tap on the button below to add TermPaper',
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: termPapers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              color: Color(termPapers[index].data()['colors']),
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
                                                  .collection('termPapers')
                                                  .doc(termPapers[index].id)
                                                  .update({
                                                'pending': true,
                                              }).then((value) =>
                                                      showFlushBarTrash());
                                              // after trashing assignment we cancel all notifications for that assignment
                                              cancelSchedule(termPapers[index]
                                                  .data()['notifyId']);
                                            },
                                            child: Text(
                                              'Trash Assignment',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              notifyEveryFourHours(
                                                title: termPapers[index]
                                                    .data()['title'],
                                                notifyId: termPapers[index]
                                                    .data()['notifyId'],
                                                details: termPapers[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 4hrs for'
                                                      ' Your ${termPapers[index].data()['title']} Term Paper '),
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
                                                title: termPapers[index]
                                                    .data()['title'],
                                                notifyId: termPapers[index]
                                                    .data()['notifyId'],
                                                details: termPapers[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 8hrs for'
                                                      ' Your ${termPapers[index].data()['title']} Term Paper '),
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
                                                title: termPapers[index]
                                                    .data()['title'],
                                                notifyId: termPapers[index]
                                                    .data()['notifyId'],
                                                details: termPapers[index]
                                                    .data()['details'],
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You will be Notified Every 24hrs for'
                                                      ' Your ${termPapers[index].data()['title']} Term Paper '),
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
                                              cancelSchedule(termPapers[index]
                                                  .data()['notifyId']);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Your Scheduled Notification(s) for'
                                                      ' ${termPapers[index].data()['title']} Term Paper has been Canceled '),
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
                                      builder: (context) => TermPapersDetails(
                                        title:
                                            termPapers[index].data()['title'],
                                        colors:
                                            termPapers[index].data()['colors'],
                                        details:
                                            termPapers[index].data()['details'],
                                        deadline: termPapers[index]
                                            .data()['deadline']
                                            .toDate(),
                                        termPaperId: termPapers[index].id,
                                        time: termPapers[index]
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
                                      '${termPapers[index].data()['title']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                            termPapers[index].data()['colors']),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${termPapers[index].data()['details']}',
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
                                            DateTime.parse(termPapers[index]
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
          Navigator.pushNamed(context, AddTermPaper.id);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showFlushBarTrash() {
    return Flushbar(
      title: 'Trashed Successful',
      message: 'Your term paper has been Trashed successfully',
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

  void notifyEveryFourHours(
      {String? title, String? details, int? notifyId}) async {
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifyId!,
        channelKey: 'term paper',
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
        channelKey: 'term paper',
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
        channelKey: 'term paper',
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

/*
 showFlushBarNotification({String? hrs}) {
    return Flushbar(
      title: 'Notification Scheduled',
      message: hrs,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.pink,
      leftBarIndicatorColor: Colors.white,
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.white,
      ),
    )..show(context);
  }
 */

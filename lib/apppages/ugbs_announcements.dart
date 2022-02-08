import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constant.dart';

class UGBSAnnouncements extends StatefulWidget {
  const UGBSAnnouncements({Key? key}) : super(key: key);
  static const String id = 'ugbs information';

  @override
  _UGBSAnnouncementsState createState() => _UGBSAnnouncementsState();
}

class _UGBSAnnouncementsState extends State<UGBSAnnouncements> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getAnnouncements;
  final ScrollController _scrollController = ScrollController();
  int docsLimit = 10;
  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();

  late FirebaseMessaging messaging;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnnouncements = _firestore
        .collection('Announcements')
        .orderBy('createdAt', descending: true)
        .limitToLast(docsLimit)
        .snapshots();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        setState(() {
          docsLimit = docsLimit + 10;
        });
      }

      getAnnouncements = _firestore
          .collection('Announcements')
          .orderBy('createdAt', descending: true)
          .limitToLast(docsLimit)
          .snapshots();
    });

    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic('announcements');

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'UGBS ANNOUNCEMENTS',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getAnnouncements,
            builder: (context, snapshots) {
              if (!snapshots.hasData) return LinearProgressIndicator();
              final announcements = snapshots.data!.docs;
              return ListView.builder(
                  controller: _scrollController,
                  // reverse: true,
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            announcements[index].data()['imageUrl'] == null
                                ? Container()
                                : Image.network(
                                    announcements[index].data()['imageUrl'],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                            SizedBox(height: 7),
                            Text(
                              announcements[index].data()['title'],
                              style: TextStyle(color: kMainColor),
                            ),
                            SizedBox(height: 10),
                            SelectableText(
                              announcements[index].data()['details'],
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 20),
                            announcements[index].data()['urlLink'] == null
                                ? Container()
                                : Text(
                                    announcements[index].data()['urlLink'],
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 10,
                                    ),
                                  ),
                            SizedBox(height: 7),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: kMainColor, size: 16),
                                SizedBox(width: 5.0),
                                Text(
                                  dated.format(
                                    DateTime.parse(announcements[index]
                                        .data()['createdAt']
                                        .toDate()
                                        .toString()),
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 10),
                                ),
                                Spacer(),
                                Text(
                                  timed.format(
                                    DateTime.parse(announcements[index]
                                        .data()['createdAt']
                                        .toDate()
                                        .toString()),
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

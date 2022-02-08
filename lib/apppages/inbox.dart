import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);
  static const String id = 'inbox';

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessages;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getReadMessages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUnreadMessages = _firestore
        .collection('inbox')
        .doc(_auth.currentUser!.uid)
        .collection('studentInbox')
        .where('status', isEqualTo: 'unread')
        .snapshots();

    getReadMessages = _firestore
        .collection('inbox')
        .doc(_auth.currentUser!.uid)
        .collection('studentInbox')
        .where('status', isEqualTo: 'read')
        .snapshots();
  }

  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          title: Text(
            'INBOX',
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(
              child: Text('Unread Messages'),
            ),
            Tab(
              child: Text('Read Messages'),
            ),
          ]),
        ),
        body: TabBarView(children: [
          getAllUnreadMessages(),
          getAllReadMessages(),
        ]),
      ),
    );
  }

  getAllUnreadMessages() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getUnreadMessages,
          builder: (context, snapshots) {
            if (!snapshots.hasData) return LinearProgressIndicator();
            final unread = snapshots.data!.docs;
            return ListView.builder(
                itemCount: unread.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unread[index].data()['title'],
                            style: TextStyle(color: kMainColor),
                          ),
                          SizedBox(height: 10),
                          SelectableText(
                            unread[index].data()['message'],
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                height: 1.5),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 7),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: kMainColor, size: 16),
                              SizedBox(width: 5.0),
                              Text(
                                dated.format(
                                  DateTime.parse(unread[index]
                                      .data()['createdAt']
                                      .toDate()
                                      .toString()),
                                ),
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 10),
                              ),
                              Spacer(),
                              Text(
                                timed.format(
                                  DateTime.parse(unread[index]
                                      .data()['createdAt']
                                      .toDate()
                                      .toString()),
                                ),
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 10),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              await _firestore
                                  .collection('inbox')
                                  .doc(_auth.currentUser!.uid)
                                  .collection('studentInbox')
                                  .doc(unread[index].id)
                                  .update({'status': 'read'});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 3,
                              ),
                              child: Text(
                                'Mark as Read',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  getAllReadMessages() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getReadMessages,
          builder: (context, snapshots) {
            if (!snapshots.hasData) return LinearProgressIndicator();
            final unread = snapshots.data!.docs;
            return ListView.builder(
                itemCount: unread.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unread[index].data()['title'],
                            style: TextStyle(color: kMainColor),
                          ),
                          SizedBox(height: 10),
                          SelectableText(
                            unread[index].data()['message'],
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                height: 1.5),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 7),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: kMainColor, size: 16),
                              SizedBox(width: 5.0),
                              Text(
                                dated.format(
                                  DateTime.parse(unread[index]
                                      .data()['createdAt']
                                      .toDate()
                                      .toString()),
                                ),
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 10),
                              ),
                              Spacer(),
                              Text(
                                timed.format(
                                  DateTime.parse(unread[index]
                                      .data()['createdAt']
                                      .toDate()
                                      .toString()),
                                ),
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

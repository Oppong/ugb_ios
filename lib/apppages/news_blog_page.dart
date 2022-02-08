import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../constant.dart';
import 'news_blog_details.dart';

class NewsBlogPage extends StatefulWidget {
  const NewsBlogPage({Key? key}) : super(key: key);
  static const String id = 'News blog page';

  @override
  _NewsBlogPageState createState() => _NewsBlogPageState();
}

class _NewsBlogPageState extends State<NewsBlogPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> getNewsBlog;
  final _firestore = FirebaseFirestore.instance;
  var dated = DateFormat.yMMMd();

  late FirebaseMessaging messaging;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNewsBlog = _firestore
        .collection('newsBlog')
        .orderBy('createdAt', descending: true)
        .limitToLast(10)
        .snapshots();

    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic('newsblog');

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
          'NEWS BLOG',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getNewsBlog,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                final newsblog = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: newsblog.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsBlogDetails(
                              imageUrl: newsblog[index].data()['imageUrl'],
                              title: newsblog[index].data()['title'],
                              createdBy: newsblog[index].data()['createdBy'],
                              description:
                                  newsblog[index].data()['description'],
                              datePublished: newsblog[index]
                                  .data()['datePublished']
                                  .toDate(),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.white, Colors.black])
                                    .createShader(bounds);
                              },
                              child: Image.network(
                                newsblog[index].data()['imageUrl'],
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                newsblog[index].data()['title'],
                                style: TextStyle(
                                  color: kMainColor,
                                  height: 1.5,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                dated.format(
                                  DateTime.parse(newsblog[index]
                                      .data()['createdAt']
                                      .toDate()
                                      .toString()
                                      .toUpperCase()),
                                ),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  height: 1.5,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                newsblog[index].data()['description'],
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  height: 1.5,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })
        ],
      ),
    );
  }
}

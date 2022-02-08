import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ugbs_dawuro_ios/apppages/add_message_to_forum.dart';
import 'package:ugbs_dawuro_ios/apppages/forum_category_post.dart';
import 'package:ugbs_dawuro_ios/apppages/view_forum_message.dart';

import '../constant.dart';

class UGBSForum extends StatefulWidget {
  const UGBSForum({Key? key}) : super(key: key);
  static const String id = 'ugbs forum';

  @override
  _UGBSForumState createState() => _UGBSForumState();
}

class _UGBSForumState extends State<UGBSForum> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getUGBSForum;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getUGBSForumCategory;
  final ScrollController _scrollController = ScrollController();
  int docsLimit = 10;
  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUGBSForumCategory = _firestore.collection('forum').snapshots();
    getUGBSForum = _firestore.collectionGroup('posts').snapshots();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        setState(() {
          docsLimit = docsLimit + 10;
        });
      }

      getUGBSForum = _firestore
          .collectionGroup('posts')
          .orderBy('createdAt', descending: true)
          .limitToLast(docsLimit)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'UGBS FORUM',
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
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getUGBSForumCategory,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) return LinearProgressIndicator();
                  final forum = snapshots.data!.docs;
                  return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      itemCount: forum.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumCategoryPosts(
                                  categoryId: forum[index].id,
                                  categoryName:
                                      forum[index].data()['categoryName'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 9, bottom: 9),
                            child: Text(
                              forum[index].data()['categoryName'],
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        );
                      });
                }),
            Divider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, AddMessageToForum.id);
        },
        child: Icon(Icons.edit),
        backgroundColor: kMainColor,
      ),
    );
  }
}

/*
      getUGBSForum = _firestore
        .collection('forum')
        .orderBy('createdAt', descending: true)
        .limitToLast(docsLimit)
        .snapshots();
       */

/*
 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getUGBSForum,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) return LinearProgressIndicator();
                  final forum = snapshots.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      controller: _scrollController,
                      itemCount: forum.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewForumMessage(
                                  categoryId: forum[index].data()['categoryId'],
                                  title: forum[index].data()['title'],
                                ),
                              ),
                            );
                            await _firestore
                                .collection('forum')
                                .doc(forum[index].id)
                                .update({
                              'viewersCount': FieldValue.increment(1),
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            forum[index]
                                                .data()['userImageUrl']),
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'By: ${forum[index].data()['userName']}',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.remove_red_eye,
                                          color: Colors.grey.shade400,
                                          size: 16),
                                      Text(
                                        forum[index]
                                            .data()['viewersCount']
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    forum[index].data()['title'],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    forum[index].data()['message'],
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                        height: 1.5),
                                    // textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: kMainColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          forum[index].data()['categoryName'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                          ),
                                          // textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(height: 8),
                                      if (forum[index].data()['userId'] ==
                                          _auth.currentUser!.uid) ...[
                                        Row(
                                          children: [
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            GestureDetector(
                                              onTap: () async {
                                                await _firestore
                                                    .collection('forum')
                                                    .doc(forum[index].id)
                                                    .delete()
                                                    .then((value) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Post Deleted Successfully')));
                                                });
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  Row(
                                    children: [
                                      Text(
                                        dated.format(
                                          DateTime.parse(forum[index]
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
                                          DateTime.parse(forum[index]
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
                          ),
                        );
                      });
                }),
 */

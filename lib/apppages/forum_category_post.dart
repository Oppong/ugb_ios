import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ugbs_dawuro_ios/apppages/view_forum_message.dart';

import '../constant.dart';

class ForumCategoryPosts extends StatefulWidget {
  const ForumCategoryPosts({this.categoryName, this.categoryId, Key? key})
      : super(key: key);
  static const String id = 'Forum category posts';

  final String? categoryName, categoryId;

  @override
  _ForumCategoryPostsState createState() => _ForumCategoryPostsState();
}

class _ForumCategoryPostsState extends State<ForumCategoryPosts> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getUGBSForumCategoryPost;
  final ScrollController _scrollController = ScrollController();
  int docsLimit = 10;
  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUGBSForumCategoryPost = _firestore
        .collection('forum')
        .doc(widget.categoryId)
        .collection('posts')
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

      getUGBSForumCategoryPost = _firestore
          .collection('forum')
          .doc(widget.categoryId)
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limitToLast(docsLimit)
          .snapshots();
    });
  }

  String? message, title;
  final _messageController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          widget.categoryName!,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getUGBSForumCategoryPost,
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
                              categoryId: widget.categoryId,
                              forumId: forum[index].id,
                              title: forum[index].data()['title'],
                            ),
                          ),
                        );
                        await _firestore
                            .collection('forum')
                            .doc(widget.categoryId)
                            .collection('posts')
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
                                        forum[index].data()['userImageUrl']),
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
                                      color: Colors.grey.shade400, size: 16),
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'Tap to Comment',
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
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListView(
                                                  children: [
                                                    TextFormField(
                                                      initialValue: forum[index]
                                                          .data()['title'],
                                                      maxLines: null,
                                                      onChanged: (value) {
                                                        title = value;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Title';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            'Message Title',
                                                        hintStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(height: 20),
                                                    TextFormField(
                                                      initialValue: forum[index]
                                                          .data()['message'],
                                                      maxLines: null,
                                                      onChanged: (value) {
                                                        message = value;
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Message Details';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(30),
                                                        hintText:
                                                            'Message Details',
                                                        hintStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(height: 20),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        await _firestore
                                                            .collection('forum')
                                                            .doc(widget
                                                                .categoryId)
                                                            .collection('posts')
                                                            .doc(
                                                                forum[index].id)
                                                            .update({
                                                          'title': title ??
                                                              forum[index]
                                                                      .data()[
                                                                  'title'],
                                                          'message': message ??
                                                              forum[index]
                                                                      .data()[
                                                                  'message'],
                                                        }).then((value) {
                                                          return ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'Post Updated Successfully')));
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          Text('Update Post'),
                                                      style:
                                                          TextButton.styleFrom(
                                                        elevation: 0.0,
                                                        backgroundColor:
                                                            kMainColor,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        GestureDetector(
                                          onTap: () async {
                                            await _firestore
                                                .collection('forum')
                                                .doc(widget.categoryId)
                                                .collection('posts')
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
      ),
    );
  }
}

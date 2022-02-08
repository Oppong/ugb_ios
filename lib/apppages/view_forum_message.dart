import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';

import '../constant.dart';

class ViewForumMessage extends StatefulWidget {
  const ViewForumMessage({this.forumId, this.title, this.categoryId, Key? key})
      : super(key: key);
  static const String id = 'view forum message';

  final String? forumId;
  final String? title;
  final String? categoryId;

  @override
  _ViewForumMessageState createState() => _ViewForumMessageState();
}

class _ViewForumMessageState extends State<ViewForumMessage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> viewForumMessage;
  late Stream<QuerySnapshot<Map<String, dynamic>>> allCommentsForPost;
  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewForumMessage = _firestore
        .collection('forum')
        .doc(widget.categoryId)
        .collection('posts')
        .doc(widget.forumId)
        .snapshots();
    allCommentsForPost = _firestore
        .collection('forum')
        .doc(widget.categoryId)
        .collection('posts')
        .doc(widget.forumId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  String? commentMessage;
  final _commentMessageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? message, title;

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of(context);
    userProfileProvider.readUserProfileInfoSingle();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          widget.title!,
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
          shrinkWrap: true,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: viewForumMessage,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) return LinearProgressIndicator();
                  final forum = snapshots.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  NetworkImage(forum.data()!['userImageUrl']),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'By: ${forum.data()!['userName']}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.remove_red_eye,
                                color: Colors.grey.shade400, size: 16),
                            Text(
                              forum.data()!['viewersCount'].toString(),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Text(
                          forum.data()!['title'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        SelectableText(
                          forum.data()!['message'],
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              height: 1.5),
                          // textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              dated.format(
                                DateTime.parse(forum
                                    .data()!['createdAt']
                                    .toDate()
                                    .toString()),
                              ),
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 10),
                            ),
                            Spacer(),
                            Text(
                              timed.format(
                                DateTime.parse(forum
                                    .data()!['createdAt']
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
                  );
                }),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(userProfileProvider.imageUrl!),
                    ),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    flex: 4,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (value) {
                          commentMessage = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Add a comment';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Add a comment',
                          hintStyle: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                        style: TextStyle(color: Colors.black),
                        controller: _commentMessageController,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        final commentId = await _firestore
                            .collection('forum')
                            .doc(widget.categoryId)
                            .collection('posts')
                            .doc(widget.forumId)
                            .collection('comments')
                            .doc();
                        commentId.set({
                          'message': commentMessage,
                          'userId': _auth.currentUser!.uid,
                          'userImageUrl': userProfileProvider.imageUrl,
                          'userName': userProfileProvider.fullName,
                          'userEmail': userProfileProvider.email,
                          'commentId': commentId,
                          'createdAt': DateTime.now(),
                        }).then((value) {
                          return ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Comment Added Successfully')));
                        });
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 15),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: allCommentsForPost,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) return LinearProgressIndicator();
                  final comments = snapshots.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      comments[index].data()['userImageUrl']),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'By: ${comments[index].data()['userName']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            SelectableText(
                              comments[index].data()['message'],
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  height: 1.5),
                              // textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  dated.format(
                                    DateTime.parse(comments[index]
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
                                    DateTime.parse(comments[index]
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
                            SizedBox(height: 8),
                            if (comments[index].data()['userId'] ==
                                _auth.currentUser!.uid) ...[
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                            children: [
                                              TextFormField(
                                                initialValue: comments[index]
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
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(30),
                                                  hintText: 'Message Details',
                                                  hintStyle: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade500),
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
                                                      .doc(widget.categoryId)
                                                      .collection('posts')
                                                      .doc(widget.forumId)
                                                      .collection('comments')
                                                      .doc(comments[index].id)
                                                      .update({
                                                    'message': message ??
                                                        comments[index]
                                                            .data()['message'],
                                                  }).then((value) {
                                                    return ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Comment Updated Successfully')),
                                                    );
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Text('Update Comment'),
                                                style: TextButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor: kMainColor,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
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
                                          .doc(widget.forumId)
                                          .collection('comments')
                                          .doc(comments[index].id)
                                          .delete()
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Comment Deleted Successfully')));
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
                            SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

/*
onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForumCategoryPosts(
                                    categoryId: widget.categoryId,
                                    categoryName: forum.data()!['categoryName'],
                                  ),
                                ),
                              );
                            },
 */

/*
Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            forum.data()!['categoryName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            // textAlign: TextAlign.justify,
                          ),
                        ),
 */

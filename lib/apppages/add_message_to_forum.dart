import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';
import '../constant.dart';

class AddMessageToForum extends StatefulWidget {
  const AddMessageToForum({Key? key}) : super(key: key);
  static const String id = 'add message to forum';

  @override
  _AddMessageToForumState createState() => _AddMessageToForumState();
}

class _AddMessageToForumState extends State<AddMessageToForum> {
  String? message, title;
  dynamic categoryName;
  int? viewersCount;
  bool isLoading = false;

  final _messageController = TextEditingController();
  final _titleController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getUGBSForumCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUGBSForumCategory = _firestore.collection('forum').snapshots();
  }

  String? documentId;

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of(context);
    userProfileProvider.readUserProfileInfoSingle();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'ADD FORUM MESSAGE',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: kMainColor,
              ),
            )
          : Form(
              key: _formKey,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getUGBSForumCategory,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    }
                    final forumCategory = snapshot.data!.docs;
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              DropdownButton(
                                  value: categoryName,
                                  hint: Text('Choose from Category'),
                                  items:
                                      forumCategory.map((DocumentSnapshot doc) {
                                    return DropdownMenuItem<String>(
                                      value: doc.get('categoryName'),
                                      child: Text(
                                        doc.get('categoryName'),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          documentId = doc.id;
                                        });
                                      },
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      categoryName = val;
                                    });
                                  }),
                              SizedBox(height: 20),
                              TextFormField(
                                maxLines: null,
                                onChanged: (value) {
                                  title = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Title';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Message Title',
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                                style: TextStyle(color: Colors.black),
                                controller: _titleController,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                maxLines: null,
                                onChanged: (value) {
                                  message = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Message Details';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(30),
                                  hintText: 'Message Details',
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                                style: TextStyle(color: Colors.black),
                                controller: _messageController,
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (categoryName == null) {
                                        return showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  content: Text(
                                                      'select a forum category'),
                                                ));
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final forumId = _firestore
                                            .collection('forum')
                                            .doc(documentId)
                                            .collection('posts')
                                            .doc();
                                        await forumId.set({
                                          'title': title,
                                          'message': message,
                                          'createdAt': DateTime.now(),
                                          'forumId': forumId,
                                          'userName':
                                              userProfileProvider.fullName,
                                          'userEmail':
                                              userProfileProvider.email,
                                          'userId': userProfileProvider.userId,
                                          'userImageUrl':
                                              userProfileProvider.imageUrl,
                                          'viewersCount': 0,
                                          'categoryName': categoryName,
                                          'categoryId': documentId,
                                        });
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _titleController.clear();
                                        _messageController.clear();
                                        _categoryNameController.clear();
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Send Message',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 0.0,
                                    backgroundColor: kMainColor,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
    );
  }
}

/*
ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Message Added to Forum Successfully'),
                                            ),
                                          );
 */

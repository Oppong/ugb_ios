import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ugbs_dawuro_ios/models/forum_model.dart';

class ForumProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<ForumModel> itemsForumList = [];

  readForum() async {
    List<ForumModel> newItemForumList = [];

    QuerySnapshot dS = await _firestore.collection('forum').get();

    dS.docs.forEach((el) {
      ForumModel forumModel = ForumModel(
        categoryName: el.get(' categoryName'),
        categoryId: el.get('categoryId'),
      );

      newItemForumList.add(forumModel);
    });
    itemsForumList = newItemForumList;
    notifyListeners();
  }
}

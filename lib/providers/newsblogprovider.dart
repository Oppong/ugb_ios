import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ugbs_dawuro_ios/models/newsblogmodel.dart';

class NewsBlogProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<NewsBlogModel> itemsNewsBlogList = [];

  readNewsBlogs() async {
    List<NewsBlogModel> newItemNewsBlogList = [];

    QuerySnapshot dS = await _firestore
        .collection('newsBlog')
        .orderBy('createdAt')
        .limitToLast(1)
        .get();

    dS.docs.forEach((el) {
      NewsBlogModel newsBlogModel = NewsBlogModel(
        createdAt: el.get('createdAt').toDate(),
        createdBy: el.get('createdBy'),
        imageUrl: el.get('imageUrl'),
        title: el.get('title'),
        description: el.get('description'),
        newsBlogId: el.get('newsBlogId').toString(),
        datePublished: el.get('datePublished').toDate(),
      );

      newItemNewsBlogList.add(newsBlogModel);
    });
    itemsNewsBlogList = newItemNewsBlogList;
    notifyListeners();
  }
}

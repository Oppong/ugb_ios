import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:ugbs_dawuro_ios/models/termpaper.dart';

class TermPaperProvider extends ChangeNotifier {
  List<TermPaperModel> termPaperModelList = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  addTermPaper({
    String? title,
    String? details,
    DateTime? deadline,
    String? termPaperId,
    bool? pending = false,
    int? termPaperColor,
    DateTime? time,
    int? notifyId,
  }) async {
    final termPaperItem = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('termPapers')
        .doc();

    termPaperId = termPaperItem.id;
    final notifyId = randomNumeric(4);

    await termPaperItem.set({
      'title': title,
      'details': details,
      'deadline': deadline,
      'pending': false,
      'createdAt': DateTime.now(),
      'termPaperId': termPaperId,
      'colors': termPaperColor,
      'time': time,
      'notifyId': int.parse(notifyId),
    });

    notifyListeners();
  }

  readTermPaper() async {
    List<TermPaperModel> newTermPaperModelList = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('termPapers')
        .where('pending', isEqualTo: false)
        .get();

    querySnapshot.docs.forEach((el) {
      TermPaperModel termPaperModel = TermPaperModel(
        title: el.get('title'),
        details: el.get('details'),
        deadline: el.get('deadline').toDate(),
        termPaperId: el.get('termPaperId'),
        pending: el.get('pending'),
        time: el.get('time').toDate(),
      );

      newTermPaperModelList.add(termPaperModel);
    });

    termPaperModelList = newTermPaperModelList;
    notifyListeners();
  }

  updateTermPaper({
    final String? title,
    String? details,
    DateTime? deadline,
    termPaperId,
    bool pending = false,
    int? termPaperColor,
    DateTime? time,
  }) async {
    final termPaperItem = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('termPapers')
        .doc(termPaperId);

    await termPaperItem.update({
      'title': title,
      'details': details,
      'deadline': deadline,
      'pending': pending,
      'colors': termPaperColor,
      'time': time,
    });

    notifyListeners();
  }

  int get termPaperCount {
    return termPaperModelList.length;
  }
}

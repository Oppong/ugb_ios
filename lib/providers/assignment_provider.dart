import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:ugbs_dawuro_ios/models/assignments.dart';

class AssignmentsProvider extends ChangeNotifier {
  List<AssignmentsModel> assignmentsModelList = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  addAssignments({
    String? title,
    String? details,
    DateTime? deadline,
    String? assignmentsId,
    bool? pending = false,
    int? assignmentColor,
    DateTime? time,
    int? notifyId,
  }) async {
    final assignmentItem = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('assignments')
        .doc();

    assignmentsId = assignmentItem.id;
    final notifyId = randomNumeric(4);
    await assignmentItem.set({
      'title': title,
      'details': details,
      'deadline': deadline,
      'pending': pending,
      'createdAt': DateTime.now(),
      'assignmentsId': assignmentsId,
      'colors': assignmentColor,
      'time': time,
      'notifyId': int.parse(notifyId),
    });

    notifyListeners();
  }

  readAssignments() async {
    List<AssignmentsModel> newAssignmentsModelList = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('studentsassignments')
        .where('pending', isEqualTo: false)
        .get();

    querySnapshot.docs.forEach((el) {
      AssignmentsModel assignmentsModel = AssignmentsModel(
        title: el.get('title'),
        details: el.get('details'),
        deadline: el.get('deadline').toDate(),
        assignmentsId: el.get('assignmentsId'),
        pending: el.get('pending'),
        colors: el.get('colors'),
        time: el.get('time').toDate(),
      );

      newAssignmentsModelList.add(assignmentsModel);
    });

    assignmentsModelList = newAssignmentsModelList;
    notifyListeners();
  }

  updateAssignments({
    String? title,
    String? details,
    DateTime? deadline,
    assignmentsId,
    bool pending = false,
    int? assignmentColor,
    DateTime? time,
  }) async {
    final assignmentItem = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('studentsassignments')
        .doc(assignmentsId);

    await assignmentItem.update({
      'title': title,
      'details': details,
      'deadline': deadline,
      'pending': pending,
      'colors': assignmentColor,
      'time': time
    });

    notifyListeners();
  }

  int get assignmentsCount {
    return assignmentsModelList.length;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ugbs_dawuro_ios/models/user_profile_model.dart';

class UserProfileProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<UserProfileModel> itemsUserProfileList = [];

  String? fullName, email, imageUrl, userId, userType, studentId, programme;
  DateTime? createdAt;

  readUserProfileInfoSingle() async {
    final dS =
        _firestore.collection('profiles').doc(_auth.currentUser?.uid).get();
    dS.then((value) {
      UserProfileModel userProfileModel = UserProfileModel(
        email: value.data()?['email'],
        fullName: value.data()?['fullName'],
        imageUrl: value.data()?['imageUrl'],
        userId: value.data()?['userId'],
        userType: value.data()?['userType'],
        studentId: value.data()?['studentId'],
        createdAt: value.data()?['createdAt'].toDate(),
        programme: value.data()?['programme'],
      );

      fullName = userProfileModel.fullName;
      email = userProfileModel.email;
      imageUrl = userProfileModel.imageUrl;
      userId = userProfileModel.userId;
      userType = userProfileModel.userType;
      studentId = userProfileModel.studentId;
      createdAt = userProfileModel.createdAt;
      programme = userProfileModel.programme;
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) => notifyListeners());
  }

  readAllUsersProfileInfo() async {
    List<UserProfileModel> newItemsUserProfile = [];
    QuerySnapshot dS = await _firestore.collection('profiles').get();
    dS.docs.forEach((value) {
      UserProfileModel userProfileModel = UserProfileModel(
        email: value.get('email'),
        fullName: value.get('fullName'),
        imageUrl: value.get('imageUrl'),
        userId: value.get('userId'),
        userType: value.get('userType'),
        createdAt: value.get('createdAt').toDate(),
        studentId: value.get('studentId'),
        programme: value.get('programme'),
      );
      newItemsUserProfile.add(userProfileModel);
    });
    itemsUserProfileList = newItemsUserProfile;
    WidgetsBinding.instance?.addPostFrameCallback((_) => notifyListeners());
  }
}

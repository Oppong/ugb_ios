import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ugbs_dawuro_ios/widgets/update_profile.dart';
import 'package:image_picker/image_picker.dart';
import '../constant.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String id = 'profile page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> getUserProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserProfile = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  File? profileImage;

  getProfileImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 5);

    setState(() {
      profileImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getUserProfile,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            final profile = snapshot.data;
            return ListView(
              children: [
                profileImage == null
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: kMainColor,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profile?.data()!['imageUrl']),
                            )),
                        child: Container(
                          padding: EdgeInsets.only(top: 5, left: 5),
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Image.file(
                            profileImage!,
                            height: 250,
                            width: 1000,
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: kMainColor),
                            onPressed: () async {
                              firebase_storage.Reference storageRef =
                                  firebase_storage.FirebaseStorage.instance
                                      .ref()
                                      .child('profiles/${profileImage!}');
                              await storageRef.putFile(profileImage!);

                              // download url
                              final String downloadUrl =
                                  await storageRef.getDownloadURL();

                              await _firestore
                                  .collection('profiles')
                                  .doc(_auth.currentUser?.uid)
                                  .update({
                                'imageUrl': downloadUrl,
                              }).then((value) {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Profile Image Updated Successfully'),
                                  ),
                                );
                              });
                            },
                            child: Text('Upload Image'),
                          ),
                        ],
                      ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 18,
                    color: kMainColor,
                  ),
                  title: Text(
                    'FullName',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    profile?.data()!['fullName'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => UpdateFullName());
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    size: 18,
                    color: kMainColor,
                  ),
                  title: Text(
                    'Email',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    profile?.data()!['email'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.bolt,
                    size: 18,
                    color: kMainColor,
                  ),
                  title: Text(
                    'Programme of Study',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    profile?.data()!['programme'],
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => UpdateProgramme());
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 18,
                    color: kMainColor,
                  ),
                  title: Text(
                    'Student Id',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    profile?.data()!['studentId'],
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => UpdateStudentId());
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Update Image'),
        backgroundColor: kMainColor,
        onPressed: getProfileImage,
        icon: Icon(
          Icons.photo,
        ),
      ),
    );
  }
}

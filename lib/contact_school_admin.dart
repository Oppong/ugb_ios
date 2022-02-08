import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSchoolAdmin extends StatefulWidget {
  const ContactSchoolAdmin({Key? key}) : super(key: key);
  static const String id = 'contact school admin';

  @override
  _ContactSchoolAdminState createState() => _ContactSchoolAdminState();
}

class _ContactSchoolAdminState extends State<ContactSchoolAdmin> {
  final _firestore = FirebaseFirestore.instance;
  String? message, subject, createdAt;
  bool isLoading = false;

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of(context);
    userProfileProvider.readUserProfileInfoSingle();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'CONTACT US',
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
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: double.infinity,
                    height: 60,
                    color: Colors.blueGrey.withOpacity(0.3),
                    child: Text(
                      'Hi, ${userProfileProvider.fullName} you can contact the School Administrator by filling '
                      'the form below or through WhatsApp or by Phone Call',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextFormField(
                          maxLines: null,
                          onChanged: (value) {
                            subject = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Subject Title';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Subject Title',
                            hintStyle: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          ),
                          style: TextStyle(color: Colors.black),
                          controller: _subjectController,
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
                                fontSize: 12, color: Colors.grey.shade500),
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
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isLoading = true;
                                });

                                final feedbackId = _firestore
                                    .collection('adminFeedback')
                                    .doc();
                                await feedbackId.set({
                                  'subject': subject,
                                  'message': message,
                                  'createdAt': DateTime.now(),
                                  'feedbackId': feedbackId,
                                  'status': 'unread',
                                  'sender': userProfileProvider.fullName,
                                  'senderEmail': userProfileProvider.email,
                                  'senderUserId': userProfileProvider.userId,
                                }).then((value) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Message Sent to School Admin Successfully'),
                                    ),
                                  );
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                _subjectController.clear();
                                _messageController.clear();
                              }
                            },
                            child: Text(
                              'Send Message',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "call",
            onPressed: () {
              launchCall();
            },
            child: FaIcon(FontAwesomeIcons.phone),
            backgroundColor: Colors.redAccent,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
              heroTag: "whatsapp",
              backgroundColor: Colors.green,
              child: FaIcon(FontAwesomeIcons.whatsapp),
              onPressed: () {
                launchWhatsApp(
                  phoneNumber: '+233 0540432790',
                  message: 'Hello',
                );
              }),
        ],
      ),
    );
  }

  launchCall() async {
    const _tel = 'tel: +233 0303963738';

    await canLaunch(_tel)
        ? await launch(_tel)
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('could not launch Call'),
                ));
  }

  launchWhatsApp({phoneNumber, message}) async {
    String url = 'whatsapp://send?phone=$phoneNumber&text=$message';

    await canLaunch(url)
        ? await launch(url)
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('could not launch whatsapp'),
                ));
  }
}

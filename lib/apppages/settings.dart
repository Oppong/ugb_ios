import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ugbs_dawuro_ios/widgets/drawer_item.dart';

import '../constant.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const String id = 'settings page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'SETTINGS',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          DrawerItems(
            label: 'About App',
            icon: Icons.android,
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (context) => aboutApp());
            },
          ),
        ],
      ),
    );
  }
}

aboutApp() {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: ListView(
      children: [
        Text(
            'This is the Official App for University of Ghana Business School'),
        SizedBox(height: 10),
        Text(
          'About UGBS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text('The University of Ghana Business School (UGBS) is a premier'
            ' business school in the sub-region focused on '
            'developing world-class human resources and '
            'capabilities to meet national development needs and '
            'global challenges, through quality teaching, learning,'
            ' research and knowledge dissemination.'),
        SizedBox(height: 10),
        Text(
          'App Version',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          '1.0.0',
          style: TextStyle(),
        ),
      ],
    ),
  );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ugbs_dawuro_ios/apppages/about_ugbs.dart';
import 'package:ugbs_dawuro_ios/apppages/profile_page.dart';
import 'package:ugbs_dawuro_ios/apppages/settings.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_management.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_mission_and_vission.dart';
import 'package:ugbs_dawuro_ios/authentication/signup_and_signin.dart';
import '../constant.dart';

final _auth = FirebaseAuth.instance;
popup() {
  return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutUGBSPage.id);
              },
              leading: Icon(
                Icons.assignment,
                color: kMainColor,
                size: 18,
              ),
              title: Text(
                'About UGBS',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, UGBSManagement.id);
              },
              leading: Icon(
                Icons.location_city_rounded,
                color: kMainColor,
                size: 18,
              ),
              title: Text(
                'UGBS Management',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          /*
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                // Navigator.pushNamed(context, AccountsScreen.id);
              },
              leading: Icon(
                Icons.help,
                color: kMainColor,
                size: 18,
              ),
              title: Text(
                'Help Section',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          */
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, SettingsPage.id);
              },
              leading: Icon(
                Icons.settings,
                color: kMainColor,
                size: 18,
              ),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.id);
              },
              leading: Icon(
                Icons.person,
                color: kMainColor,
                size: 18,
              ),
              title: Text(
                'Account Profile',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              onTap: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, SignUpAndSignIn.id, (route) => false);
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.redAccent,
                size: 18,
              ),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ];
      });
}

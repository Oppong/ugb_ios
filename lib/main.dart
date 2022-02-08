import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugbs_dawuro_ios/apppages/about_ugbs.dart';
import 'package:ugbs_dawuro_ios/apppages/add_message_to_forum.dart';
import 'package:ugbs_dawuro_ios/apppages/forum_category_post.dart';
import 'package:ugbs_dawuro_ios/apppages/homepage.dart';
import 'package:ugbs_dawuro_ios/apppages/inbox.dart';
import 'package:ugbs_dawuro_ios/apppages/news_blog_details.dart';
import 'package:ugbs_dawuro_ios/apppages/news_blog_page.dart';
import 'package:ugbs_dawuro_ios/apppages/profile_page.dart';
import 'package:ugbs_dawuro_ios/apppages/settings.dart';
import 'package:ugbs_dawuro_ios/apppages/students/student_details.dart';
import 'package:ugbs_dawuro_ios/apppages/students/students_list.dart';
import 'package:ugbs_dawuro_ios/apppages/studentstermpaper/termpaper_details.dart';
import 'package:ugbs_dawuro_ios/apppages/studentstermpaper/trashed_termpaper.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_forum.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_announcements.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_management.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_mission_and_vission.dart';
import 'package:ugbs_dawuro_ios/apppages/view_document.dart';
import 'package:ugbs_dawuro_ios/apppages/view_forum_message.dart';
import 'package:ugbs_dawuro_ios/authentication/signup_and_signin.dart';
import 'package:ugbs_dawuro_ios/contact_school_admin.dart';
import 'package:ugbs_dawuro_ios/intro/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/assignment_provider.dart';
import 'package:ugbs_dawuro_ios/providers/forum_provider.dart';
import 'package:ugbs_dawuro_ios/providers/newsblogprovider.dart';
import 'package:ugbs_dawuro_ios/providers/termpaper_provider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';
import 'apppages/studentsassignments/add_assignments.dart';
import 'apppages/studentsassignments/assignment_details.dart';
import 'apppages/studentsassignments/assignments.dart';
import 'apppages/studentsassignments/trashed_assignments.dart';
import 'apppages/studentstermpaper/addTermPaper.dart';
import 'apppages/studentstermpaper/termpaper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'apppages/ugbs_information_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SharedPreferences pref = await SharedPreferences.getInstance();
  dynamic email = pref.get('email');
  runApp(
    UGBSInfoApp(email: email),
  );

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'term paper',
      channelName: 'Term Paper Notification',
      channelDescription: 'This is the notification channel for term paper',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
    ),
    NotificationChannel(
      channelKey: 'assignment',
      channelName: 'Assignments Notification',
      channelDescription: 'This is the notification channel for Assignments',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
    ),
    NotificationChannel(
      channelKey: 'announcements',
      channelName: 'Announcements Notification',
      channelDescription: 'This is the notification channel for Announcements',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
    ),
    NotificationChannel(
      channelKey: 'newsblog',
      channelName: 'NewsBlog Notification',
      channelDescription: 'This is the notification channel for News Blog',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
    ),
    NotificationChannel(
      channelKey: 'info',
      channelName: 'Information Resources Notification',
      channelDescription:
          'This is the notification channel for Information Resources',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
    ),
  ]);
}

class UGBSInfoApp extends StatelessWidget {
  // const UGBSInfoApp({this.email, Key? key}) : super(key: key);
  final String? email;
  UGBSInfoApp({this.email});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsBlogProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => AssignmentsProvider()),
        ChangeNotifierProvider(create: (context) => TermPaperProvider()),
        ChangeNotifierProvider(create: (context) => ForumProvider()),
      ],
      child: MaterialApp(
        // home: email != null ? HomePage() : SplashPage(),
        home: SignUpAndSignIn(),
        routes: {
          SplashPage.id: (context) => SplashPage(),
          SignUpAndSignIn.id: (context) => SignUpAndSignIn(),

          // app pages
          HomePage.id: (context) => HomePage(),
          NewsBlogPage.id: (context) => NewsBlogPage(),
          NewsBlogDetails.id: (context) => NewsBlogDetails(),
          AboutUGBSPage.id: (context) => AboutUGBSPage(),
          UGBSMissionAndVision.id: (context) => UGBSMissionAndVision(),
          ContactSchoolAdmin.id: (context) => ContactSchoolAdmin(),
          UGBSAnnouncements.id: (context) => UGBSAnnouncements(),
          UGBSInformationResources.id: (context) => UGBSInformationResources(),
          UGBSForum.id: (context) => UGBSForum(),
          ViewForumMessage.id: (context) => ViewForumMessage(),
          AddMessageToForum.id: (context) => AddMessageToForum(),
          ForumCategoryPosts.id: (context) => ForumCategoryPosts(),
          InboxPage.id: (context) => InboxPage(),
          UGBSManagement.id: (context) => UGBSManagement(),
          ProfilePage.id: (context) => ProfilePage(),
          SettingsPage.id: (context) => SettingsPage(),
          ViewDocument.id: (context) => ViewDocument(),

          //students list
          StudentsList.id: (context) => StudentsList(),
          StudentDetails.id: (context) => StudentDetails(),

          // Students Assignments
          AssignmentsPage.id: (context) => AssignmentsPage(),
          AssignmentsDetails.id: (context) => AssignmentsDetails(),
          AddAssignmentsPage.id: (context) => AddAssignmentsPage(),
          TrashedAssignmentss.id: (context) => TrashedAssignmentss(),
          // Students term papers
          AddTermPaper.id: (context) => AddTermPaper(),
          TermPapers.id: (context) => TermPapers(),
          TermPapersDetails.id: (context) => TermPapersDetails(),
          TrashedTermPapers.id: (context) => TrashedTermPapers(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.mulishTextTheme(),
          inputDecorationTheme: decorationTheme(),
        ),
      ),
    );
  }
}

decorationTheme() {
  return InputDecorationTheme(
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          color: Colors.grey.shade900, width: 3, style: BorderStyle.solid),
    ),
  );
}

Future<void> _messageHandler(RemoteMessage message) async {
  print(
      'Message from firebase ${message.notification!.title} and ${message.notification!.body} and ${message.data}');

  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

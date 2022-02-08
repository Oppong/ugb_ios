import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/apppages/inbox.dart';
import 'package:ugbs_dawuro_ios/apppages/news_blog_details.dart';
import 'package:ugbs_dawuro_ios/apppages/news_blog_page.dart';
import 'package:ugbs_dawuro_ios/apppages/profile_page.dart';
import 'package:ugbs_dawuro_ios/apppages/students/students_list.dart';
import 'package:ugbs_dawuro_ios/apppages/studentsassignments/assignment_details.dart';
import 'package:ugbs_dawuro_ios/apppages/studentsassignments/assignments.dart';
import 'package:ugbs_dawuro_ios/apppages/studentstermpaper/termpaper.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_forum.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_announcements.dart';
import 'package:ugbs_dawuro_ios/apppages/ugbs_information_resources.dart';
import 'package:ugbs_dawuro_ios/contact_school_admin.dart';
import 'package:ugbs_dawuro_ios/providers/newsblogprovider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';
import 'package:ugbs_dawuro_ios/widgets/drawer_item.dart';
import 'package:ugbs_dawuro_ios/widgets/news_blog_promo.dart';
import 'package:ugbs_dawuro_ios/widgets/popupmenu.dart';
import '../constant.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late Stream<QuerySnapshot<Map<String, dynamic>>> getNewsBlog;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getNewsBlogAll;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getAssignments;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNewsBlog = _firestore
        .collection('newsBlog')
        .orderBy('createdAt', descending: true)
        .limitToLast(1)
        .snapshots();

    getNewsBlogAll = _firestore
        .collection('newsBlog')
        .orderBy('createdAt', descending: true)
        .limitToLast(5)
        .snapshots();

    getAssignments = _firestore
        .collection('profiles')
        .doc(_auth.currentUser!.uid)
        .collection('assignments')
        .where('pending', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .limitToLast(1)
        .snapshots();

    WidgetsBinding.instance!.addObserver(this);
    setUserStatus('Online');
    setUserLastSeen(DateTime.now());
  }

  // set user status
  void setUserStatus(String status) async {
    await _firestore.collection('profiles').doc(_auth.currentUser!.uid).update({
      'status': status,
    });
  }

  void setUserLastSeen(DateTime lastSeen) async {
    await _firestore.collection('profiles').doc(_auth.currentUser!.uid).update({
      'lastSeen': lastSeen,
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserStatus('Online');
      setUserLastSeen(DateTime.now());
    } else {
      setUserStatus('Offline');
      setUserLastSeen(DateTime.now());
    }
  }

  int selectedIndex = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    NewsBlogProvider newsBlogProvider = Provider.of(context);
    newsBlogProvider.readNewsBlogs();

    UserProfileProvider userProfileProvider = Provider.of(context);
    userProfileProvider.readUserProfileInfoSingle();

    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'HOME',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [popup()],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          newsBlogPromo(),
          newsSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Text(
              'Assignments',
              style: TextStyle(
                color: kMainColor,
                fontSize: 12,
              ),
            ),
          ),
          assignmentsSection(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
          selectedItemColor: kMainColor,
          unselectedItemColor: Colors.grey.withOpacity(0.6),
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() {
              _currentIndex = i;
            });
          },
          items: [
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.campaign,
                  size: 18,
                ),
                title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UGBSAnnouncements.id);
                    },
                    child: Text(
                      'Announcements',
                      style: TextStyle(fontSize: 12),
                    ))),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.explore,
                  size: 18,
                ),
                title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, NewsBlogPage.id);
                    },
                    child: Text(
                      'News Blog',
                      style: TextStyle(fontSize: 12),
                    ))),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.forum,
                  size: 18,
                ),
                title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UGBSForum.id);
                    },
                    child: Text(
                      'Forum',
                      style: TextStyle(fontSize: 12),
                    ))),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.person,
                  size: 18,
                ),
                title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfilePage.id);
                    },
                    child: Text(
                      'Profile',
                      style: TextStyle(fontSize: 12),
                    ))),
          ]),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: kMainColor),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      '${Provider.of<UserProfileProvider>(context).imageUrl}'),
                ),
                SizedBox(height: 8),
                Text('${Provider.of<UserProfileProvider>(context).fullName}',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Text(
                  '${Provider.of<UserProfileProvider>(context).email}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerItems(
                label: 'UGBS News Blog',
                icon: Icons.explore,
                onTap: () {
                  Navigator.pushNamed(context, NewsBlogPage.id);
                },
              ),
              DrawerItems(
                label: 'UGBS Announcements',
                icon: Icons.campaign,
                onTap: () {
                  Navigator.pushNamed(context, UGBSAnnouncements.id);
                },
              ),
              DrawerItems(
                label: 'UGBS Information Resources',
                icon: Icons.file_copy,
                onTap: () {
                  Navigator.pushNamed(context, UGBSInformationResources.id);
                },
              ),
              DrawerItems(
                label: 'UGBS Forum',
                icon: Icons.question_answer,
                onTap: () {
                  Navigator.pushNamed(context, UGBSForum.id);
                },
              ),
              DrawerItems(
                label: 'UGBS Chat Corner',
                icon: Icons.chat,
                onTap: () {
                  Navigator.pushNamed(context, StudentsList.id);
                },
              ),
              DrawerItems(
                label: 'Inbox',
                icon: Icons.inbox,
                onTap: () {
                  Navigator.pushNamed(context, InboxPage.id);
                },
              ),
              DrawerItems(
                label: 'Contact School Administrator',
                icon: Icons.send,
                onTap: () {
                  Navigator.pushNamed(context, ContactSchoolAdmin.id);
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'STUDENTS LEARNING CORNER',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              DrawerItems(
                label: 'Students List',
                icon: Icons.supervisor_account,
                onTap: () {
                  Navigator.pushNamed(context, StudentsList.id);
                },
              ),
              DrawerItems(
                label: 'Assignments',
                icon: Icons.menu_book_outlined,
                onTap: () {
                  Navigator.pushNamed(context, AssignmentsPage.id);
                },
              ),
              DrawerItems(
                label: 'Term Paper',
                icon: Icons.pages,
                onTap: () {
                  Navigator.pushNamed(context, TermPapers.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  newsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          child: Text(
            'News Blog',
            style: TextStyle(
              color: kMainColor,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getNewsBlogAll,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                final studys = snapshot.data!.docs;
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: studys.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsBlogDetails(
                                imageUrl: studys[index].data()['imageUrl'],
                                title: studys[index].data()['title'],
                                createdBy: studys[index].data()['createdBy'],
                                description:
                                    studys[index].data()['description'],
                                datePublished: studys[index]
                                    .data()['datePublished']
                                    .toDate(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                studys[index].data()['imageUrl'],
                                fit: BoxFit.cover,
                                height: 180,
                                width: 200,
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 200,
                                child: Text(
                                  studys[index].data()['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: kMainColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: 200,
                                child: Text(
                                  studys[index].data()['description'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                    height: 1.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'By: ${studys[index].data()['createdBy']}',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  assignmentsSection() {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getAssignments,
        builder: (context, snapshots) {
          if (!snapshots.hasData) return LinearProgressIndicator();
          final assignments = snapshots.data!.docs;
          return ListView.builder(
              // scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          color: Color(assignments[index].data()['colors']),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Text(
                                'Pending',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignmentsDetails(
                                    title: assignments[index].data()['title'],
                                    colors: assignments[index].data()['colors'],
                                    details:
                                        assignments[index].data()['details'],
                                    deadline: assignments[index]
                                        .data()['deadline']
                                        .toDate(),
                                    assignmentId: assignments[index].id,
                                    time: assignments[index]
                                        .data()['time']
                                        .toDate(),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${assignments[index].data()['title']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(
                                        assignments[index].data()['colors']),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${assignments[index].data()['details']}',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text(
                                      'Deadline:',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 10,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      dated.format(
                                        DateTime.parse(assignments[index]
                                            .data()['deadline']
                                            .toDate()
                                            .toString()),
                                      ),
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

/*
  newsBlogPromos() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getNewsBlog,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final newsblog = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: newsblog.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.black])
                            .createShader(bounds);
                      },
                      child: Image.network(
                        newsblog[index].data()['imageUrl'],
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 7,
                      child: Container(
                        width: 180,
                        child: Text(
                          newsblog[index].data()['title'],
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.5,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 7,
                      child: Text(
                        'NEWS BLOG',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 7,
                      child: Text(
                        dated.format(
                          DateTime.parse(newsblog[index]
                              .data()['createdAt']
                              .toDate()
                              .toString()
                              .toUpperCase()),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
 */

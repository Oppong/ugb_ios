import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ugbs_dawuro_ios/apppages/view_document.dart';
import '../constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UGBSInformationResources extends StatefulWidget {
  const UGBSInformationResources({Key? key}) : super(key: key);
  static const String id = 'ugbs informaiton resources';

  @override
  _UGBSInformationResourcesState createState() =>
      _UGBSInformationResourcesState();
}

class _UGBSInformationResourcesState extends State<UGBSInformationResources> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getInformationResources;
  final ScrollController _scrollController = ScrollController();
  int docsLimit = 10;
  var dated = DateFormat.yMMMMEEEEd();
  var timed = DateFormat.jm();
  late FirebaseMessaging messaging;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInformationResources = _firestore
        .collection('informationResources')
        .orderBy('createdAt', descending: true)
        .limitToLast(docsLimit)
        .snapshots();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        setState(() {
          docsLimit = docsLimit + 10;
        });
      }

      getInformationResources = _firestore
          .collection('informationResources')
          .orderBy('createdAt', descending: true)
          .limitToLast(docsLimit)
          .snapshots();
    });

    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic('info');

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'INFORMATION RESOURCES',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getInformationResources,
            builder: (context, snapshots) {
              if (!snapshots.hasData) return LinearProgressIndicator();
              final informationRes = snapshots.data!.docs;
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  controller: _scrollController,
                  itemCount: informationRes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  dated.format(
                                    DateTime.parse(informationRes[index]
                                        .data()['createdAt']
                                        .toDate()
                                        .toString()),
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 10),
                                ),
                                Spacer(),
                                Text(
                                  timed.format(
                                    DateTime.parse(informationRes[index]
                                        .data()['createdAt']
                                        .toDate()
                                        .toString()),
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewDocument(
                                                    fileUrl:
                                                        informationRes[index]
                                                            .data()['fileUrl'],
                                                    title: informationRes[index]
                                                        .data()['title'],
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    informationRes[index].data()['title'],
                                    style: TextStyle(
                                        color: kMainColor, fontSize: 11),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

/*
Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      OpenFilex.open(
                                          '${informationRes[index].data()['fileUrl']}');

                                      /*
                                      Share.share(
                                          '${informationRes[index].data()['fileUrl']}',
                                          subject: informationRes[index]
                                              .data()['title']);
                                       */
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
 */

/*
                                       onTap: () async {
                                      final statusOfPermission =
                                          await Permission.storage.request();
                                      final userStorage =
                                          await getExternalStorageDirectory();

                                      if (statusOfPermission.isGranted) {
                                        final taskId =
                                            await FlutterDownloader.enqueue(
                                          url:
                                              '${informationRes[index].data()['fileUrl']}',
                                          savedDir: userStorage!.path,
                                          fileName:
                                              '${informationRes[index].data()['title']}',
                                          showNotification: true,
                                          openFileFromNotification: true,
                                          saveInPublicStorage: true,
                                        );
                                      } else {
                                        'permission was not given to download file';
                                      }
                                    },
                                     */

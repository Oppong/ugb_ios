import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/userprofile_provider.dart';
import 'dart:convert';
import '../../constant.dart';
import 'package:dash_chat/dash_chat.dart';

class OneToOneStudentsChatPage extends StatefulWidget {
  const OneToOneStudentsChatPage(
      {this.userId,
      this.imageUrl,
      this.fullName,
      this.studentId,
      this.roomId,
      this.status,
      this.lastSeen,
      Key? key})
      : super(key: key);
  static const String id = 'one to one students chat page';

  final String? imageUrl, fullName, userId, studentId, roomId, status;
  final DateTime? lastSeen;

  @override
  _OneToOneStudentsChatPageState createState() =>
      _OneToOneStudentsChatPageState();
}

class _OneToOneStudentsChatPageState extends State<OneToOneStudentsChatPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _messageTextController = TextEditingController();
  String? messageText;
  var dated = DateFormat.yMMMd();

  late Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsChat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentsChat = _firestore
        .collection('chatRooms')
        .doc(widget.roomId)
        .collection('chats')
        .orderBy('createdAt')
        .snapshots();
  }

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage> listOfMessages = [];
  var messages;

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of(context);
    userProfileProvider.readUserProfileInfoSingle();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl!),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fullName!,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                  ),
                ),
                widget.status == 'Online'
                    ? Text(
                        widget.status!,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            widget.status!,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'last seen at ${dated.format(DateTime.parse(widget.lastSeen!.toString()))} ${DateFormat.jm().format(widget.lastSeen!)}',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/back.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.02), BlendMode.dstATop),
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getStudentsChat,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              final messages = snapshot.data!.docs;
              listOfMessages =
                  messages.map((e) => ChatMessage.fromJson(e.data())).toList();
              return DashChat(
                dateFormat: DateFormat('dd-MM-yyyy'),
                timeFormat: DateFormat('HH:mm'),
                inputDecoration:
                    InputDecoration.collapsed(hintText: 'Type Message Hear'),
                alwaysShowSend: true,
                shouldShowLoadEarlier: true,
                showUserAvatar: true,
                text: messageText,
                key: _chatViewKey,
                onTextChange: (val) {
                  messageText = val;
                },
                user: ChatUser(
                  uid: _auth.currentUser!.uid,
                  avatar: userProfileProvider.imageUrl,
                  firstName: userProfileProvider.fullName,
                ),
                onSend: (ChatMessage message) {
                  ChatMessage message = ChatMessage(
                      text: messageText,
                      user: ChatUser(
                        uid: _auth.currentUser!.uid,
                        avatar: userProfileProvider.imageUrl,
                        firstName: userProfileProvider.fullName,
                      ),
                      createdAt: DateTime.now(),
                      buttons: [
                        Icon(Icons.share),
                      ]);
                  _firestore
                      .collection('chatRooms')
                      .doc(widget.roomId)
                      .collection('chats')
                      .add(message.toJson());
                },
                messages: listOfMessages,
                messageDecorationBuilder: (ChatMessage message, bool? isUser) {
                  return BoxDecoration(
                    color: isUser == true ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: isUser == true
                          ? Radius.circular(10)
                          : Radius.circular(0),
                      bottomRight: isUser == true
                          ? Radius.circular(0)
                          : Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  );
                },
                // leading: [Icon(Icons.attach_file)],
              );
            }),
      ),
    );
  }
}

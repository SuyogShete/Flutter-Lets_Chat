import 'package:flutter/material.dart';
import 'package:lets_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
String loggedInUser = '';

class ChatScreen extends StatefulWidget {

  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fieldText = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  String messageText = '';

  void clearText() {
    fieldText.clear();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user.email!;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStreams() async {
    await for (var snapshots in _firestore.collection('messages').snapshots()) {
      for (var message in snapshots.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        //leading: null
        actions: <Widget>[
          TextButton(
              //icon: Icon(Icons.close),
              child: Text(
                'LogOut',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.5,
                ),
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //messageStreams();
              }),
        ],
        //title: Text('⚡️Chat'),
        title: Text('💬 Lets Chat'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('messages').orderBy("time", descending: true).snapshots(),
                builder: (context, snapshot) {
                  List<MessageBubble> messageWidgets = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data?.docs;

                  for (var message in messages!) {
                    final messageSender = message.data()?['sender'];
                    final messageText = message.data()?['text'];

                    //final currentUser = loggedInUser.email;

                    final messageWidget = MessageBubble(
                        messageText: messageText,
                        messageSender: messageSender,
                        isUser: messageSender == loggedInUser);
                    messageWidgets.add(messageWidget);
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: fieldText,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      clearText();
                      _firestore.collection('messages').add(
                        {'sender': loggedInUser, 'text': messageText, 'time': DateTime.now()},
                      );

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.messageText,
      required this.messageSender,
      required this.isUser});

  final String messageText;
  final String messageSender;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          messageSender,
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Material(
          borderRadius: BorderRadius.circular(12.0),
          color: isUser ? Colors.black87 : Colors.white,
          elevation: 5.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Text(
              messageText,
              style: TextStyle(
                  color: isUser ? Colors.white : Colors.black, fontSize: 15.0),
              softWrap: true,
            ),
          ),
        ),
        SizedBox(height: 22.5),
      ],
    );
  }
}

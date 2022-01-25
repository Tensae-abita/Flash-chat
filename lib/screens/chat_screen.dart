import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  String message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('messages').snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.docs.reversed;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages) {
                    final String messageText = message['text'];
                    final String Messagesender = message['sender'];

                    final currentUser = loggedInUser.email;

                    final messageBubble = MessageBubble(
                      message: messageText,
                      sender: Messagesender,
                      isMe: currentUser == Messagesender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageBubbles,
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
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      messageTextController.clear();
                      //Implement send functionality.
                      try {
                        await _fireStore.collection('messages').add(
                            {'sender': loggedInUser.email, 'text': message});
                        print('done');
                      } catch (e) {
                        print(e);
                      }
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
  final String message;
  final String sender;
  bool isMe;
  MessageBubble({this.message, this.sender, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.white24),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topRight: isMe ? Radius.circular(0) : Radius.circular(30)),
            elevation: 10,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message,
                style: TextStyle(color: !isMe ? Colors.black54 : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

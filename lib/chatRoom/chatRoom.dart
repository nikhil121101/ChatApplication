import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guftgu/SavedData/CurrentUserDetails.dart';
import 'package:guftgu/SavedData/sharedPrefernces.dart';
import 'package:guftgu/files/chatRoom/search.dart';
import 'package:guftgu/files/loginSignup/UserAuthentication.dart';
import 'package:guftgu/services/databaseMethods.dart';

import '../conversation.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  UserLoggedInData userLoggedInData = UserLoggedInData();

  Stream chatListStream;

  @override
  void initState() {
    databaseMethods.getMyChats(CurrentUserDetails.username).then(
            (val) {
          setState(() {
            chatListStream = val;
          });
        }
    );
    print(CurrentUserDetails.username);
    super.initState();
  }

  showChatList() {

    return StreamBuilder(
      stream: chatListStream,
      builder: (context , snapshot) {
        return !snapshot.hasData
            ? Text('PLease Wait')
            : Column(
              children: <Widget>[
                SizedBox(height: 3),
                ListView.builder(
                    shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context , index) {
                  String username = "";
                  String chatRoomID = snapshot.data.documents[index].data["chatRoomID"];
                  if(!(CurrentUserDetails.username == snapshot.data.documents[index].data["users"][0].toString())) {
                    username = snapshot.data.documents[index].data["users"][0];
                  }
                  else {
                    username = snapshot.data.documents[index].data["users"][1];
                  }
                  return ChatTile(
                    username: username,
                    chatRoomId: chatRoomID,
                  );
                }),
              ],
            );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) => Search()
                ));
              },
              child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: 35,
                    )
              ),
            ),
          GestureDetector(
            onTap: () {
              userLoggedInData.setIsLoggedIn(false).then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => Authentication()
                ) , (val) => false );
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                  size: 30,
                )
              ),
          ),
        ],
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
                'guftgu',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'lecker',
                  fontSize: 28,
                )
            ),
          ),
      ),

      body: showChatList(),

    );}
}

moveToChatRoom(BuildContext context , String chatRoomID) {
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => Conversation(chatRoomID: chatRoomID)
  ));

}

// ignore: must_be_immutable
class ChatTile extends StatelessWidget {

  final String username;
  String chatRoomId;
  ChatTile({this.username , this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        moveToChatRoom(context, chatRoomId);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: Colors.grey[700]
        ),
        padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 22),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue
              ),
              child: Center(
                child: Text(
                  username.substring(0 , 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
              ),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username ,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



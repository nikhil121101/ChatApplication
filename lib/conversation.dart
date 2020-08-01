import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guftgu/SavedData/CurrentUserDetails.dart';
import 'package:guftgu/extras/loadingScreen.dart';
import 'package:guftgu/services/databaseMethods.dart';

// ignore: must_be_immutable
class Conversation extends StatefulWidget {
  String chatRoomID;
  Conversation({this.chatRoomID});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  TextEditingController messageController = TextEditingController();

  Stream allChatMessagesStream;

  DatabaseMethods databaseMethods = DatabaseMethods();

  messageList() {
    return StreamBuilder(
      stream: allChatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ?
        Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                  itemBuilder: (context , index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    isSendByMe: snapshot.data.documents[index].data["sendBy"] == CurrentUserDetails.username ,
                  );
                }
              ),
            ),
            SizedBox(height: 80,)
          ],
        ) : Container();
      }
    );
  }

  addMessages(String chatRoomId) {
    print(chatRoomId);
    if(messageController.text.isNotEmpty) {
      Map<String , dynamic> messageMap = {
        "message" : messageController.text ,
        "sendBy" : CurrentUserDetails.username,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addMessage(chatRoomId , messageMap);
      print('message added !!!!!!!');
    }
  }

  @override
  void initState() {
    databaseMethods.getAllMessages(widget.chatRoomID).then((val) {
      print(val);
      setState(() {
        allChatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(
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
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            messageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Message.. ",
                            hintStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[400]
                            ),
                            border: InputBorder.none
                        ),
                        style: TextStyle(
                            color: Colors.white ,
                            fontSize: 20
                        ),
                        cursorColor: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessages(widget.chatRoomID);
                        messageController.clear();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.yellow[200],
                                  Colors.yellow[300]
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.blue[800],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message , this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.greenAccent : Colors.grey[600],
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ):
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(
          message ,
          style: TextStyle(
            color: isSendByMe ? Colors.black : Colors.white70,
            fontSize: 18
          ),
        ),
      )
    );
  }
}
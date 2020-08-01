import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guftgu/SavedData/CurrentUserDetails.dart';
import 'package:guftgu/files/conversation.dart';
import 'package:guftgu/services/databaseMethods.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  QuerySnapshot searchSnapshot;
  
  initiate() async {
    await databaseMethods.getUserDataFromUsername(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget showList() {
    return searchSnapshot != null ?
    searchSnapshot.documents.length > 0 ? ListView.separated(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (context , index) {
        return searchSnapshot.documents[index].data["username"] != CurrentUserDetails.username ? SearchTile(
          username: searchSnapshot.documents[index].data["username"],
          email: searchSnapshot.documents[index].data["email"],
          createChatRoomAndNavigateToConversation: createChatRoomAndNavigateToConversation,
        ) : Container();
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey[400],
        );
      },
    ) : Container(
        child: Text(
            'no user found',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        )
    ) : Container();
  }

  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController searchController = TextEditingController();

  createChatRoomAndNavigateToConversation(String searchedUsername , BuildContext context) {
    List<String> userPairs = [
      searchedUsername ,
      CurrentUserDetails.username
    ];
    String chatRoomID = createChatRoomID(searchedUsername , CurrentUserDetails.username);
    Map<String , dynamic> pairMap = {
      "chatRoomID" : chatRoomID ,
      "users" : userPairs
    };
    databaseMethods.createChatRoom(chatRoomID, pairMap);
    Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context) => Conversation(chatRoomID: chatRoomID)
    ));
  }

  createChatRoomID(String username1 , String username2) {
    if(username1.compareTo(username2) > 0) {
      return "$username1$username2";
    }
    else {
      return "$username2$username1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[600],
              padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search for users.. ",
                        hintStyle: TextStyle(
                          fontSize: 18,
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
                      initiate();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.grey[400],
                          Colors.grey[500]
                        ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            showList()
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  final Function createChatRoomAndNavigateToConversation;
  SearchTile({this.username , this.email , this.createChatRoomAndNavigateToConversation});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username ,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
                Text(
                  email ,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                createChatRoomAndNavigateToConversation(username , context);
              },
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(
                  child: Text(
                    "Message" ,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


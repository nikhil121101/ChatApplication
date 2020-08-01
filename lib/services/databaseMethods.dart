import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future getUserDataFromUsername(String username) async{
    return await Firestore.instance.collection("users").where(
      "username" , isEqualTo: username
    ).getDocuments();
  }

  Future getUserDataFromEmail(String email) async{
    return await Firestore.instance.collection("users").where(
        "email" , isEqualTo: email
    ).getDocuments();
  }

  uploadUserData(Map userMap) {
    Firestore.instance.collection("users").add(
      userMap
    ).catchError((e) {
      print(e);
    });
  }
  createChatRoom(String chatRoomID , pairMap) {
    Firestore.instance.collection("chatRoom").document(chatRoomID).setData(pairMap);
  }

  addMessage(String chatRoomID , messageMap) {
    Firestore.instance.collection("chatRoom").document(chatRoomID).collection("Messages").add(messageMap);
  }

  getMyChats(String username) async{
    return await Firestore.instance.collection("chatRoom").where(
      "users" , arrayContains: username
    ).snapshots();
  }

  getAllMessages(String chatRoomID) async {
    return await Firestore.instance.collection("chatRoom").document(chatRoomID).
    collection("Messages").orderBy("time" , descending: false).snapshots();
  }
  
}
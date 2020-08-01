import 'package:flutter/material.dart';
import 'package:guftgu/SavedData/sharedPrefernces.dart';
import 'package:guftgu/files/chatRoom/chatRoom.dart';
import 'package:guftgu/files/loginSignup/signUp.dart';
import 'package:guftgu/files/loginSignup/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool isSignedIn;

  UserLoggedInData userLoggedInData = UserLoggedInData();

  bool showSignIn = true;

  void toggleScreen() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("ISLOGGEDIN")) {
      return false;
    }
    else {
      return await userLoggedInData.getIsLoggedIn();
    }
  }

  @override
  void initState() {
    isLoggedIn().then(
        (val) {
          setState(() {
            isSignedIn = val;
          });
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isSignedIn == null) {
      return Container();
    }
    else {
      if (isSignedIn) {
        return ChatRoom();
      }
      else {
        return showSignIn ? SignIn(toggleScreen) : SignUp(toggleScreen);
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'file:///E:/flutter%20projects/guftgu/lib/extras/Widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:guftgu/SavedData/CurrentUserDetails.dart';
import 'package:guftgu/SavedData/sharedPrefernces.dart';
import 'file:///E:/flutter%20projects/guftgu/lib/files/chatRoom/chatRoom.dart';
import 'file:///E:/flutter%20projects/guftgu/lib/extras/loadingScreen.dart';
import 'package:guftgu/services/authorization.dart';
import 'package:guftgu/services/databaseMethods.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Authorization authorizer = new Authorization();
  DatabaseMethods databaseMethods = DatabaseMethods();
  UserLoggedInData userLoggedInData = new UserLoggedInData();
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUpProcess() {
    if(formKey.currentState.validate()) {
      String username = usernameController.text;
      String email = emailController.text;
      Map<String , String> userMap = {
        "username" : username,
        "email" : email
      };
      setState(() {
        loading = true;
      });
      authorizer.signUpWithEmailAndPassword(emailController.text,
          passwordController.text).then((value) {
            print(value);
            userLoggedInData.setIsLoggedIn(true);
            userLoggedInData.setUsername(username);
            userLoggedInData.setEmail(email);
            databaseMethods.uploadUserData(userMap);
            CurrentUserDetails.username = username;
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => ChatRoom()
            ));
      });
    }
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
        body : Center(
        child: loading ? Loading() : Container(
          padding: EdgeInsets.symmetric(horizontal: 45),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/Chat-512.png",
                  width: 300,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "This can't be empty" : null;
                        },
                        controller: usernameController,
                        style: simpleTextStyle(),
                        cursorColor: Colors.blue,
                        decoration: decorateTxt('username' , Icon(Icons.account_circle , color: Colors.greenAccent) , true),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) {
                          return EmailValidator.validate(val) ? null : "Please provide a valid email";
                        },
                        controller: emailController,
                        style: simpleTextStyle(),
                        cursorColor: Colors.blue,
                        decoration: decorateTxt('email' , Icon(Icons.mail , color: Colors.greenAccent) , true),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        validator: isValidPassword,
                        controller: passwordController,
                        style: simpleTextStyle(),
                        cursorColor: Colors.blueAccent,
                        decoration: decorateTxt('password' , Icon(Icons.lock , color: Colors.greenAccent) , true),
                      ),
                      SizedBox(height: 20)
                    ],
                  )
                ),
                GestureDetector(
                  onTap: () {
                    signUpProcess();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text(
                    'Sign In with google',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.brown[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        " Already registered? ",
                        style: mediumTextStyle()
                    ),
                    GestureDetector(
                      onTap: () => widget.toggle(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                            " Sign In now ",
                            style: hardTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70)
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
  String isValidPassword(String val) {
    bool specialChar = false;
    bool number = false;
    bool size = false;
    if(val.length >= 8) {
      size = true;
    }
    for(int i  = 0 ; i < val.length ; i++) {
      if(isNumber(val.codeUnitAt(i))) {
        number = true;
      }
      else if(isAlphabet(val.codeUnitAt(i))){

      }
      else {
        specialChar = true;
      }
    }
    return specialChar && size && number ? null :
      !size ? " password must have atlest 8 letters "
      : " password must contain a number & a special char ";
  }
  bool isAlphabet(int c) {
    return c > 64 && c < 90 || c > 96 && c < 123;
  }
  bool isNumber(int c) {
    return c > 47  && c < 58;
  }
  TextStyle simpleTextStyle() {
    return TextStyle(
        fontSize: 18,
        color: Colors.white
    );
  }
  TextStyle mediumTextStyle() {
    return TextStyle(
        color: Colors.blue[200] ,
        fontSize: 18
    );
  }
  TextStyle hardTextStyle() {
    return TextStyle(
        color: Colors.blue[200] ,
        fontSize: 18,
        decoration: TextDecoration.underline
    );
  }
}

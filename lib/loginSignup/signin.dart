import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:guftgu/SavedData/CurrentUserDetails.dart';
import 'package:guftgu/SavedData/sharedPrefernces.dart';
import 'file:///E:/flutter%20projects/guftgu/lib/extras/Widgets.dart';
import 'file:///E:/flutter%20projects/guftgu/lib/extras/loadingScreen.dart';
import 'package:guftgu/services/authorization.dart';
import 'package:guftgu/services/databaseMethods.dart';
import 'package:guftgu/services/user.dart';
import '../chatRoom/chatRoom.dart';

    class SignIn extends StatefulWidget {
      final Function toggle;
      SignIn(this.toggle);
      @override
      _SignInState createState() => _SignInState();
    }

    class _SignInState extends State<SignIn> {
      final formKey = GlobalKey<FormState>();
      TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();
      UserLoggedInData userLoggedInData = UserLoggedInData();
      DatabaseMethods databaseMethods = DatabaseMethods();
      Authorization authorizer = new Authorization();
      bool loading = false;
      bool toValidate = false;
      User user;
      bool passwordMatched = true;
      bool showPassword = false;
      QuerySnapshot loggedInUserDataSnapshot;

      signInProcess() async {
        if (formKey.currentState.validate()) {
          String email = emailController.text;
          setState(() {
            loading = true;
          });
          authorizer.signInWithEmailAndPassword(emailController.text,
              passwordController.text).then((val) async {
                print("$val val is printted !!!!!!!!");
            if (val == null) {
              print('wrong pass');
              reset();
            }
            else {
              userLoggedInData.setEmail(email);
              userLoggedInData.setIsLoggedIn(true);
              databaseMethods.getUserDataFromEmail(email).then((value) {
                print(value);
                loggedInUserDataSnapshot = value;
                userLoggedInData.setUsername(
                    loggedInUserDataSnapshot.documents[0].data["username"]).then((val) {
                  CurrentUserDetails.username = loggedInUserDataSnapshot.documents[0].data["username"];
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => ChatRoom()));
                });
              });
            }
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
        body : loading ? Loading() : Container(
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                          "assets/images/Chat-512.png",
                        width: 0.75 * MediaQuery.of(context).size.width,
                      ),
                      Form(
                        autovalidate: toValidate,
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) {
                                if(!EmailValidator.validate(val)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              controller: emailController,
                              style: simpleTextStyle(),
                              cursorColor: Colors.blue,
                              decoration: decorateTxt('email' , Icon(Icons.account_circle , color: Colors.greenAccent,) , true),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (val) {
                                if(val.isEmpty) {
                                  passwordController.clear();
                                  return "You've entered a wrong password";
                                }
                                return null;
                              },
                              obscureText: showPassword ? false : true,
                              controller: passwordController,
                              style: simpleTextStyle(),
                              cursorColor: Colors.blueAccent,
                              decoration: InputDecoration(
                                errorText: !passwordMatched ? 'password not matched' : null,
                                prefixIcon: Icon(Icons.lock , color: Colors.greenAccent),
                                suffixIcon: eyeButton(),
                                labelText: 'password',
                                labelStyle: textFieldStyle(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.greenAccent,
                                        width: 2
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent,
                                        width: 2
                                    )
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          authorizer.forgotPassword(emailController.text);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                                style: mediumTextStyle()
                          )
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          signInProcess();
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
                            'Sign In',
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
                          Expanded(
                            child: Text(
                                " Don't have an account? ",
                              style: mediumTextStyle()
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: GestureDetector(
                                onTap: () => widget.toggle(),
                                child: Text(
                                    " Register Now ",
                                    style: hardTextStyle(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),  // This trailing comma makes auto-formatting nicer for build methods.
        );
      }

      void reset() {
        setState(() {
          loading = false;
        });
        setState(() {
          passwordMatched = false;
          passwordController.clear();
        });

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

      IconButton eyeButton() {
        return IconButton(
          icon: Icon(Icons.remove_red_eye , color: Colors.greenAccent),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        );
      }

    }

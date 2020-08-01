import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftgu/services/user.dart';
class Authorization {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User returnsUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? User(userID: firebaseUser.uid) : null;
  }

  Future<User> signInWithEmailAndPassword(String email , String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return returnsUser(firebaseUser);
    }
    catch(e) {
      print(e);
    }
  }

  Future<User> signUpWithEmailAndPassword(String email , String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return returnsUser(firebaseUser);
    }
    catch(e) {
      print(e);
    }
  }

  Future forgotPassword(String email) {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(e) {
      print(e);
    }
  }

  Future signOut() {
    try{
      return _auth.signOut();
    }
    catch(e) {
      print(e);
    }
  }

}
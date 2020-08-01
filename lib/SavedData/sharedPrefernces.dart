import 'package:shared_preferences/shared_preferences.dart';

class UserLoggedInData {

  static String isLoggedSharedPreferencesKey = "ISLOGGEDIN";
  static String usernameSharedPreferencesKey = "USERNAME";
  static String emailSharedPreferencesKey = "EMAIL";


  Future<bool> setIsLoggedIn(bool isLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isLoggedSharedPreferencesKey , isLoggedIn);
  }

  Future<bool> setUsername(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usernameSharedPreferencesKey , username);
  }

  Future<bool> setEmail(String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(emailSharedPreferencesKey , email);
  }

  Future<bool> getIsLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedSharedPreferencesKey);
  }

  Future<String> getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameSharedPreferencesKey);
  }

  Future<String> getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailSharedPreferencesKey);
  }

}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_rekord_app/models/User.dart';
import 'package:flutter_rekord_app/providers/BaseProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends BaseProvider {
  //Constructor
  AuthProvider() {
    autoAuthenticate();
  }

  // Items List

  bool isLoaded = true;
  bool _isLoggedIn = false;
  bool inputerror = false;
  String errorMsg;
  bool check = true;

  bool get isLoggedIn => _isLoggedIn;

  User _user;
  User get user => _user;

  /*
  * Sign in Wiht Email
  * Add your http code here and save user profile.
  */
  Future<Response> singInWithEmail(Map<String, String> formData) async {
    check = false;
    isLoaded = false;
    notifyListeners();

    Response response = await post(formData);
    check = true;
    isLoaded = true;
    notifyListeners();
    return response;
  }

  _saveToken(response) async {
    final _prefs = await SharedPreferences.getInstance();
    if (response.containsKey('jwt')) {
      _prefs.setString('token', response['jwt']);
    }
  }

  setUser(response) async {
    isLoaded = false;
    notifyListeners();
    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied) {
      await Permission.storage.request();
    }
    final _prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(response);
    var temp = json.encode(_user.toJson());
    await _prefs.setString('user', temp);
    isLoaded = true;
    notifyListeners();
  }

/*
 * Auth Authenticate
 *
 * Auto authentication help to get user data from shared preferences
 * and save as user user object. which can be access anywhere
 * in the app.
 *
 * please check page-user-account.dart for example
 *
 */

  Future autoAuthenticate() async {
    isLoaded = false;
    notifyListeners();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String prefUser = _prefs.getString('user');
    if (prefUser != null) {
      Map userMap = jsonDecode(prefUser);
      _user = User(id: userMap['id'], email: userMap['email'], firstName: userMap['firstName'], lastName: userMap['lastName']);
    }

    if (_user != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    isLoaded = true;
    notifyListeners();
  }

  /*
  * Logout
  *
  * Clear user preference & user
  */
  void logout() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _user = null;
    _prefs.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  /*
  * Sign Up With Email
  * Add your http code here and save user profile.
  */
  Future<String> singUpWithEmail(Map<String, dynamic> formData) async {
    isLoaded = false;
    notifyListeners();
    String error;

    final response = await post(formData);
    final Map<String, dynamic> jsonMap = json.decode(response.body);

    isLoaded = true;
    notifyListeners();
    return jsonMap['code'].toString();
  }
}

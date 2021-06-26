import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_rekord_app/models/User.dart';
import 'package:flutter_rekord_app/providers/BaseProvider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

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
  Map<int, bool> boughtAlbumsIds = Map();

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
    await fetchBoughtAlbums(_user.email);
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

  fetchBoughtAlbums(String email) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'));
    http.Response response = await http.get(
      "http://ec2-15-237-94-117.eu-west-3.compute.amazonaws.com/senetunesproduction/api/order_supplier?filter[userEmail]=$email&display=full",
      headers: <String, String>{
        'authorization': basicAuth,
        'content-type': "text/xml;charset=utf-8"
      },
    );

    var doc = XmlDocument.parse(response.body).findAllElements("albums");
    for (var album in doc) {
      String albumId = album
          .getElement("songs")
          .getElement('song')
          .getElement("albumInfo")
          .getElement("albumId")
          .text;
      print(albumId);
      boughtAlbumsIds.putIfAbsent(int.parse(albumId), () => true);
    }
  }

  Future autoAuthenticate() async {
    isLoaded = false;
    notifyListeners();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    String prefUser = _prefs.getString('user');
    if (prefUser != null) {
      Map userMap = jsonDecode(prefUser);
      _user = User(
          id: userMap['id'],
          email: userMap['email'],
          firstName: userMap['firstName'],
          lastName: userMap['lastName']);
      await fetchBoughtAlbums(userMap['email']);
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

    // final response = await post(formData);

    http.Response response;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'));

    String xml = """<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
<customer>
	<passwd><![CDATA[${formData['passwd']}]]></passwd>
	<lastname><![CDATA[${formData['lastname']}]]></lastname>
	<firstname><![CDATA[${formData['firstname']}]]></firstname>
	<email><![CDATA[${formData['email']}]]></email>
	<active>1</active>
</customer>
</prestashop>""";
    response = await http.post(
      "http://ec2-15-237-94-117.eu-west-3.compute.amazonaws.com/senetunesproduction/api/customers?schema=blank",
      headers: <String, String>{
        'authorization': basicAuth,
        'content-type': "text/xml;charset=utf-8"
      },
      body: xml,
    );

    isLoaded = true;
    notifyListeners();
    if (response.statusCode == 201)
      return null;
    else {
      print(response.body);
      return response.body;
    }

    // return jsonMap['code'].toString();
  }
}

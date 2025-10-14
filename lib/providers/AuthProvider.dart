import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

import 'package:senetunes/models/User.dart';
import 'package:senetunes/providers/BaseProvider.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends BaseProvider {
  AuthProvider() {
    autoAuthenticate();
  }

  bool isLoaded = true;
  bool _isLoggedIn = false;
  bool inputerror = false;
  String? errorMsg;
  bool check = true;

  bool get isLoggedIn => _isLoggedIn;

  User? _user;
  User? get user => _user;

  /// Albums achetés: albumId -> true
  final Map<int, bool> boughtAlbumsIds = <int, bool>{};

  /// Connexion (via BaseProvider.post)
  Future<Response<dynamic>> singInWithEmail(Map<String, String> formData) async {
    check = false;
    isLoaded = false;
    notifyListeners();

    final response = await post(formData);

    check = true;
    isLoaded = true;
    notifyListeners();
    return response;
  }

  Future<void> setUser(User user) async {
    isLoaded = false;
    notifyListeners();

    // Permission stockage (utile si tu écris des fichiers téléchargés)
    final status = await Permission.storage.status;
    if (status.isPermanentlyDenied || status.isDenied) {
      await Permission.storage.request();
    }

    final prefs = await SharedPreferences.getInstance();
    _user = user;
    await prefs.setString('user', json.encode(_user!.toJson()));

    await fetchBoughtAlbums(_user!.email);

    _isLoggedIn = true;
    isLoaded = true;
    notifyListeners();
  }

  /// Récupère les albums achetés pour un email
  Future<void> fetchBoughtAlbums(String email) async {
    isLoaded = false;
    notifyListeners();

    final basicAuth = 'Basic ${base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'))}';

    final response = await http.get(
      Uri.parse(
        'http://ec2-35-180-207-66.eu-west-3.compute.amazonaws.com/senetunesproduction/api/order_supplier?filter[userEmail]=$email&display=full',
      ),
      headers: <String, String>{
        'authorization': basicAuth,
        'content-type': 'text/xml;charset=utf-8',
      },
    );

    // Sécuriser le parsing XML (éviter les NPE si structure inattendue)
    boughtAlbumsIds.clear();
    try {
      final doc = XmlDocument.parse(response.body);
      // On parcourt tous les <albums> potentiels
      for (final albumsNode in doc.findAllElements('albums')) {
        // songs -> song -> albumInfo -> albumId
        final songsNode = albumsNode.getElement('songs');
        final songNode = songsNode?.getElement('song');
        final albumInfoNode = songNode?.getElement('albumInfo');
        final albumIdText = albumInfoNode?.getElement('albumId')?.innerText;

        if (albumIdText != null) {
          final id = int.tryParse(albumIdText);
          if (id != null) {
            boughtAlbumsIds.putIfAbsent(id, () => true);
          }
        }
      }
    } catch (e) {
      // Optionnel: log/debug
      // debugPrint('XML parse error: $e');
    }

    isLoaded = true;
    notifyListeners();
  }

  /// Auto-auth depuis SharedPreferences
  Future<void> autoAuthenticate() async {
    isLoaded = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final prefUser = prefs.getString('user');

    if (prefUser == null || prefUser.isEmpty) {
      _user = null;
      _isLoggedIn = false;
      isLoaded = true;
      notifyListeners();
      return;
    }

    try {
      final Map<String, dynamic> userMap = jsonDecode(prefUser) as Map<String, dynamic>;
      _user = User(
        id: userMap['id'] is int ? userMap['id'] as int : int.tryParse('${userMap['id']}') ?? 0,
        email: '${userMap['email']}',
        firstName: '${userMap['firstName']}',
        lastName: '${userMap['lastName']}',
      );

      await fetchBoughtAlbums(_user!.email);
      _isLoggedIn = true;
    } catch (_) {
      _user = null;
      _isLoggedIn = false;
    }

    isLoaded = true;
    notifyListeners();
  }

  /// Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _user = null;
    await prefs.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Inscription
  Future<String?> singUpWithEmail(Map<String, dynamic> formData) async {
    isLoaded = false;
    notifyListeners();

    final basicAuth = 'Basic ${base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'))}';

    final xml = '''<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
  <customer>
    <passwd><![CDATA[${formData['passwd']}]]></passwd>
    <lastname><![CDATA[${formData['lastname']}]]></lastname>
    <firstname><![CDATA[${formData['firstname']}]]></firstname>
    <email><![CDATA[${formData['email']}]]></email>
    <active>1</active>
  </customer>
</prestashop>''';

    final response = await http.post(
      Uri.parse(
        'http://ec2-35-180-207-66.eu-west-3.compute.amazonaws.com/senetunesproduction/api/customers?schema=blank',
      ),
      headers: <String, String>{
        'authorization': basicAuth,
        'content-type': 'text/xml;charset=utf-8',
      },
      body: xml,
    );

    isLoaded = true;
    notifyListeners();

    if (response.statusCode == 201) {
      try {
        final prestashop = XmlDocument.parse(response.body).getElement('prestashop');
        final customer = prestashop?.getElement('customer');
        final id = customer?.getElement('id')?.innerText;
        final email = customer?.getElement('email')?.innerText;
        final firstName = customer?.getElement('firstname')?.innerText;
        final lastName = customer?.getElement('lastname')?.innerText;

        if (id != null && email != null && firstName != null && lastName != null) {
          await setUser(
            User(
              id: int.tryParse(id) ?? 0,
              email: email,
              firstName: firstName,
              lastName: lastName,
            ),
          );
          return null; // succès
        }
      } catch (e) {
        // parsing error -> renvoyer le body pour debug
      }
      return response.body;
    } else {
      // échec
      return response.body;
    }
  }
}

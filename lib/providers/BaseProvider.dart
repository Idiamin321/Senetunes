import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider extends ChangeNotifier {
  bool isServerDown = false;

  String token;
  bool isLoaded = false;
  bool isLoadingMoreInProgress = false;

  int _total = 0;
  int get total => _total;

  String url;

  getToken() async {
    final _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString('token');
  }

  Future post(Map<String, String> formData) async {
    Response response;
    try {
      response = await Dio().post("${AppConfig.API}/account/login",
          data: formData, options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      response = e.response;
    }
    return response;
  }
}

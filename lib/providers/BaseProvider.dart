import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:senetunes/config/AppConfig.dart';

class BaseProvider extends ChangeNotifier {
  bool isServerDown = false;

  String? token;
  bool isLoaded = false;
  bool isLoadingMoreInProgress = false;

  int _total = 0;
  int get total => _total;

  String? url;

  Future<Response<dynamic>> post(Map<String, String> formData) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        "${AppConfig.API}/account/login",
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response;
    } on DioException catch (e) {
      // Retourne quand même la response si dispo (4xx/5xx)
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: 'DioException: ${e.message}',
          );
    }
  }
}

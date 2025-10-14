import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:senetunes/config/AppConfig.dart';
import 'package:senetunes/models/Category.dart';
import 'package:xml2json/xml2json.dart';

import '../models/Album.dart';
import '../models/Artist.dart';

class CategoryProvider extends ChangeNotifier {
  bool isLoaded = false;
  static bool _updated = false;
  List<Category> _categories;
  List<Category> get categories => _categories;
  CategoryProvider() {
    fetchCategories();
  }

  void fetchCategories() async {
    isLoaded = false;
    _categories = [];
    http.Response response =
        await http.get(Uri.parse("${AppConfig.API}/category/list"));
    if (response.statusCode == 200) {
      var transformer = Xml2Json();
      transformer.parse(response.body);
      List<dynamic> body =
          jsonDecode(transformer.toBadgerfish())['categories']['category'];
      for (dynamic i in body) {
        _categories.add(Category.fromJson(i));
      }
      for (var i = 0; i < _categories.length; i++) {
        http.Response r = await http.get(Uri.parse(_categories[i].uriAlbums));
        if (r.statusCode == 200) {
          transformer = Xml2Json();
          transformer.parse(r.body);
          var b =
              jsonDecode(transformer.toBadgerfish())['infoAlbums']['infoAlbum'];
          if (!(b is List<dynamic>)) b = [b];
          _categories[i].albumIds = b
              .map((e) => e['@albumId'] is String
                  ? int.parse(e['@albumId'])
                  : e['@albumId'])
              .toList();
          _categories[i].artistIds = b
              .map((e) => e['@artistId'] is String
                  ? int.parse(e['@artistId'])
                  : e['@artistId'])
              .toList();
        }
      }
    }
    isLoaded = true;
  }

  void updateWithAlbumsAndArtists(List<Album> albums, List<Artist> artists) {
    if (!_updated) {
      for (var i = 0; i < _categories.length; i++) {
        _categories[i].artist = artists
            .where((element) => _categories[i].artistIds.contains(element.id))
            .toList();
        _categories[i].albums = albums
            .where((element) => _categories[i].albumIds.contains(element.id))
            .toList();
      }
      _updated = true;
    }
  }

  String getCategoryCover(Category category) {
    return category.albums
        .firstWhere((element) => element.media.cover != null)
        .media
        .cover;
  }

  String getCategoryMedium(Category category) {
    return category.albums
        .firstWhere((element) => element.media.medium != null)
        .media
        .medium;
  }

  String getCategoryThumbnail(Category category) {
    return category.albums
        .firstWhere((element) => element.media.thumbnail != null)
        .media
        .thumbnail;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/Search/SearchBox.dart';
import '../config/AppConfig.dart';

class AlbumProvider extends ChangeNotifier {
  AlbumProvider() {
    toSearch = false;
    selectedIndex = 0;
    fetchAlbums();
  }

  static bool _updated = false;

  final List<Album> _allAlbums = <Album>[];
  List<Album> get allAlbums => _allAlbums;

  final List<Track> _allTracks = <Track>[];
  List<Track> get allTracks => _allTracks;

  final Set<Album> _boughtAlbums = <Album>{};
  Set<Album> get boughtAlbums => _boughtAlbums;

  bool isLoaded = true;
  int selectedIndex = 0;
  bool toSearch = false;
  Widget? searchWidget;
  String searchKeyword = "";
  List<Track> searchedTracks = [];

  void gotoSearch(bool val) {
    toSearch = val;
    if (toSearch) {
      searchWidget = SearchBox(
        onSearch: (s) {
          searchKeyword = s;
          searchedTracks = searchData(s);
        },
      );
    } else {
      searchWidget = null;
      searchKeyword = "";
      searchedTracks = [];
    }
    notifyListeners();
  }

  void changeNav(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  Future<void> fetchAlbums() async {
    isLoaded = false;
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'));

    final albumResponse =
    await http.get(Uri.parse('${AppConfig.API}/album/list'));

    final priceResponse = await http.get(
      Uri.parse(
          "http://ec2-35-180-207-66.eu-west-3.compute.amazonaws.com/senetunesproduction/api/products?display=[id,price]&output_format=JSON"),
      headers: <String, String>{'authorization': basicAuth},
    );

    if (albumResponse.statusCode == 200 && priceResponse.statusCode == 200) {
      final transformer = Xml2Json();
      transformer.parse(albumResponse.body);
      final List<dynamic> b =
      jsonDecode(transformer.toBadgerfish())['albums']['album'];

      final Map<int, double> prices = {};
      for (final element in (jsonDecode(priceResponse.body)['products'] as List<dynamic>)) {
        prices[element['id'] as int] = double.tryParse("${element['price']}") ?? 0.0;
      }

      for (final dynamic a in b) {
        final Album album = Album.fromJson(a as Map<String, dynamic>);
        for (final track in album.tracks) {
          track.albumInfo = album;
        }
        album.price = prices[album.id] ?? 0.0;
        _allAlbums.add(album);
        _allTracks.addAll(album.tracks);
      }
    } else {
      debugPrint(albumResponse.body);
      debugPrint(priceResponse.body);
    }

    isLoaded = true;
    notifyListeners();
  }

  List<Track> searchData(String trackName) {
    final q = trackName.toLowerCase();
    return _allTracks
        .where((t) => t.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  List<Album> searchAlbums(String albumName) {
    final q = albumName.toLowerCase();
    final res = _allAlbums.where((a) => a.name.toLowerCase().contains(q)).toList();
    for (final a in res) {
      debugPrint(a.name);
    }
    return res;
  }

  Future<void> updateTracksAndAlbumsWithArtists(List<Artist> artists) async {
    if (!_updated) {
      for (var i = 0; i < _allTracks.length; i++) {
        final idx = artists.indexWhere((e) => e.id == _allTracks[i].artistId);
        if (idx != -1) _allTracks[i].artistInfo = artists[idx];
      }
      for (var i = 0; i < _allAlbums.length; i++) {
        final idx = artists.indexWhere((e) => e.id == _allAlbums[i].artistId);
        if (idx != -1) _allAlbums[i].artistInfo = artists[idx];
      }
      _updated = true;
    }
  }

  Future<void> updateBoughtAlbums(Map<int, bool> boughtAlbums) async {
    isLoaded = false;
    notifyListeners();

    for (var i = 0; i < _allAlbums.length; i++) {
      if (boughtAlbums.containsKey(_allAlbums[i].id)) {
        _allAlbums[i].isBought = true;
        _boughtAlbums.add(_allAlbums[i]);
      } else {
        _allAlbums[i].isBought = false;
      }
    }

    isLoaded = true;
    notifyListeners();
  }
}

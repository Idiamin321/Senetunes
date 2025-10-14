import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:senetunes/config/AppConfig.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:xml2json/xml2json.dart';

class ArtistProvider extends ChangeNotifier {
  ArtistProvider() {
    fetchArtists();
  }
  Map<String, String> params = {};

  static bool _updated = false;

  List<Artist> _allArtists = <Artist>[];
  List<Artist> get allArtists => _allArtists;
  bool isLoaded = true;
  fetchArtists() async {
    isLoaded = false;
    notifyListeners();

    http.Response response =
        await http.get(Uri.parse("${AppConfig.API}/artist/list"));
    if (response.statusCode == 200) {
      var transformer = Xml2Json();
      transformer.parse(response.body);
      List<dynamic> b =
          jsonDecode(transformer.toBadgerfish())['artists']['artist'];
      for (dynamic artist in b) {
        _allArtists.add(Artist.fromJson(artist as Map<String, dynamic>));
      }
    }
    isLoaded = true;
    notifyListeners();
  }

  updateArtistsWithAlbums(List<Album> albums) {
    if (!_updated) {
      for (var i = 0; i < _allArtists.length; i++) {
        Iterable<Album> albumsMatch =
            albums.where((element) => element.artistId == _allArtists[i].id);
        _allArtists[i].albums = [];
        _allArtists[i].tracks = [];
        _allArtists[i].albums.addAll(albumsMatch);
        _allArtists[i].tracks.addAll(albumsMatch
            .map((e) => e.tracks)
            .expand((element) => element)
            .toList());
            }
      _updated = true;
    }
  }
}

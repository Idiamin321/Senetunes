import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Artist.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../config/AppConfig.dart';

class AlbumProvider extends ChangeNotifier {
  AlbumProvider() {
    fetchAlbums();
  }

  static bool _updated = false;

  List<Album> _allAlbums = <Album>[];
  List<Album> get allAlbums => _allAlbums;
  bool isLoaded = true;

  fetchAlbums() async {
    isLoaded = false;
    notifyListeners();
    http.Response response = await http.get('${AppConfig.API}/album/list');
    if (response.statusCode == 200) {
      var transformer = Xml2Json();
      transformer.parse(response.body);
      List<dynamic> b = jsonDecode(transformer.toBadgerfish())['albums']['album'];
      for (dynamic a in b) {
        Album album = Album.fromJson(a as Map<String, dynamic>);
        for (Track track in album.tracks) {
          track.albumInfo = album;
        }
        _allAlbums.add(album);
        _allTracks.addAll(album.tracks);
      }
    }
    isLoaded = true;
    notifyListeners();
  }

  List<Track> _allTracks = <Track>[];
  List<Track> get allTracks => _allTracks;

  List<Track> searchData(String trackName) {
    List<Track> searchedTracks = [];
    for (Track track in _allTracks) {
      if (track.name.toLowerCase().contains(trackName.toLowerCase())) searchedTracks.add(track);
    }
    return searchedTracks;
  }

  updateTracksAndAlbumsWithArtists(List<Artist> artists) async {
    if (!_updated) {
      for (var i = 0; i < _allTracks.length; i++) {
        _allTracks[i].artistInfo = artists[artists.indexWhere((element) => element.id == _allTracks[i].artistId)];
      }
      for (var i = 0; i < _allAlbums.length; i++) {
        _allAlbums[i].artistInfo = artists[artists.indexWhere((element) => element.id == _allAlbums[i].artistId)];
      }
      _updated = true;
    }
  }
}

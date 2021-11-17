import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/Search/SearchBox.dart';
import 'package:xml2json/xml2json.dart';

import '../config/AppConfig.dart';

class AlbumProvider extends ChangeNotifier {
  AlbumProvider() {
    toSearch = false;
    selectedIndex = 0;
    fetchAlbums();
  }

  static bool _updated = false;

  List<Album> _allAlbums = <Album>[];
  List<Album> get allAlbums => _allAlbums;
  List<Track> _allTracks = <Track>[];
  List<Track> get allTracks => _allTracks;
  Set<Album> _boughtAlbums = Set();
  Set<Album> get boughtAlbums => _boughtAlbums;
  bool isLoaded = true;

  int selectedIndex = 0;
  bool toSearch = false;
  Widget searchWidget;
  String searchKeyword = "";
  List<Track> searchedTracks = [];

  gotoSearch(val) {
    toSearch = val;
    if (toSearch) {
      searchWidget = SearchBox(
        onSearch: (s) {
          // setState(() {
          searchKeyword = s;
          // });
          // if (s.length > 0) {
          searchedTracks = searchData(s);
          // }
        },
      );
    }
    notifyListeners();
  }

  changeNav(val) {
    selectedIndex = val;
    notifyListeners();
  }

  fetchAlbums() async {
    isLoaded = false;
    // notifyListeners();
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'));
    http.Response albumResponse = await http.get('${AppConfig.API}/album/list');
    http.Response priceResponse = await http.get(
        "http://ec2-35-180-207-66.eu-west-3.compute.amazonaws.com/senetunesproduction/api/products?display=[id,price]&output_format=JSON",
        headers: <String, String>{'authorization': basicAuth});
    if (albumResponse.statusCode == 200 && priceResponse.statusCode == 200) {
      var transformer = Xml2Json();

      transformer.parse(albumResponse.body);

      List<dynamic> b =
          jsonDecode(transformer.toBadgerfish())['albums']['album'];
      Map<int, double> prices = Map();
      (jsonDecode(priceResponse.body)['products'] as List<dynamic>)
          .forEach((element) {
        prices[element['id']] = double.parse(element['price']);
      });
      for (dynamic a in b) {
        Album album = Album.fromJson(a as Map<String, dynamic>);
        for (Track track in album.tracks) {
          track.albumInfo = album;
        }
        album.price = prices[album.id];
        _allAlbums.add(album);
        _allTracks.addAll(album.tracks);
      }
    } else {
      print(albumResponse.body);
      print(priceResponse.body);
    }
    isLoaded = true;
    notifyListeners();
  }

  List<Track> searchData(String trackName) {
    List<Track> searchedTracks = [];
    for (Track track in _allTracks) {
      if (track.name.toLowerCase().contains(trackName.toLowerCase()))
        searchedTracks.add(track);
    }
    return searchedTracks;
  }

  List<Album> searchAlbums(String albumName) {
    List<Album> searchedAlbums = [];
    for (Album album in _allAlbums) {
      //print(album.name);
      if (album.name.toLowerCase().contains(albumName.toLowerCase()))
        {
          searchedAlbums.add(album);
          print(album.name);
        }

    }
    return searchedAlbums;
  }

  updateTracksAndAlbumsWithArtists(List<Artist> artists) async {
    if (!_updated) {
      for (var i = 0; i < _allTracks.length; i++) {
        _allTracks[i].artistInfo = artists[artists
            .indexWhere((element) => element.id == _allTracks[i].artistId)];
      }
      for (var i = 0; i < _allAlbums.length; i++) {
        _allAlbums[i].artistInfo = artists[artists
            .indexWhere((element) => element.id == _allAlbums[i].artistId)];
      }
      _updated = true;
    }
  }

  updateBoughtAlbums(Map<int, bool> boughtAlbums) async {
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

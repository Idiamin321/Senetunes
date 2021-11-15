import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'BaseProvider.dart';

class PlaylistProvider extends BaseProvider {
  SharedPreferences prefs;
  List<String> playlistsNames = [];
  Map<String, List<String>> playlists = Map();

  Future<Tuple2<List<String>, Map<String, List<String>>>> getPlaylists() async {
    prefs = await SharedPreferences.getInstance();
    playlistsNames = prefs.getStringList('playlistsNames') ?? [];
    for (String playlistName in playlistsNames) {
      playlists[playlistName] = prefs.getStringList(playlistName);
    }
    notifyListeners();
    return Tuple2(playlistsNames, playlists);
  }

  deleteAllPlaylists() async {
    playlistsNames = [];
    playlists = Map();
    update(playlistsNames, playlists);
  }

  createPlaylist(String playlistName) async {
    Tuple2 result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;
    playlistsNames.add(playlistName);
    playlists[playlistName] = [];
    update(playlistsNames, playlists);
    notifyListeners();
  }

  addSong(String playlistName, Track track) async {
    Tuple2 result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;
    List<String> temp = playlists[playlistName] ?? [];
    temp.add(track.name??"");
    playlists[playlistName] = temp;
    update(playlistsNames, playlists);
    notifyListeners();
  }

  deleteSong(String playlistName, Track track) async {
    Tuple2 result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;
    List<String> temp = playlists[playlistName];
    temp.remove(track.name);
    playlists[playlistName] = temp;
    update(playlistsNames, playlists);
    notifyListeners();
  }

  deletePlaylist(String playlistName) async {
    Tuple2 result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;
    print(playlistsNames);
    print(playlists);
    playlistsNames.remove(playlistName);
    playlists.remove(playlistName);
    update(playlistsNames, playlists);
    notifyListeners();
  }

  update(var playlistsNames, var playlists) {
    prefs.setStringList('playlistsNames', playlistsNames);
    for (String playlistName in playlists.keys) {
      prefs.setStringList(playlistName, playlists[playlistName]);
    }
    notifyListeners();
  }

  Album findAlbum(Track track, BuildContext context) {
    List<Album> albums = context.read<AlbumProvider>().allAlbums;
    for (Album album in albums) {
      if (album.tracks.contains(track)) {
        return album;
      }
    }
    return null;
  }

  Track findTrack(String trackName, BuildContext context) {
    List<Album> albums = context.read<AlbumProvider>().allAlbums;
    for (Album album in albums) {
      for (Track track in album.tracks) {
        if (track.name == trackName) {
          return track;
        }
      }
    }
    return Track();
  }
}

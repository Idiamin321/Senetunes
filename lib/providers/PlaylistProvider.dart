import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'BaseProvider.dart';

class PlaylistProvider extends BaseProvider {
  late SharedPreferences _prefs;

  List<String> playlistsNames = [];
  Map<String, List<String>> playlists = <String, List<String>>{};

  Future<Tuple2<List<String>, Map<String, List<String>>>> getPlaylists() async {
    _prefs = await SharedPreferences.getInstance();
    playlistsNames = _prefs.getStringList('playlistsNames') ?? <String>[];
    playlists = <String, List<String>>{};
    for (final playlistName in playlistsNames) {
      playlists[playlistName] = _prefs.getStringList(playlistName) ?? <String>[];
    }
    notifyListeners();
    return Tuple2(playlistsNames, playlists);
  }

  Future<void> deleteAllPlaylists() async {
    playlistsNames = <String>[];
    playlists = <String, List<String>>{};
    await update(playlistsNames, playlists);
  }

  Future<void> createPlaylist(String playlistName) async {
    final result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;

    if (!playlistsNames.contains(playlistName)) {
      playlistsNames.add(playlistName);
    }
    playlists[playlistName] = playlists[playlistName] ?? <String>[];

    await update(playlistsNames, playlists);
    notifyListeners();
  }

  Future<void> addSong(String playlistName, Track track) async {
    final result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;

    final temp = List<String>.from(playlists[playlistName] ?? <String>[]);
    temp.add(track.name ?? "");
    playlists[playlistName] = temp;

    await update(playlistsNames, playlists);
    notifyListeners();
  }

  Future<void> deleteSong(String playlistName, Track track) async {
    final result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;

    final temp = List<String>.from(playlists[playlistName] ?? <String>[]);
    temp.remove(track.name ?? "");
    playlists[playlistName] = temp;

    await update(playlistsNames, playlists);
    notifyListeners();
  }

  Future<void> deletePlaylist(String playlistName) async {
    final result = await getPlaylists();
    playlistsNames = result.item1;
    playlists = result.item2;

    playlistsNames.remove(playlistName);
    playlists.remove(playlistName);

    await update(playlistsNames, playlists);
    notifyListeners();
  }

  Future<void> update(List<String> playlistsNames, Map<String, List<String>> playlists) async {
    // Assure l'init si appelé directement
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setStringList('playlistsNames', playlistsNames);
    for (final entry in playlists.entries) {
      await _prefs.setStringList(entry.key, entry.value);
    }
    notifyListeners();
  }

  Album? findAlbum(Track track, BuildContext context) {
    final albums = context.read<AlbumProvider>().allAlbums;
    for (final album in albums) {
      if (album.tracks.contains(track)) {
        return album;
      }
    }
    return null;
  }

  Track findTrack(String trackName, BuildContext context) {
    final albums = context.read<AlbumProvider>().allAlbums;
    for (final album in albums) {
      for (final track in album.tracks) {
        if ((track.name ?? '') == trackName) {
          return track;
        }
      }
    }
    // fallback neutre
    return Track();
  }
}

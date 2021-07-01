import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/BaseProvider.dart';

import 'AuthProvider.dart';

const String trackLocalDownloadStorageSearch = 'TrackLocalDownloadStorageSearch';
const String trackDownloadList = 'TrackDownloadList';
const String AlbumDownloadList = 'AlbumDownloadList';
const String ArtistDownloadList = 'ArtistDownloadList';

class DownloadProvider extends BaseProvider with BaseMixins {
  String finaltime = '';

  getCurrenttime() {
    var time = new DateTime.now().toString();

    var timeParse = DateTime.parse(time);

    var formattedtime = "${timeParse.hour}-${timeParse.minute}-${timeParse.second}";

    finaltime = formattedtime.toString();
  }

  List<_TaskInfo> queuedSongs = [];

  List<Track> _downloadSongs = [];
  List<Track> get downloadSongs => _downloadSongs;
  Set<Album> _downloadedAlbums = Set();
  Set<Album> get downloadedAlbums => _downloadedAlbums;
  Set<Artist> _downloadedArtists = Set();
  Set<Artist> get downloadedArtists => _downloadedArtists;
  var dio = Dio();
  bool isDownload = false;
  Directory downloadDir;

  DownloadProvider() {
    getDownloads();
  }

  setDownloadSongs(List<Track> downloadSongs) {
    _downloadSongs = downloadSongs;
    notifyListeners();
  }

  downloadAlbum(Album album, BuildContext context) async {
    if (album.isBought) {
      if (!(album.tracks.fold(isDownloadSong(album.tracks[0]), (x, e) => x & isDownloadSong(e)))) {
        Flushbar(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          icon: Icon(
            Icons.download_outlined,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'download_msg')),
          messageText: Text($t(context, 'download_sub')),
        ).show(context);
        notifyListeners();
        await _downloadAlbum(album);
      } else {
        Flushbar(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          icon: Icon(
            Icons.warning_amber_outlined,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'ops')),
          messageText: Text($t(context, 'already_download')),
        ).show(context);
      }
    } else {
      Flushbar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).primaryColor,
        ),
        duration: Duration(seconds: 13),
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text($t(context, 'ops')),
        messageText: Text($t(context, 'did_not_buy')),
      ).show(context);
    }
  }

  downloadAudio(Track song, BuildContext context) async {
    if (context.read<AuthProvider>().boughtAlbumsIds.containsKey(song.albumId)) {
      if (!isDownloadSong(song)) {
        Flushbar(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          icon: Icon(
            Icons.download_outlined,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'download_msg')),
          messageText: Text($t(context, 'download_sub')),
        ).show(context);
        notifyListeners();
        await _downloadAudio(song);
      } else {
        Flushbar(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          icon: Icon(
            Icons.warning_amber_outlined,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'ops')),
          messageText: Text($t(context, 'already_download')),
        ).show(context);
      }
    } else {
      Flushbar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).primaryColor,
        ),
        duration: Duration(seconds: 13),
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text($t(context, 'ops')),
        messageText: Text($t(context, 'did_not_buy')),
      ).show(context);
    }
  }

  _downloadAlbum(Album album) async {
    for (Track track in album.tracks) {
      await _downloadAudio(track);
    }
  }

  _downloadAudio(Track song) async {
    print("donwloading");
    if (!isDownloadSong(song)) {
      getCurrenttime();
      isDownload = true;

      _requestDownload(_TaskInfo(track: song), downloadDir.path);
    }
  }

  addToDownloadSong(Track song) {
    print("added");
    song.localPath = "${downloadDir.path}/${song.name}";
    _downloadSongs.add(song);
    _downloadedAlbums.add(song.albumInfo);
    _downloadedArtists.add(song.artistInfo);
    saveSongData();
    notifyListeners();
  }

  Future<void> saveSongData() async {
    LocalStorage localStorage = LocalStorage(trackLocalDownloadStorageSearch);
    await localStorage.ready;
    List<Album> albums = _downloadedAlbums.toList();
    List<Artist> artists = _downloadedArtists.toList();
    await localStorage.setItem(trackDownloadList, _downloadSongs,
        (Object x) => (x as List<Track>).map((e) => e.toJson()).toList());
    await localStorage.ready;
    await localStorage.setItem(AlbumDownloadList, albums,
        (Object x) => (x as List<Album>).map((e) => e.toJson()).toList());
    await localStorage.ready;
    await localStorage.setItem(ArtistDownloadList, artists,
        (Object x) => (x as List<Artist>).map((e) => e.toJson()).toList());
  }

  getDownloads() async {
    isLoaded = false;
    notifyListeners();
    downloadDir = await getApplicationDocumentsDirectory();
    LocalStorage localStorage = LocalStorage(trackLocalDownloadStorageSearch);
    await localStorage.ready;
    List<Track> downloadList = (localStorage.getItem(trackDownloadList) ?? []).map<Track>((item) {
      return Track.fromJson(item);
    }).toList();
    _downloadSongs = downloadList;
    await localStorage.ready;
    _downloadedAlbums = (localStorage.getItem(AlbumDownloadList) ?? []).map<Album>((item) {
      return Album.fromJson(item);
    }).toSet();
    await localStorage.ready;
    _downloadedArtists = (localStorage.getItem(ArtistDownloadList) ?? []).map<Artist>((item) {
      return Artist.fromJson(item);
    }).toSet();
    _linkDownloadedSongsToAlbums();
    isLoaded = true;
    notifyListeners();
  }

  void _linkDownloadedSongsToAlbums() {
    for (int i = 0; i < _downloadSongs.length; i++) {
      _downloadSongs[i].albumInfo =
          _downloadedAlbums.firstWhere((element) => element.id == _downloadSongs[i].albumId);
      try {
        _downloadSongs[i].artistInfo =
            _downloadedArtists.firstWhere((element) => element.id == _downloadSongs[i].artistId);
      } catch (e, s) {
        print(s);
      }
    }
  }

  isDownloadSong(Track song) {
    _downloadSongs.contains(song);
    return _downloadSongs.map((e) => e.id).toList().contains(song.id);
  }

  String returnPath(Track song) {
    return _downloadSongs[_downloadSongs.indexOf(song)].localPath;
  }

  Track returnSong(Track song) {
    print(song.id);
    print(_downloadSongs.map((e) => e.id).toList());
    return _downloadSongs[_downloadSongs.indexOf(song)];
  }

  removeSong(Track song, {bool lastSong}) {
    if (_downloadSongs.contains(song)) {
      Directory dir = Directory(returnPath(song));
      dir.deleteSync(recursive: true);
      if (lastSong) _downloadedAlbums.removeWhere((element) => element.id == song.albumId);
      _downloadSongs.remove(song);
      saveSongData();
      notifyListeners();
    }
  }

  void removeAllSongs() {
    for (var song in _downloadSongs) {
      removeSong(song);
    }
    notifyListeners();
  }

  //------------------------------------------Download Functions------------------------------------
  ReceivePort _port = ReceivePort();
  List<_TaskInfo> _tasks = [];
  List<DownloadTask> tasks;

  void initFlutterDownloader(List<Track> allTracks) async {
    tasks = await FlutterDownloader.loadTasks();
    _tasks.addAll(tasks.map((e) {
      Track track = allTracks.firstWhere((element) => element.name == e.filename);
      if (track != null && e.progress != 100)
        return _TaskInfo(track: track)
          ..status = e.status
          ..progress = e.progress
          ..taskId = e.taskId;
      else
        return null;
    }));
    _tasks.removeWhere((element) => element == null);
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          task.status = status;
          task.progress = progress;
          if (status == DownloadTaskStatus.complete) {
            addToDownloadSong(task.track);
            _tasks.remove(task);
          } else if (status == DownloadTaskStatus.failed) {
            _retryDownload(_tasks[_tasks.indexWhere((element) => element.taskId == id)]);
          }
          notifyListeners();
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _requestDownload(_TaskInfo task, String localPath) async {
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    print(_tasks);
    if (!_tasks.any((element) => element.track.id == task.track.id)) {
      _tasks.add(task);
      task.taskId = await FlutterDownloader.enqueue(
          url: task.track.playUrl,
          fileName: task.track.name,
          savedDir: localPath,
          showNotification: true,
          openFileFromNotification: false);
    }
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }
}

class _TaskInfo {
  final Track track;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.track});
}

// Future downloadFileTo({Dio dio, String url, String savePath, Function(int received, int total) progressFunction}) async {
//   try {
//     final Response response = await dio.download(
//       url,
//       savePath,
//       onReceiveProgress: progressFunction,
//       options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           validateStatus: (status) {
//             return status < 500;
//           }),
//     );
//     // final Response response = await dio.get(
//     //   url,
//     //   onReceiveProgress: progressFunction,
//     //
//     //   //Received data with List<int>
//     //   options: Options(
//     //       responseType: ResponseType.bytes,
//     //       followRedirects: false,
//     //       validateStatus: (status) {
//     //         return status < 500;
//     //       }),
//     // );
//     print(response.headers);
//     final File file = File(savePath);
//     var raf = file.openSync(mode: FileMode.write);
//     // response.data is List<int> type
//     await raf.writeFrom(response.data);
//     await raf.close();
//   } catch (e) {
//     print(e);
//   }
// }

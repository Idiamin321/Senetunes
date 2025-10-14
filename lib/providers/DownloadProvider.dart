import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/models/DownloadTaskInfo.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/BaseProvider.dart';

import 'AuthProvider.dart';

const String trackLocalDownloadStorageSearch = 'TrackLocalDownloadStorageSearch';
const String trackDownloadList = 'TrackDownloadList';
const String AlbumDownloadList = 'AlbumDownloadList';
const String ArtistDownloadList = 'ArtistDownloadList';

class DownloadProvider extends BaseProvider with BaseMixins {
  String finaltime = '';

  void getCurrenttime() {
    final timeParse = DateTime.now();
    finaltime = "${timeParse.hour}-${timeParse.minute}-${timeParse.second}";
  }

  List<Track> _downloadSongs = [];
  List<Track> get downloadSongs => _downloadSongs;

  Set<Album> _downloadedAlbums = <Album>{};
  Set<Album> get downloadedAlbums => _downloadedAlbums;

  Set<Artist> _downloadedArtists = <Artist>{};
  Set<Artist> get downloadedArtists => _downloadedArtists;

  final dio = Dio();
  bool isDownload = false;

  late Directory downloadDir;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  DownloadProvider() {
    _initNotifications();
    getDownloads();
    _bindBackgroundIsolate();
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void setDownloadSongs(List<Track> downloadSongs) {
    _downloadSongs = downloadSongs;
    notifyListeners();
  }

  Future<void> downloadAlbum(Album album, BuildContext context) async {
    if (album.isBought) {
      // au moins une piste non téléchargée ?
      final hasUndownloaded = album.tracks.any((t) => !isDownloadSong(t));
      if (hasUndownloaded) {
        Flushbar(
          backgroundColor: barColor.withOpacity(0.95),
          icon: Icon(Icons.download_outlined, color: Theme.of(context).primaryColor),
          duration: const Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'download_msg'), style: const TextStyle(color: white)),
          messageText: Text($t(context, 'download_sub'), style: const TextStyle(color: white)),
        ).show(context);
        notifyListeners();
        await _downloadAlbum(album);
      } else {
        Flushbar(
          backgroundColor: barColor.withOpacity(0.95),
          icon: Icon(Icons.warning_amber_outlined, color: Theme.of(context).primaryColor),
          duration: const Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'ops'), style: const TextStyle(color: white)),
          messageText: Text($t(context, 'already_download'), style: const TextStyle(color: white)),
        ).show(context);
      }
    } else {
      Flushbar(
        backgroundColor: barColor.withOpacity(0.95),
        icon: Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
        duration: const Duration(seconds: 13),
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text($t(context, 'ops'), style: const TextStyle(color: white)),
        messageText: Text($t(context, 'did_not_buy'), style: const TextStyle(color: white)),
      ).show(context);
    }
  }

  Future<void> downloadAudio(Track song, BuildContext context) async {
    final bought = context.read<AuthProvider>().boughtAlbumsIds.containsKey(song.albumId);
    if (bought) {
      if (!isDownloadSong(song)) {
        Flushbar(
          backgroundColor: barColor.withOpacity(0.95),
          icon: Icon(Icons.download_outlined, color: Theme.of(context).primaryColor),
          duration: const Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'download_msg'), style: const TextStyle(color: white)),
          messageText: Text($t(context, 'download_sub'), style: const TextStyle(color: white)),
        ).show(context);
        notifyListeners();
        await _downloadAudio(song);
      } else {
        Flushbar(
          backgroundColor: barColor.withOpacity(0.95),
          icon: Icon(Icons.warning_amber_outlined, color: Theme.of(context).primaryColor),
          duration: const Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'ops'), style: const TextStyle(color: white)),
          messageText: Text($t(context, 'already_download'), style: const TextStyle(color: white)),
        ).show(context);
      }
    } else {
      Flushbar(
        backgroundColor: barColor.withOpacity(0.95),
        icon: Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
        duration: const Duration(seconds: 13),
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text($t(context, 'ops'), style: const TextStyle(color: white)),
        messageText: Text($t(context, 'did_not_buy'), style: const TextStyle(color: white)),
      ).show(context);
    }
  }

  Future<void> _downloadAlbum(Album album) async {
    for (final track in album.tracks) {
      await _downloadAudio(track);
    }
  }

  Future<void> _downloadAudio(Track song) async {
    if (!isDownloadSong(song)) {
      getCurrenttime();
      isDownload = true;
      _enqueue(DownloadTaskInfo(track: song));
    }
  }

  void addToDownloadSong(Track song) {
    song.localPath = "${downloadDir.path}/${song.name}.mp3";
    _downloadSongs.add(song);
    _downloadedAlbums.add(song.albumInfo);
    _downloadedArtists.add(song.artistInfo);
    saveSongData();
    notifyListeners();
  }

  Future<void> saveSongData() async {
    final localStorage = LocalStorage(trackLocalDownloadStorageSearch);
    await localStorage.ready;

    final albums = _downloadedAlbums.toList();
    final artists = _downloadedArtists.toList();

    await localStorage.setItem(
      trackDownloadList,
      _downloadSongs,
          (Object x) => (x as List<Track>).map((e) => e.toJson()).toList(),
    );
    await localStorage.setItem(
      AlbumDownloadList,
      albums,
          (Object x) => (x as List<Album>).map((e) => e.toJson()).toList(),
    );
    await localStorage.setItem(
      ArtistDownloadList,
      artists,
          (Object x) => (x as List<Artist>).map((e) => e.toJson()).toList(),
    );
  }

  Future<void> getDownloads() async {
    isLoaded = false;
    notifyListeners();

    downloadDir = await getApplicationDocumentsDirectory();

    final localStorage = LocalStorage(trackLocalDownloadStorageSearch);
    await localStorage.ready;

    final List<dynamic> rawTracks = localStorage.getItem(trackDownloadList) ?? [];
    _downloadSongs = rawTracks.map<Track>((item) => Track.fromJson(item)).toList();

    final List<dynamic> rawAlbums = localStorage.getItem(AlbumDownloadList) ?? [];
    _downloadedAlbums = rawAlbums.map<Album>((item) => Album.fromJson(item)).toSet();

    final List<dynamic> rawArtists = localStorage.getItem(ArtistDownloadList) ?? [];
    _downloadedArtists = rawArtists.map<Artist>((item) => Artist.fromJson(item)).toSet();

    _linkDownloadedSongsToAlbums();

    isLoaded = true;
    notifyListeners();
  }

  void _linkDownloadedSongsToAlbums() {
    for (int i = 0; i < _downloadSongs.length; i++) {
      final track = _downloadSongs[i];
      // Album
      try {
        track.albumInfo =
            _downloadedAlbums.firstWhere((element) => element.id == track.albumId);
      } catch (_) {}
      // Artiste
      try {
        track.artistInfo =
            _downloadedArtists.firstWhere((element) => element.id == track.artistId);
      } catch (_) {}
    }
  }

  bool isDownloadSong(Track song) {
    return _downloadSongs.any((e) => e.id == song.id);
  }

  String returnPath(Track song) {
    final idx = _downloadSongs.indexOf(song);
    if (idx < 0) return song.localPath;
    return _downloadSongs[idx].localPath;
  }

  Track returnSong(Track song) {
    final idx = _downloadSongs.indexOf(song);
    if (idx < 0) return song;
    return _downloadSongs[idx];
  }

  void removeSong(Track song, {bool lastSong = false}) {
    if (_downloadSongs.contains(song)) {
      // On supprime le FICHIER (et pas un répertoire)
      final file = File(returnPath(song));
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }

      if (lastSong) {
        _downloadedAlbums.removeWhere((element) => element.id == song.albumId);
      }
      _downloadSongs.remove(song);
      saveSongData();
      notifyListeners();
    }
  }

  void removeAllSongs() {
    final toRemove = List<Track>.from(_downloadSongs);
    for (final song in toRemove) {
      removeSong(song);
    }
    notifyListeners();
  }

  //------------------------------------------Download Functions------------------------------------
  final ReceivePort receivePort = ReceivePort();
  SendPort? sendPort;
  SendPort? logicPort;

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloadIsolate');
  }

  void _bindBackgroundIsolate() {
    final isSuccess =
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadIsolate");
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    sendPort = receivePort.sendPort;
    logicPort = IsolateNameServer.lookupPortByName('downloader_send_port');

    receivePort.listen((dynamic message) async {
      final box = Hive.box('downloads');
      final DownloadTaskInfo downloadTaskInfo = message as DownloadTaskInfo;

      if (downloadTaskInfo.received >= downloadTaskInfo.total) {
        // terminé
        await box.delete(downloadTaskInfo.track.albumId.toString());
        await _flutterLocalNotificationsPlugin.cancel(downloadTaskInfo.track.id);

        const androidDone = AndroidNotificationDetails(
          'progress_channel',
          'Progress',
          channelShowBadge: false,
          importance: Importance.min,
          priority: Priority.min,
          onlyAlertOnce: true,
          playSound: false,
        );
        const iosDone = DarwinNotificationDetails(
          presentSound: false,
          threadIdentifier: 'download_done',
        );
        const platform = NotificationDetails(android: androidDone, iOS: iosDone);

        await _flutterLocalNotificationsPlugin.show(
          downloadTaskInfo.track.id,
          'Téléchargement complété',
          downloadTaskInfo.track.name,
          platform,
        );

        addToDownloadSong(downloadTaskInfo.track);

        await Future.delayed(const Duration(milliseconds: 200), () async {
          final task = await _dequeue();
          if (task != null) {
            logicPort ??= IsolateNameServer.lookupPortByName('downloader_send_port');
            logicPort?.send(task);
          }
        });
      } else {
        final showNotif = box.get(downloadTaskInfo.track.albumId.toString(), defaultValue: true) as bool;
        if (showNotif || Platform.isAndroid) {
          await box.put(downloadTaskInfo.track.albumId.toString(), false);

          final androidProg = AndroidNotificationDetails(
            'progress_channel',
            'Progress',
            channelShowBadge: false,
            importance: Importance.min,
            priority: Priority.min,
            onlyAlertOnce: true,
            playSound: false,
            showProgress: true,
            maxProgress: downloadTaskInfo.total,
            progress: downloadTaskInfo.received,
          );
          const iosProg = DarwinNotificationDetails(
            presentSound: false,
            threadIdentifier: 'download_progress',
          );
          final platform = NotificationDetails(android: androidProg, iOS: iosProg);

          await _flutterLocalNotificationsPlugin.show(
            downloadTaskInfo.track.id,
            'Téléchargement en cours',
            downloadTaskInfo.track.name,
            platform,
          );
        }
      }
    });
  }

  Future<DownloadTaskInfo?> _dequeue() async {
    final box = Hive.box('downloads');
    final List<DownloadTaskInfo> tasks =
    List<DownloadTaskInfo>.from(box.get("tasks", defaultValue: <DownloadTaskInfo>[]));
    if (tasks.isEmpty) return null;
    final task = tasks.first;
    tasks.removeAt(0);
    await box.put('tasks', tasks);
    return task;
  }

  Future<void> _enqueue(DownloadTaskInfo taskInfo) async {
    final box = Hive.box('downloads');
    List<DownloadTaskInfo> tasks =
    List<DownloadTaskInfo>.from(box.get("tasks", defaultValue: <DownloadTaskInfo>[]));
    if (tasks.isEmpty) {
      logicPort ??= IsolateNameServer.lookupPortByName('downloader_send_port');
      logicPort?.send(taskInfo);
    } else {
      tasks.add(taskInfo);
      await box.put('tasks', tasks);
      tasks = List<DownloadTaskInfo>.from(box.get("tasks", defaultValue: <DownloadTaskInfo>[]));
    }
    log(tasks.toString());
  }
}

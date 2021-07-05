import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/CartProvider.dart';

class PlayerProvider extends ChangeNotifier with BaseMixins {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  var directory;

  PlayerProvider() {
    init();
  }

  init() async {
    _isLoaded = false;
    directory = await getTemporaryDirectory();
    player.playlistAudioFinished.listen((Playing playing) {
      next(action: false);
    });
    _isLoaded = true;
  }

  Album _currentAlbum;
  Album get currentAlbum => _currentAlbum;

  Album _playlist;
  Album get playlist => _playlist;

  Track _currentTrack;
  Track get currentTrack => _currentTrack;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  bool _loopMode = false;
  bool get loopMode => _loopMode;
  bool _loopPlaylist = false;
  bool get loopPlaylist => _loopPlaylist;
  bool _isTrackLoaded = true;
  bool get isTrackLoaded => _isTrackLoaded;
  int _currentIndex;
  int get currentIndex => _currentIndex;
  CancelToken _currentSongCancelToken;
  set currentAlbum(album) {
    _currentAlbum = album;
    notifyListeners();
  }

  int _sessionId;
  int get sessionId => _sessionId;

  int tIndex;

  setBuffering(index) {
    tIndex = index;
  }

  playOrPause() async {
    try {
      await player.playOrPause();
    } catch (t) {}
  }

  isFirstTrack() {
    return _currentIndex == 0;
  }

  isLastTrack(next) {
    return next == _currentAlbum.tracks.length;
  }

  /// Next Track:
  /// Action will be false if used with playlistAudioFinished listener
  /// A track can be next by action or on playlistAudioFinished
  next({action: true}) {
    int next = _currentIndex + 1;
    if (!action && _loopMode && isLastTrack(next) && _loopPlaylist) {
      setPlaying(_currentAlbum, 0, _currentAlbum.tracks[0]);
      play(0);
    } else if (!action && _loopMode && !_loopPlaylist) {
      setPlaying(
          _currentAlbum, _currentIndex, _currentAlbum.tracks[_currentIndex]);
      play(_currentIndex);
    } else {
      play(next);
    }
  }

  prev() {
    int pre = _currentIndex - 1;
    if (pre <= _currentAlbum.tracks.length) {
      play(pre);
    }
  }

  /// Tracks Loop:
  /// Loop a single track or complete playlist
  ///
  int c = 0;
  handleLoop() {
    c++;
    if (c == 1) {
      _loopMode = true;
      _loopPlaylist = true;
    } else if (c == 2) {
      _loopMode = true;
      _loopPlaylist = false;
    } else if (c > 2) {
      _loopMode = _loopPlaylist = false;
      c = 0;
    }
  }

  /// Playlist Shuffing:
  /// Make a copy of original before shuffle
  ///
  Album _beforeShuffling;
  bool _shuffled = false;
  bool get shuffled => _shuffled;
  handleShuffle() {
    _shuffled = !_shuffled;
    List<Track> tracks = _currentAlbum.tracks;
    _beforeShuffling = _currentAlbum;
    var shuffledTracks = shuffle(tracks);
    if (_shuffled) {
      Album album = Album(
        id: _currentAlbum.id,
        name: _currentAlbum.name,
        description: _currentAlbum.description,
        media: _currentAlbum.media,
        tracks: shuffledTracks,
      );
      _currentAlbum = album;
    } else {
      _currentAlbum = _beforeShuffling;
    }
  }

  /// Play Track
  /// Play track and set current track index
  ///
  play(index) async {
    player.stop();
    try {
      _currentTrack = _currentAlbum.tracks[index];
      notifyListeners();
      await player.open(
        Audio.network(_currentAlbum.tracks[index].playUrl),
      );
      _currentIndex = index;
    } catch (t) {
      //mp3 unreachable
    }
  }

  isSameAlbum() {
    return _playlist.id == _currentAlbum.id;
  }

  isTrackInProgress(Track track) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.current.value.audio.assetAudioPath ==
            '${directory.path}/${track.playUrl}.mp3';
  }

  isLocalTrackInProgress(filePath) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.current.value.audio.assetAudioPath == filePath;
  }

  bool isPlaying() {
    return player.isPlaying.value;
  }

  void audioSessionListener() {
    player.audioSessionId.listen((sessionId) {
      _sessionId = sessionId;
    });
  }

  handlePlayButton({album, Track track, index, BuildContext context}) async {
    //Disable shuffling
    CartProvider cartProvider = context.read<CartProvider>();
    _shuffled = false;

    setBuffering(index);
    if (album.isBought) {
      try {
        if (isTrackInProgress(track) ||
            isLocalTrackInProgress(track.localPath)) {
          player.pause();
          _currentSongCancelToken.cancel();
        } else {
          _isTrackLoaded = false;
          _currentSongCancelToken = CancelToken();
          notifyListeners();
          print(track.localPath);
          print(track.playUrl);
          if (track.localPath != null) {
            await player
                .open(Audio.file(track.localPath), showNotification: true)
                .catchError((e) => print(e));
            _isTrackLoaded = true;
            notifyListeners();
            setPlaying(album, index, track);
          } else {
            _isTrackLoaded = false;
            notifyListeners();
            Dio dio = Dio();
            dio.download(
                track.playUrl, "${directory.path}/${track.playUrl}.mp3",
                cancelToken: _currentSongCancelToken,
                onReceiveProgress: (received, total) async {
              if ((received / total * 100 > 9)) {
                if (!_isTrackLoaded) {
                  print("downloading");
                  player
                      .open(
                          Audio.file("${directory.path}/${track.playUrl}.mp3"),
                          showNotification: true,
                          playInBackground: PlayInBackground.enabled)
                      .catchError((e) => print(e));
                  _isTrackLoaded = true;
                  notifyListeners();
                  setPlaying(album, index, track);
                }
              } else
                _isTrackLoaded = false;
            });
          }
        }
      } on PlatformException catch (t, stacktrace) {
        //mp3 unreachable
        await FirebaseCrashlytics.instance.recordError(t, stacktrace,
            reason: 'a fatal error',
            // Pass in 'fatal' argument
            printDetails: true);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Icon(
              Icons.warning,
              size: 30,
              color: primary,
            ),
          ),
          content: Text(
            "Achetez cet album afin  d'écouter vos musiques préférez où vous voulez avec ou sans connexion",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartProvider.addAlbum(album);
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: Text(
                "Achetez l'album maintenant",
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    }
  }

  setPlaying(Album album, int index, Track track) {
    _currentAlbum = album;
    _currentIndex = index;
    _currentTrack = track;
  }

  String getTrackThumbnail() {
    String image = '';
    if (_currentTrack?.albumInfo?.media != null &&
        _currentTrack?.albumInfo?.media?.thumbnail != null) {
      image = _currentTrack.albumInfo.media.thumbnail;
    }
    return image;
  }

  String getTrackCover() {
    String image = '';
    if (_currentTrack.albumInfo.media != null &&
        _currentTrack.albumInfo.media.cover != null) {
      image = _currentTrack.albumInfo.media.cover;
    } else {
      image = getTrackThumbnail();
    }
    return image;
  }
}

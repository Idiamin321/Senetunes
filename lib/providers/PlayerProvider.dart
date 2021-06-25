import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:provider/provider.dart';

class PlayerProvider extends ChangeNotifier with BaseMixins {
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  PlayerProvider() {
    player.playlistAudioFinished.listen((Playing playing) {
      next(action: false);
    });
  }

  Album _currentAlbum;
  Album get currentAlbum => _currentAlbum;

  Album _playlist;
  Album get playlist => _playlist;

  Track _currentTrack;
  Track get currentTrack => _currentTrack;

  bool _loopMode = false;
  bool get loopMode => _loopMode;
  bool _loopPlaylist = false;
  bool get loopPlaylist => _loopPlaylist;
  bool _isTrackLoaded = true;
  bool get isTrackLoaded => _isTrackLoaded;
  int _currentIndex;
  int get currentIndex => _currentIndex;
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
      setPlaying(_currentAlbum, _currentIndex, _currentAlbum.tracks[_currentIndex]);
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
        player.current.value.audio.assetAudioPath == track.playUrl;
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
        if (isTrackInProgress(track) || isLocalTrackInProgress(track.localPath)) {
          player.pause();
        } else {
          _isTrackLoaded = false;
          notifyListeners();
          print(track.localPath);
          await player.open(Audio.file(track.localPath)).catchError((e) async => await player.open(
                Audio.network(track.playUrl),
              ));
          _isTrackLoaded = true;
          notifyListeners();
          setPlaying(album, index, track);
        }
      } catch (t) {
        //mp3 unreachable
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
    if (_currentTrack.albumInfo.media != null && _currentTrack.albumInfo.media.cover != null) {
      image = _currentTrack.albumInfo.media.cover;
    } else {
      image = getTrackThumbnail();
    }
    return image;
  }
}

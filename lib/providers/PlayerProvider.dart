import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/CartProvider.dart';

class PlayerProvider extends ChangeNotifier with BaseMixins {
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  late Directory directory;

  bool isLoading = true;

  PlayerProvider() {
    init();
  }

  Future<void> init() async {
    _isLoaded = false;
    isLoading = true;

    directory = await getTemporaryDirectory();

    // Quand une piste se termine
    player.playlistAudioFinished.listen((Playing playing) {
      next(action: false);
    });

    isLoading = true;
    _isLoaded = true;
  }

  Album? _currentAlbum;
  Album? get currentAlbum => _currentAlbum;

  Album? _playlist;
  Album? get playlist => _playlist;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _loopMode = false;
  bool get loopMode => _loopMode;

  bool _loopPlaylist = false;
  bool get loopPlaylist => _loopPlaylist;

  bool _isTrackLoaded = true;
  bool get isTrackLoaded => _isTrackLoaded;

  int _currentIndex = -1;
  int get currentIndex => _currentIndex;

  CancelToken? _currentSongCancelToken;

  set currentAlbum(Album? album) {
    _currentAlbum = album;
    notifyListeners();
  }

  set currentTrack(Track? track) {
    _currentTrack = track;
    notifyListeners();
  }

  int? _sessionId;
  int? get sessionId => _sessionId;

  int? tIndex;

  void setBuffering(int index) {
    tIndex = index;
  }

  Future<void> playOrPause() async {
    isLoading = false;
    try {
      await player.playOrPause();
    } catch (_) {
      // noop
    }
    notifyListeners();
  }

  bool isFirstTrack() => _currentIndex == 0;

  bool isLastTrack(int next) {
    final album = _currentAlbum;
    if (album == null) return true;
    return next >= album.tracks.length;
  }

  /// Next Track:
  /// [action] = false quand appelé par playlistAudioFinished
  Future<void> next({bool action = true}) async {
    if (_currentAlbum == null) return;
    final int nextIndex = _currentIndex + 1;

    if (!action && _loopMode && isLastTrack(nextIndex) && _loopPlaylist) {
      // Repart du début
      setPlaying(_currentAlbum!, 0, _currentAlbum!.tracks[0]);
      await play(0);
    } else if (!action && _loopMode && !_loopPlaylist) {
      // Boucle sur la même piste
      setPlaying(_currentAlbum!, _currentIndex, _currentAlbum!.tracks[_currentIndex]);
      await play(_currentIndex);
    } else {
      await play(nextIndex);
    }
  }

  Future<void> prev() async {
    if (_currentAlbum == null) return;
    final int prevIndex = _currentIndex - 1;
    if (prevIndex >= 0) {
      await play(prevIndex);
    }
  }

  // Gestion boucle
  int _loopStep = 0;
  void handleLoop() {
    _loopStep++;
    if (_loopStep == 1) {
      _loopMode = true;
      _loopPlaylist = true; // repeat playlist
    } else if (_loopStep == 2) {
      _loopMode = true;
      _loopPlaylist = false; // repeat one
    } else {
      _loopMode = false;
      _loopPlaylist = false;
      _loopStep = 0;
    }
    notifyListeners();
  }

  /// Shuffle
  Album? _beforeShuffling;
  bool _shuffled = false;
  bool get shuffled => _shuffled;

  void handleShuffle() {
    if (_currentAlbum == null) return;

    _shuffled = !_shuffled;
    final tracks = List<Track>.from(_currentAlbum!.tracks);
    _beforeShuffling ??= _currentAlbum;

    if (_shuffled) {
      final shuffledTracks = shuffle(tracks);
      _currentAlbum = Album(
        id: _currentAlbum!.id,
        name: _currentAlbum!.name,
        description: _currentAlbum!.description,
        media: _currentAlbum!.media,
        tracks: shuffledTracks,
      );
    } else {
      _currentAlbum = _beforeShuffling;
    }
    notifyListeners();
  }

  /// Play track at [index]
  Future<void> play(int index) async {
    final album = _currentAlbum;
    if (album == null) return;

    if (index < 0 || index >= album.tracks.length) {
      return; // out of bounds
    }

    player.stop();

    try {
      _currentTrack = album.tracks[index];
      notifyListeners();

      final Dio dio = Dio();
      final url = album.tracks[index].playUrl;
      final localPath = "${directory.path}/$url.mp3";

      // Annule le téléchargement précédent s'il existe
      _currentSongCancelToken?.cancel();
      _currentSongCancelToken = CancelToken();

      await dio.download(
        url,
        localPath,
        cancelToken: _currentSongCancelToken,
        onReceiveProgress: (received, total) async {
          // Démarre la lecture après un tampon minimal (~10%)
          if (total > 0 && (received / total * 100 > 9)) {
            if (!_isTrackLoaded) {
              try {
                await player.open(
                  Audio.file(
                    localPath,
                    metas: Metas(
                      title: album.tracks[index].displayedName,
                      artist: album.tracks[index].artistInfo.name,
                      album: album.name,
                      image: MetasImage.network(album.tracks[index].albumInfo.media.medium),
                      onImageLoadFail: const MetasImage.asset('assets/images/album.png'),
                    ),
                  ),
                  showNotification: true,
                  playInBackground: PlayInBackground.enabled,
                );
              } catch (e) {
                debugPrint('player.open error: $e');
              }
              _isTrackLoaded = true;
              notifyListeners();
              setPlaying(album, index, album.tracks[index]);
            }
          } else {
            _isTrackLoaded = false;
          }
        },
      );

      _currentIndex = index;
    } catch (t) {
      debugPrint('Play error: $t');
      // mp3 unreachable or download error
    }
  }

  bool isSameAlbum() {
    if (_playlist == null || _currentAlbum == null) return false;
    return _playlist!.id == _currentAlbum!.id;
  }

  bool isTrackInProgress(Track track) {
    final isPlayingNow = player.isPlaying.value;
    final current = player.current.value;
    final path = '${directory.path}/${track.playUrl}.mp3';
    return isPlayingNow && current != null && current.audio.assetAudioPath == path;
  }

  bool isLocalTrackInProgress(String filePath) {
    final isPlayingNow = player.isPlaying.value;
    final current = player.current.value;
    return isPlayingNow && current != null && current.audio.assetAudioPath == filePath;
  }

  bool isPlaying() => player.isPlaying.value;

  void audioSessionListener() {
    player.audioSessionId.listen((sessionId) {
      _sessionId = sessionId;
    });
  }

  Future<void> handlePlayButton({
    required Album album,
    required Track track,
    required int index,
    required BuildContext context,
  }) async {
    // Désactive le shuffle
    isLoading = false;
    _shuffled = false;

    setBuffering(index);

    final cartProvider = Navigator.of(context).context.read<CartProvider>();

    if (album.isBought) {
      try {
        if (isTrackInProgress(track) || isLocalTrackInProgress(track.localPath)) {
          await player.pause();
          _currentSongCancelToken?.cancel();
        } else {
          _isTrackLoaded = false;
          _currentSongCancelToken = CancelToken();
          try {
            await player.open(
              Audio.file(track.localPath),
              showNotification: true,
            );
          } catch (e) {
            debugPrint('player.open (local) error: $e');
          }
          _isTrackLoaded = true;
          setPlaying(album, index, track);
        }
      } on PlatformException catch (t) {
        debugPrint('PlatformException: $t');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: white,
          title: Center(
            child: Icon(
              Icons.warning,
              size: 30,
              color: primary,
            ),
          ),
          content: const Text(
            "Achetez cet album afin d'écouter vos musiques préférées où vous voulez avec ou sans connexion",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartProvider.addAlbum(album);
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: const Text(
                "Achetez l'album maintenant",
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future<void> handleDownloadPlayButton({
    required Album album,
    required Track track,
    required int index,
    required BuildContext context,
  }) async {
    final cartProvider = Navigator.of(context).context.read<CartProvider>();

    _shuffled = false;
    _currentIndex = index;
    setBuffering(index);

    if (album.isBought) {
      try {
        if (isTrackInProgress(track) || isLocalTrackInProgress(track.localPath)) {
          await player.pause();
          _currentSongCancelToken?.cancel();
        } else {
          _isTrackLoaded = false;
          _currentSongCancelToken = CancelToken();
          try {
            await player.open(
              Audio.file(track.localPath),
              showNotification: true,
            );
          } catch (e) {
            debugPrint('player.open (download) error: $e');
          }
          _isTrackLoaded = true;
        }
      } on PlatformException catch (t) {
        debugPrint('PlatformException: $t');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: white,
          title: Center(
            child: Icon(
              Icons.warning,
              size: 30,
              color: primary,
            ),
          ),
          content: const Text(
            "Achetez cet album afin d'écouter vos musiques préférées où vous voulez avec ou sans connexion",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartProvider.addAlbum(album);
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              child: const Text(
                "Achetez l'album maintenant",
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  void setPlaying(Album album, int index, Track track) {
    _currentAlbum = album;
    _currentIndex = index;
    _currentTrack = track;
  }

  String getTrackThumbnail() {
    final track = _currentTrack;
    if (track == null) return '';
    return track.albumInfo.media.medium;
  }

  String getTrackCover() {
    final track = _currentTrack;
    if (track == null) return '';
    return track.albumInfo.media.cover;
  }
}

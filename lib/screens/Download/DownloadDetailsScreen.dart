import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackBottomBar.dart';
import 'package:senetunes/widgtes/track/TrackFavouriteButton.dart';
import 'package:senetunes/widgtes/track/TrackPlayButton.dart';
import 'package:senetunes/widgtes/track/TrackTileActions.dart';

import '../downloadPlayerScreen.dart';

class DownloadDetailsScreen extends StatefulWidget {
  const DownloadDetailsScreen({super.key});

  @override
  State<DownloadDetailsScreen> createState() => _DownloadDetailsScreenState();
}

class _DownloadDetailsScreenState extends State<DownloadDetailsScreen>
    with BaseMixins {
  final Connectivity _connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    final downloadedAlbum =
    ModalRoute.of(context)!.settings.arguments as Album;

    // Juste pour déclencher le provider (si nécessaire)
    // ignore: unused_local_variable
    final _ = context.read<PlaylistProvider>().playlists;

    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      builder: (context, snapshot) {
        final connected = snapshot.data != ConnectivityResult.none;

        return Scaffold(
          backgroundColor: background,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: BaseScreenHeading(
              title: "Downloads",
              centerTitle: false,
              isBack: true,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: background,
                  child: TrackContainer(downloadedAlbum, connected),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrackContainer extends StatefulWidget {
  const TrackContainer(this.downloadedAlbum, this.connected, {super.key});
  final bool connected;
  final Album downloadedAlbum;

  @override
  State<TrackContainer> createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  late DownloadProvider downloadProvider;
  late List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    downloadProvider = context.watch<DownloadProvider>();
    tracks = downloadProvider.downloadSongs
        .where((e) => e.albumId == widget.downloadedAlbum.id)
        .toList();

    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    final Track? track = playerProvider.currentTrack;

    return Stack(
      children: [
        Container(
          color: background,
          padding: const EdgeInsets.only(bottom: 50),
          child: tracks.isNotEmpty
              ? ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DownloadTrackTile(
                      track: tracks[index],
                      index: index,
                      album: widget.downloadedAlbum,
                      isDownloadTile: true,
                    ),
                  ),
                ],
              );
            },
          )
              : const SizedBox.shrink(),
        ),
        widget.connected
            ? const Positioned(
          bottom: 0.0,
          left: 0.0,
          height: 55,
          right: 0.0,
          child: TrackBottomBar(),
        )
            : Positioned(
          bottom: 0.0,
          left: 0.0,
          height: 55,
          right: 0.0,
          child: playerProvider.isLoading
              ? const SizedBox.shrink()
              : const DownloadTrackBottomBar(),
        ),
      ],
    );
  }
}

class DownloadTrackBottomBar extends StatefulWidget {
  const DownloadTrackBottomBar({super.key});

  @override
  State<DownloadTrackBottomBar> createState() => _DownloadTrackBottomBarState();
}

class _DownloadTrackBottomBarState extends State<DownloadTrackBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late DownloadProvider downloadProvider;
  late List<Track> tracks;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return PlayerBuilder.realtimePlayingInfos(
      player: playerProvider.player,
      builder: (context, infos) {
        downloadProvider = context.watch<DownloadProvider>();
        tracks = downloadProvider.downloadSongs
            .where((e) => e.albumId == playerProvider.currentAlbum.id)
            .toList();

        final currentIdx = playerProvider.currentIndex;
        final current = (currentIdx >= 0 &&
            currentIdx < downloadProvider.downloadSongs.length)
            ? downloadProvider.downloadSongs[currentIdx]
            : null;

        return GestureDetector(
          onTap: () {
            if (playerProvider.currentTrack.localPath != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DownloadPlayerScreen(
                    allTracks: downloadProvider.downloadSongs,
                    currentOne: playerProvider.currentTrack,
                  ),
                ),
              );
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                topLeft: Radius.circular(0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            height: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) {
                      double angle = _controller.value * 2 * pi;
                      if (!playerProvider.isPlaying()) {
                        angle = 0.0;
                      }
                      return Transform.rotate(
                        angle: angle,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BaseImage(
                            imageUrl: playerProvider.getTrackThumbnail(),
                            width: 40,
                            height: 40,
                            radius: 500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              current?.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 14,
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              current?.artistInfo?.name ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxFontSize: 11,
                              minFontSize: 11,
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.fast_rewind),
                        iconSize: 20,
                        color: playerProvider.currentIndex == 0
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (playerProvider.currentIndex != 0) {
                            await playerProvider.handleDownloadPlayButton(
                              album: playerProvider.currentAlbum,
                              track: downloadProvider.downloadSongs[
                              playerProvider.currentIndex - 1],
                              index: playerProvider.currentIndex - 1,
                              context: context,
                            );
                          }
                        },
                      ),
                      TrackPlayButton(
                        track: current ??
                            (downloadProvider.downloadSongs.isNotEmpty
                                ? downloadProvider
                                .downloadSongs[playerProvider.currentIndex]
                                : playerProvider.currentTrack),
                        album: playerProvider.currentAlbum,
                        index: playerProvider.currentIndex,
                        onPressed: () => playerProvider.playOrPause(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_forward),
                        color: (downloadProvider.downloadSongs.length - 1 ==
                            playerProvider.currentIndex)
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        iconSize: 20,
                        onPressed: () async {
                          if (downloadProvider.downloadSongs.length - 1 !=
                              playerProvider.currentIndex) {
                            await playerProvider.handleDownloadPlayButton(
                              album: playerProvider.currentAlbum,
                              track: downloadProvider.downloadSongs[
                              playerProvider.currentIndex + 1],
                              index: playerProvider.currentIndex + 1,
                              context: context,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DownloadTrackTile extends StatefulWidget {
  final bool? isDownloadTile;
  final Album album;
  final Track track;
  final int index;
  final List<Track>? tracks;

  const DownloadTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.album,
    this.isDownloadTile,
    this.tracks,
  });

  @override
  State<DownloadTrackTile> createState() => _DownloadTrackTileState();
}

class _DownloadTrackTileState extends State<DownloadTrackTile> with BaseMixins {
  late List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context);
    var downloadProvider = Provider.of<DownloadProvider>(context);
    downloadProvider = context.watch<DownloadProvider>();

    tracks = downloadProvider.downloadSongs
        .where((e) => e.albumId == widget.album.id)
        .toList();

    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Container(
          color: background,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              ListTile(
                tileColor: Colors.black,
                onTap: () {
                  p.setBuffering(widget.index);
                  if (p.isTrackInProgress(widget.track) ||
                      p.isLocalTrackInProgress(widget.track.localPath)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DownloadPlayerScreen(
                          allTracks: downloadProvider.downloadSongs,
                          currentOne: playerProvider.currentTrack,
                        ),
                      ),
                    );
                  }
                },
                title: Text(
                  widget.track.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: widget.track.artistInfo?.name == null
                    ? null
                    : Text(
                  widget.track.artistInfo!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                leading: TrackPlayButton(
                  track: widget.track,
                  index: widget.index,
                  album: widget.album,
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TrackFavouriteButton(
                      track: widget.track,
                      iconSize: 20.0,
                    ),
                    if (!downloadProvider.isDownloadSong(widget.track))
                      TrackTileActions(
                        child: widget.isDownloadTile == null
                            ? SvgPicture.asset(
                          "assets/icons/svg/download.svg",
                          height: 20,
                          color: Colors.white70,
                        )
                            : const Icon(Icons.close, color: Colors.white70),
                        track: widget.track,
                        title: $t(context, 'download'),
                        isRemove: false,
                      )
                    else
                      TrackTileActions(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white70,
                        ),
                        track: widget.track,
                        title: $t(context, 'remove'),
                        isRemove: true,
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: const Divider(
                  height: 0,
                  color: white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

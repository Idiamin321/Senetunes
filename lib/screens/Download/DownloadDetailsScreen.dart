import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';

import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackBottomBar.dart';
import 'package:senetunes/widgtes/track/TrackFavouriteButton.dart';
import 'package:senetunes/widgtes/track/TrackPlayButton.dart';
import 'package:senetunes/widgtes/track/TrackTileActions.dart';

import '../downloadPlayerScreen.dart';

class DownloadDetailsScreen extends StatefulWidget {
  @override
  _DownloadDetailsScreenState createState() => _DownloadDetailsScreenState();
}

class _DownloadDetailsScreenState extends State<DownloadDetailsScreen>
    with BaseMixins {
  @override
  Widget build(BuildContext context) {
    Album downloadedAlbum = ModalRoute.of(context).settings.arguments;
    print(context.read<PlaylistProvider>().playlists);
    return OfflineBuilder(
        child: SizedBox(),
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget builderChild,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Scaffold(
            backgroundColor: background,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: BaseScreenHeading(
                title: downloadedAlbum.name,
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
        });
  }
}

class TrackContainer extends StatefulWidget {
  TrackContainer(this.downloadedAlbum, this.connected);
  final bool connected;
  final Album downloadedAlbum;

  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  DownloadProvider downloadProvider;
  List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    downloadProvider = context.watch<DownloadProvider>();
    tracks = downloadProvider.downloadSongs
        .where((element) => element.albumId == widget.downloadedAlbum.id)
        .toList();
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: true);
    Track track;
    track = playerProvider.currentTrack;
    return Stack(
        // isLoaded: true,
        children: [
          Container(
            color: background,
            padding: EdgeInsets.only(bottom: track != null ? 50 : 0),
            child: tracks.length > 0
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
                : Container(),
          ),
          widget.connected
              ? track != null
                  ? Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      height: 55,
                      right: 0.0,
                      child: TrackBottomBar())
                  : SizedBox()
              : track != null
                  ? Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      height: 55,
                      right: 0.0,
                      child: playerProvider.isLoading
                          ? SizedBox()
                          : DownloadTrackBottomBar(),
                      // child: !playerProvider.isLoading?SizedBox():DownloadTrackBottomBar(),
                    )
                  : SizedBox(),
        ]);
  }
}

class DownloadTrackBottomBar extends StatefulWidget {
  DownloadTrackBottomBar({Key key}) : super(key: key);

  @override
  _DownloadTrackBottomBarState createState() => _DownloadTrackBottomBarState();
}

class _DownloadTrackBottomBarState extends State<DownloadTrackBottomBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  DownloadProvider downloadProvider;
  List<Track> tracks;

  @override
  void initState() {
    print("download bottommm");
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    return PlayerBuilder.realtimePlayingInfos(
      player: playerProvider.player,
      builder: (context, infos) {
        track = playerProvider.currentTrack;
        downloadProvider = context.watch<DownloadProvider>();
        tracks = downloadProvider.downloadSongs
            .where((element) =>
                element.albumId ==
                (playerProvider.currentAlbum == null
                    ? 0
                    : playerProvider.currentAlbum.id))
            .toList();
        return track != null
            ? GestureDetector(
                onTap: () {
                  print(playerProvider.currentTrack.localPath);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DownloadPlayerScreen(
                        allTracks: downloadProvider.downloadSongs,
                        currentOne: playerProvider.currentTrack,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                    ),
                    // color: background,
                    // color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  // child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                  // child: Container(
                  height: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                        ),
                        child: AnimatedBuilder(
                            animation: _controller,
                            builder: (_, child) {
                              double _angle = _controller.value * 2 * pi;
                              if (!playerProvider.isPlaying()) {
                                _angle = 0.0;
                              }

                              return Transform.rotate(
                                angle: _angle,
                                child: playerProvider.getTrackThumbnail != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: BaseImage(
                                          imageUrl: playerProvider
                                              .getTrackThumbnail(),
                                          width: 40,
                                          height: 40,
                                          radius: 500,
                                        ))
                                    : Icon(
                                        Icons.disc_full,
                                        size: 30,
                                      ),
                              );
                            }),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 8, bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    downloadProvider
                                        .downloadSongs[
                                            playerProvider.currentIndex]
                                        .name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              downloadProvider
                                          .downloadSongs[
                                              playerProvider.currentIndex]
                                          .artistInfo
                                          ?.name !=
                                      null
                                  ? Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          downloadProvider
                                              .downloadSongs[
                                                  playerProvider.currentIndex]
                                              .artistInfo
                                              .name,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.fade,
                                          softWrap: true,
                                          maxFontSize: 11,
                                          minFontSize: 11,
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(SimpleLineIcons.control_rewind),
                              iconSize: 20,
                              color: playerProvider.currentIndex == 0
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).primaryColor,
                              onPressed: () async {
                                print("prevvvvvvvvvv");
                                if (playerProvider.currentIndex != 0)
                                  await playerProvider.handleDownloadPlayButton(
                                      album: playerProvider.currentAlbum,
                                      track: downloadProvider.downloadSongs[
                                          playerProvider.currentIndex - 1],
                                      index: playerProvider.currentIndex - 1,
                                      context: context);
                                // playerProvider.prev();
                              },
                            ),
                            TrackPlayButton(
                              track: downloadProvider
                                  .downloadSongs[playerProvider.currentIndex],
                              // track: track,
                              onPressed: () {
                                playerProvider.playOrPause();
                              },
                            ),
                            IconButton(
                              icon: Icon(SimpleLineIcons.control_forward),
                              color:
                                  downloadProvider.downloadSongs.length - 1 ==
                                          playerProvider.currentIndex
                                      ? Theme.of(context).iconTheme.color
                                      : Theme.of(context).primaryColor,
                              iconSize: 20,
                              onPressed: () async {
                                print("nextttttttttt");
                                // if (playerProvider.isLastTrack(
                                //     playerProvider.currentIndex + 1)) return;
                                // playerProvider.next();
                                if (downloadProvider.downloadSongs.length - 1 !=
                                    playerProvider.currentIndex)
                                  await playerProvider.handleDownloadPlayButton(
                                      album: playerProvider.currentAlbum,
                                      track: downloadProvider.downloadSongs[
                                          playerProvider.currentIndex + 1],
                                      index: playerProvider.currentIndex + 1,
                                      context: context);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ),
                // ),
              )
            : Container();
      },
    );
  }
}

class DownloadTrackTile extends StatefulWidget {
  final bool isDownloadTile;
  final Album album;
  final Track track;
  final int index;
  final List<Track> tracks;

  DownloadTrackTile(
      {this.track, this.index, this.isDownloadTile, this.album, this.tracks});

  @override
  _DownloadTrackTileState createState() => _DownloadTrackTileState();
}

class _DownloadTrackTileState extends State<DownloadTrackTile> with BaseMixins {
  List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    PlayerProvider p = Provider.of<PlayerProvider>(context);
    DownloadProvider downloadProvider = Provider.of<DownloadProvider>(context);
    downloadProvider = context.watch<DownloadProvider>();
    tracks = downloadProvider.downloadSongs
        .where((element) => element.albumId == widget.album.id)
        .toList();
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Container(
          color: background,
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              ListTile(
                tileColor: Colors.black,
                onTap: () {
                  p.setBuffering(widget.index);
                  if (p.isTrackInProgress(widget.track) ||
                      p.isLocalTrackInProgress(widget.track.localPath))
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DownloadPlayerScreen(
                          allTracks: downloadProvider.downloadSongs,
                          currentOne: playerProvider.currentTrack,
                        ),
                      ),
                    );
                  // p.isTrackInProgress(widget.track) ||
                  //     p.isLocalTrackInProgress(widget.track.localPath)
                  //     ? Navigator.of(context).pushNamed(AppRoutes.player)
                  //     : p.handlePlayButton(
                  //   track: widget.track,
                  //   index: widget.index,
                  //   album: widget.album,
                  //   context: context,
                  // );
                },
                title: Text(
                  widget.track.name,
                  maxLines: 2,
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.primary,
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: widget?.track?.artistInfo?.name == null
                    ? null
                    : Text(
                        widget.track.artistInfo.name,
                        maxLines: 1,
                        style: TextStyle(
                            // color: Theme.of(context).colorScheme.primaryVariant
                            color: Colors.white70,
                            fontSize: 11),
                      ),
                leading: TrackPlayButton(
                  track: widget.track,
                  index: widget.index,
                  album: widget.album,
                  // onPressed: (){
                  //   playerProvider.handlePlayButton(
                  //       album: widget.album,
                  //       track: widget.track,
                  //       index: widget.index,
                  //       context: context
                  //     //search results list
                  //   ).then((value) {
                  //     // p.setBuffering(widget.index);
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => DownloadPlayerScreen(
                  //           allTracks: widget.album.tracks,
                  //           currentOne: widget.track,
                  //         ),
                  //       ),
                  //     );
                  //   });
                  // },
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
                          // child: Icon(
                          //   Icons.more_vert,
                          //   color: Theme.of(context).primaryColor,
                          // ),
                          child: widget.isDownloadTile == null
                              ? SvgPicture.asset(
                                  "assets/icons/svg/download.svg",
                                  height: 20,
                                  color: Colors.white70,
                                )
                              : Icon(Icons.close, color: Colors.white70),
                          track: widget.track,
                          title: $t(context, 'download'),
                          isRemove: false,
                          // isRemove: widget.isDownloadTile == null
                          //     ? false
                          //     : widget.isDownloadTile,
                        )
                      else
                        TrackTileActions(
                          child: Icon(
                            Icons.close,
                            color: Colors.white70,
                          ),
                          track: widget.track,
                          title: $t(context, 'remove'),
                          isRemove: true,
                        ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  // color: Theme.of(context).cardColor,
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

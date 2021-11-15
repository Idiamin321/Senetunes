import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/track/TrackPlayButton.dart';

import '../downloadPlayerScreen.dart';

class DownloadScreen extends StatelessWidget with BaseMixins {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      // //backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, 'download'),
          centerTitle: false,
          isBack: true,
        ),
        // child: BaseAppBar(
        //   isHome: false,
        // ),
      ),
      body: Stack(children:[ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: background,
                // color: Theme.of(context).scaffoldBackgroundColor,
                child: TrackContainer(),
              ),
            ),
          ],
        ),

      ]),
    );
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
            .where(
                (element) => element.albumId == playerProvider.currentAlbum.id)
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
                              track.name,
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
                        track?.artistInfo?.name != null
                            ? Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              track.artistInfo.name,
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
                        color: playerProvider.isFirstTrack()
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          // playerProvider.handleDownloadPlayButton(album: playerProvider.currentAlbum, track: playerProvider.currentTrack,index: playerProvider.currentIndex-1,context: context);
                          playerProvider.prev();
                        },
                      ),
                      TrackPlayButton(
                        track: track,
                        onPressed: () => playerProvider.playOrPause(),
                      ),
                      IconButton(
                        icon: Icon(SimpleLineIcons.control_forward),
                        color: playerProvider.isLastTrack(
                            playerProvider.currentIndex + 1)
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        iconSize: 20,
                        onPressed: () {
                          if (playerProvider.isLastTrack(
                              playerProvider.currentIndex + 1)) return;
                          playerProvider.next();
                          // playerProvider.handleDownloadPlayButton(album: playerProvider.currentAlbum, track: playerProvider.currentTrack,index: playerProvider.currentIndex+1,context: context);
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

class TrackContainer extends StatefulWidget with BaseMixins {
  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  DownloadProvider downloadProvider;

  @override
  void initState() {
    super.initState();
    downloadProvider = context.read<DownloadProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    downloadProvider = context.watch<DownloadProvider>();
    return Container(
      padding: EdgeInsets.only(bottom: track != null ? 45 : 10),
      child: downloadProvider.downloadedAlbums.length > 0 &&
              downloadProvider.downloadSongs.length > 0
          ? downloadProvider.isLoaded
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: ScrollController(),
                  itemCount: downloadProvider.downloadedAlbums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context,
                          isSmallPhone: 2, isPhone: 2, isTablet: 4),
                      childAspectRatio: responsive(context,
                          isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        downloadProvider.getDownloads();
                        Navigator.of(context).pushNamed(
                          AppRoutes.downloadDetails,
                          arguments: downloadProvider.downloadedAlbums
                              .elementAt(index),
                        );
                      },
                      child: AlbumTile(
                        album:
                            downloadProvider.downloadedAlbums.elementAt(index),
                        downloadScreen: true,
                      ),
                    );
                  },
                )
              // ? ListView.builder(
              //     itemCount: downloadProvider.downloadSongs.length,
              //     itemBuilder: (context, index) {
              //       _downloadedAlbums
              //           .add(playlistProvider.findAlbum(playlistProvider.findTrack(downloadProvider.downloadSongs[index].name, context), context));
              //       return AlbumTile(
              //         album: _downloadedAlbums.elementAt(index),
              //       );
              //     },
              //   )
              : CustomCircularProgressIndicator()
          : BaseMessageScreen(
              title: $t(context, 'download_empty'),
              icon: Icons.data_usage,
              subtitle: '',
            ),
    );
  }
}

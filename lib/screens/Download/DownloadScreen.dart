import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/track/TrackPlayButton.dart';

import '../downloadPlayerScreen.dart';

class DownloadScreen extends StatelessWidget with BaseMixins {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'download',
          centerTitle: false,
          isBack: true,
        ),
      ),
      body: const Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TrackContainer(),
                ),
              ),
            ],
          ),
        ],
      ),
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
    final playerProvider = context.read<PlayerProvider>();
    return PlayerBuilder.realtimePlayingInfos(
      player: playerProvider.player,
      builder: (context, infos) {
        final Track? track = playerProvider.currentTrack;
        downloadProvider = context.watch<DownloadProvider>();
        final album = playerProvider.currentAlbum;
        final tracks = album == null
            ? const <Track>[]
            : downloadProvider.downloadSongs
            .where((e) => e.albumId == album.id)
            .toList();

        return GestureDetector(
          onTap: () {
            if (playerProvider.currentTrack != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DownloadPlayerScreen(
                    allTracks: downloadProvider.downloadSongs,
                    currentOne: playerProvider.currentTrack!,
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
            padding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
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
                      if (!playerProvider.isPlaying()) angle = 0.0;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              track?.name ?? '',
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
                              track?.artistInfo?.name ?? '',
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
                        icon: const Icon(SimpleLineIcons.control_rewind),
                        iconSize: 20,
                        color: playerProvider.isFirstTrack()
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          playerProvider.prev();
                        },
                      ),
                      TrackPlayButton(
                        track: track,
                        onPressed: () => playerProvider.playOrPause(),
                      ),
                      IconButton(
                        icon: const Icon(SimpleLineIcons.control_forward),
                        color: playerProvider
                            .isLastTrack(playerProvider.currentIndex + 1)
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        iconSize: 20,
                        onPressed: () {
                          if (playerProvider.isLastTrack(
                              playerProvider.currentIndex + 1)) {
                            return;
                          }
                          playerProvider.next();
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

class TrackContainer extends StatefulWidget with BaseMixins {
  const TrackContainer({super.key});

  @override
  State<TrackContainer> createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  late DownloadProvider downloadProvider;

  @override
  void initState() {
    super.initState();
    downloadProvider = context.read<DownloadProvider>();
  }

  @override
  Widget build(BuildContext context) {
    // S'assure que PlayerProvider est présent (non utilisé ici)
    context.read<PlayerProvider>();
    downloadProvider = context.watch<DownloadProvider>();

    return Container(
      padding: const EdgeInsets.only(bottom: 45),
      child: downloadProvider.downloadedAlbums.isNotEmpty &&
          downloadProvider.downloadSongs.isNotEmpty
          ? (downloadProvider.isLoaded
          ? GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: ScrollController(),
        itemCount: downloadProvider.downloadedAlbums.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive(
            context,
            isSmallPhone: 2,
            isPhone: 2,
            isTablet: 4,
          ),
          childAspectRatio: responsive(
            context,
            isPhone: 0.8,
            isSmallPhone: 0.8,
            isTablet: 0.6,
          ),
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              downloadProvider.getDownloads();
              Navigator.of(context).pushNamed(
                AppRoutes.downloadDetails,
                arguments:
                downloadProvider.downloadedAlbums.elementAt(index),
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
          : const CustomCircularProgressIndicator())
          : BaseMessageScreen(
        title: $t(context, 'download_empty'),
        icon: Icons.data_usage,
        subtitle: '',
      ),
    );
  }
}

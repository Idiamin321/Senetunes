import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

import 'TrackPlayButton.dart';

class TrackBottomBar extends StatefulWidget {
  const TrackBottomBar({Key? key}) : super(key: key);

  @override
  _TrackBottomBarState createState() => _TrackBottomBarState();
}

class _TrackBottomBarState extends State<TrackBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    final playerProvider =
    Provider.of<PlayerProvider>(context, listen: false);

    return PlayerBuilder.realtimePlayingInfos(
      player: playerProvider.player,
      builder: (context, infos) {
        final Track track = playerProvider.currentTrack;

        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.player),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              track.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
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
                              track.artistInfo.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxFontSize: 11,
                              minFontSize: 11,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
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
                        color: playerProvider.isLastTrack(
                            playerProvider.currentIndex + 1)
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                        iconSize: 20,
                        onPressed: () {
                          if (playerProvider
                              .isLastTrack(playerProvider.currentIndex + 1)) {
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

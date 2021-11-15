import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

class TrackPlayButton extends StatelessWidget {
  final Function onPressed;
  final Track track;
  final Album album;
  final int index;

  TrackPlayButton({this.onPressed, this.track, this.album, this.index});

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<PlayerProvider>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return SizedBox(
            height: 40,
            width: 40,
            child: !p.isTrackLoaded && p.tIndex == index
                ? Padding(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    padding: EdgeInsets.all(10))
                : IconButton(
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Theme.of(context).primaryColor,
                    icon: (p.isTrackInProgress(track) ||
                            p.isLocalTrackInProgress(track.localPath))
                        ? Icon(
                            AntDesign.pausecircleo,
                            color: Colors.white70,
                          )
                        : Icon(
                            SimpleLineIcons.control_play,
                            color: Colors.white70,
                          ),
                    // icon: Stack(children: [
                    //   BaseImage(
                    //     imageUrl: track.artistInfo.media.thumbnail,
                    //     height: 50,
                    //     width: 50,
                    //     radius: 4,
                    //   ),
                    //   Positioned(
                    //     child: Container(
                    //       height: 50,
                    //       width: 50,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(4),
                    //         color: Colors.black38,
                    //       ),
                    //     ),
                    //   ),
                    //   Positioned(
                    //     child: Container(
                    //       height: 50,
                    //       width: 50,
                    //       alignment: Alignment.center,
                    //       child: p.isTrackInProgress(track) ||
                    //               p.isLocalTrackInProgress(track.localPath)
                    //           ? Icon(
                    //               AntDesign.pausecircleo,
                    //               color: Colors.white70,
                    //             )
                    //           : Icon(
                    //               SimpleLineIcons.control_play,
                    //               color: Colors.white70,
                    //             ),
                    //     ),
                    //   ),
                    // ]),
                    onPressed: () => onPressed != null
                        ? onPressed()
                        : p.handlePlayButton(
                            album: album,
                            track: track,
                            index: index,
                            context: context
                            //search results list
                            ),
                  ),
          );
        });
  }
}

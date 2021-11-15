import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/track/TrackFavouriteButton.dart';
import 'package:senetunes/widgtes/track/TrackTileActions.dart';

import 'TrackPlayButton.dart';

class TrackTile extends StatefulWidget {
  final bool isDownloadTile;
  final Album album;
  final Track track;
  final int index;
  final List<Track> tracks;

  TrackTile(
      {this.track, this.index, this.isDownloadTile, this.album, this.tracks});

  @override
  _TrackTileState createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    PlayerProvider p = Provider.of<PlayerProvider>(context);
    DownloadProvider downloadProvider = Provider.of<DownloadProvider>(context);
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
                  p.isTrackInProgress(widget.track) ||
                          p.isLocalTrackInProgress(widget.track.localPath)
                      ? Navigator.of(context).pushNamed(AppRoutes.player)
                      : p.handlePlayButton(
                          track: widget.track,
                          index: widget.index,
                          album: widget.album,
                          context: context,
                        );
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

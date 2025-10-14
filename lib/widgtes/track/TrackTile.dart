import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
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
  final bool? isDownloadTile;
  final Album? album;
  final Track track;
  final int index;
  final List<Track>? tracks;

  const TrackTile({
    super.key,
    required this.track,
    required this.index,
    this.isDownloadTile,
    this.album,
    this.tracks,
  });

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context);
    final downloadProvider = Provider.of<DownloadProvider>(context);

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
                    Navigator.of(context).pushNamed(AppRoutes.player);
                  } else {
                    p.handlePlayButton(
                      track: widget.track,
                      index: widget.index,
                      album: widget.album,
                      context: context,
                    );
                  }
                },
                title: Text(
                  widget.track.name,
                  maxLines: 2,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: (widget.track.artistInfo?.name == null)
                    ? null
                    : Text(
                  widget.track.artistInfo!.name,
                  maxLines: 1,
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
                        child: (widget.isDownloadTile == null)
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

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlayerProvider.dart';

class TrackPlayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Track track;
  final Album? album;
  final int? index;

  const TrackPlayButton({
    super.key,
    required this.track,
    this.album,
    this.index,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context, listen: false);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        final isLoading = (!p.isTrackLoaded && p.tIndex == index);
        final isCurrent =
            p.isTrackInProgress(track) || p.isLocalTrackInProgress(track.localPath);

        return SizedBox(
          height: 40,
          width: 40,
          child: isLoading
              ? const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(strokeWidth: 1),
          )
              : IconButton(
            padding: EdgeInsets.zero,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            color: Theme.of(context).primaryColor,
            icon: Icon(
              isCurrent ? Icons.pause_circle_outline : Icons.play_arrow,
              color: Colors.white70,
            ),
            onPressed: () {
              if (onPressed != null) {
                onPressed!();
              } else {
                // Comportement par défaut si aucun handler n'est fourni
                if (isCurrent) {
                  p.playOrPause();
                } else {
                  p.handlePlayButton(
                    track: track,
                    index: index ?? 0,
                    album: album,
                    context: context,
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';

class TrackTileActions extends StatelessWidget with BaseMixins {
  final bool isRemove;
  final Track track;
  final String title;

  final Widget child;
  TrackTileActions({
    Key key,
    this.child,
    this.isRemove,
    this.title,
    this.track,
  });

  @override
  Widget build(BuildContext context) {
    DownloadProvider downloadProvider = Provider.of<DownloadProvider>(context);

    return PopupMenuButton<String>(
      child: child,
      onSelected: (String value) {
        if (value == 'download') {
          downloadProvider.downloadAudio(track, context);
        }
        if (value == 'remove') {
          downloadProvider.removeSong(downloadProvider.returnSong(track));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'download',
          child: Text($t(context, 'downloading')),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Artist.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:flutter_rekord_app/widgtes/Track/TrackTile.dart';

class TrakTileForArtist extends StatelessWidget with BaseMixins {
  const TrakTileForArtist({
    Key key,
    @required this.artist,
  }) : super(key: key);

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: artist.tracks != null
                ? ListView.builder(
                    itemCount: artist?.tracks?.length,
                    itemBuilder: (context, index) {
                      return TrackTile(
                        index: index,
                        track: artist?.tracks[index],
                        tracks: artist?.tracks,
                        album: artist?.tracks[index]?.albumInfo,
                      );
                    },
                  )
                : BaseMessageScreen(
                    title: $t(context, 'no_tracks'),
                    icon: Icons.data_usage,
                    subtitle: $t(context, 'msg_no_tracks'),
                  ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/Track/TrackTile.dart';

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
        // Expanded(
        //   child:
          Container(
            child: artist.tracks != null
                ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
        // ),
      ],
    );
  }
}

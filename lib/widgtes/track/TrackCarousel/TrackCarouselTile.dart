import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

import '../TrackPlayButton.dart';

class TrackCarouselTile extends StatelessWidget {
  final Track track;
  final int index;
  final List<Track> tracks;
  final String title;
  const TrackCarouselTile({this.track, this.index, this.tracks, this.title});

  @override
  Widget build(BuildContext context) {
    String _title = title;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: ListTile(
                  leading: Container(
                    width: 100,
                    child: Stack(
                      children: [
                        Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: BaseImage(
                                  imageUrl: track.albumInfo.media.cover,
                                  height: 30,
                                ),
                              ),
                        TrackPlayButton(
                          track: track,
                          index: index,
                          album: track.albumInfo,
                        ),
                      ],
                    ),
                  ),
                  title: Transform(
                    transform: Matrix4.translationValues(-12, 0.0, 0.0),
                    child: Text(track.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                        )),
                  ),
                  subtitle: Transform(
                    transform: Matrix4.translationValues(-12, 0.0, 0.0),
                    child: Text(
                        track.artistInfo.name,
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ),
                  // trailing: track.media != null
                  //     ? Padding(
                  //         padding: EdgeInsets.only(right: 20),
                  //         child: BaseImage(
                  //           imageUrl: track.media.medium,
                  //           height: 30,
                  //         ),
                  //       )
                  //     : SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

class TrackDetailsScreen extends StatelessWidget {
  final Track track;
  const TrackDetailsScreen({Key key, this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(track.name),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: BaseImage(
                      imageUrl: track.albumInfo.media.medium,
                      height: 50,
                      width: 50,
                      radius: 5,
                    ),
              subtitle: Text(track.artistInfo.name),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                track.description,
                style: TextStyle(height: 1.4),
              ),
            )
          ],
        ),
      ),
    );
  }
}

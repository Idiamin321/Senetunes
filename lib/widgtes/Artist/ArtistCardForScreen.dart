import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/screens/Artist/ArtistDetailScreen.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class ArtistCard extends StatelessWidget with BaseMixins {
  final int index;
  final Artist artist;

  ArtistCard({this.index, this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: background,
      child: InkWell(
        // contentPadding: EdgeInsets.zero,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArtistDetailScreen(
                        artist: artist,
                      )));
        },
        child: Column(
          children: [
            BaseImage(
              heroId: artist.id,
              imageUrl: artist.media.thumbnail,
              height: 110,
              width: 110,
              radius: 100,
            ),
            SizedBox(height:5),
            Text(
              artist.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        // title: Text(
        //   artist.name,
        //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
        // ),
        // subtitle: Text(
        //   artist.designation,
        //   style:
        //       TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
        // ),
        // leading:
        // trailing: DropdownButton<String>(
        //   underline: Text(''),
        //   icon: Icon(Icons.more_vert),
        //   items: <String>[$t(context, 'view_artist')].map((String value) {
        //     return new DropdownMenuItem<String>(
        //       value: value,
        //       child: Text(
        //         value,
        //         style: TextStyle(
        //           color: primary,
        //         ),
        //       ),
        //     );
        //   }).toList(),
        //   onChanged: (_) {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 ArtistDetailScreen(artist: artist)));
        //   },
        // ),
      ),
    );
  }
}

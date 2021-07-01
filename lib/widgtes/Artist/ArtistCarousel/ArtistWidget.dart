import 'package:flutter/material.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/screens/Artist/ArtistDetailScreen.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class ArtistWidget extends StatelessWidget {
  final List<Artist> artists;
  final String title;
  ArtistWidget({this.artists, this.title});

  _buildSliderItem(BuildContext context, Artist artist, index, artists, height, width) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ArtistDetailScreen(artist: artist)));
      },
      child: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Column(
                  children: [
                    artist.media.thumbnail == null
                        ? Container()
                        : BaseImage(
                            imageUrl: artist.media.thumbnail,
                            height: 60,
                            width: 60,
                            radius: 50,
                          ),
                    SizedBox(height: 10),
                    Text(
                      artist.name,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        WidgetHeader(title: title, route: AppRoutes.artists),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              return _buildSliderItem(context, artists[index], index, artists, height, width);
            },
          ),
        ),
      ],
    );
  }
}

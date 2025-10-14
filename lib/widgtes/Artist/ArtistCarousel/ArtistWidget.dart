import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/screens/Artist/ArtistDetailScreen.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class ArtistWidget extends StatelessWidget {
  final List<Artist> artists;
  final String title;

  ArtistWidget({this.artists, this.title});

  _buildSliderItem(
      BuildContext context, Artist artist, index, artists, height, width) {
    print(artist.media.thumbnail);
    print(artist.media.medium);
    print(artist.media.cover);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArtistDetailScreen(artist: artist)));
      },
      // child: Column(
      //   children: [
      //     Expanded(
      child: Container(
          width: 130,
          // height:200,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(artist.media.cover)),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.redAccent,
                      ),
                    ),
              SizedBox(height: 10),
              Expanded(
                child: AutoSizeText(
                  artist.name,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxFontSize: 12,
                  style: TextStyle(
                    // fontSize: 12,
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        WidgetHeader(title: title, route: AppRoutes.artists),
        Container(
          height: 160,
          // color: Colors.yellow,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildSliderItem(
                  context, artists[index], index, artists, height, width);
            },
          ),
        ),
      ],
    );
  }
}

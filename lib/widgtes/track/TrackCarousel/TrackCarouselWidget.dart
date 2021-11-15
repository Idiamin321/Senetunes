import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';
import 'package:senetunes/widgtes/common/BaseOverlay.dart';
import 'package:senetunes/widgtes/track/TrackCarousel/TrackCarouselTile.dart';
import 'package:shimmer/shimmer.dart';

class TrackCarouselWidget extends StatefulWidget {
  final List<Track> tracks;
  final title;

  TrackCarouselWidget({this.tracks, this.title}) {
    var random = new Random();

    // Go through all elements.
    for (var i = tracks.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = tracks[i];
      tracks[i] = tracks[n];
      tracks[n] = temp;
    }
  }

  @override
  _TrackCarouselWidgetState createState() => _TrackCarouselWidgetState();
}

class _TrackCarouselWidgetState extends State<TrackCarouselWidget> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int currentImage;

  _buildSliderItem(Track track, index, tracks) {
    return Stack(
      children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: BaseOverlay(
              child: track.albumInfo.media != null &&
                      (track.albumInfo.media.cover != null ||
                          track.albumInfo.media.medium != null ||
                          track.albumInfo.media.thumbnail != null)
                  ? BaseImage(
                      radius: 3,
                      overlay: false,
                      height: 180,
                      imageUrl: track.albumInfo.media.cover != null
                          ? track.albumInfo.media.cover
                          : track.albumInfo.media.medium != null
                              ? track.albumInfo.media.medium
                              : track.albumInfo.media.thumbnail,
                    )
                  : Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
            )),
        // SizedBox(height: 30),
        // widget.title != null
        //     ? TrackCarouselTile(
        //         track: track,
        //         tracks: tracks,
        //         index: index,
        //         title: widget.title,
        //       )
        //     : Container(),
      ],
    );
  }

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            initialPage: 0,
            height: 178,
            onPageChanged: (index, reason) {
              setState(() {
                currentImage = index;
              });
            },
          ),
          itemCount: widget.tracks.length,
          itemBuilder: (BuildContext context, int index) =>InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(
                AppRoutes.albumDetail,
                arguments: widget.tracks[index].albumInfo,
              );
            },
            child: Container(
            child: _buildSliderItem(widget.tracks[index], index, widget.tracks),
          ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3, 4, 5].asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: (currentImage ?? 0) % 5 == entry.key ? 7 : 6,
                height: (currentImage ?? 0) % 5 == entry.key ? 7 : 6,
                margin: EdgeInsets.only(top: 12.0, left: 2.0, right: 2),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 0.5),
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white)
                        .withOpacity(
                            (currentImage ?? 0) % 5 == entry.key ? 0.9 : 0.0)),
              ),
            );
          }).toList(),
          //indicators

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: map<Widget>(widget.tracks, (index, track) {
          //     return Expanded(
          //       child: Container(
          //         width: currentImage == index ? 40 : 20.0,
          //         height: 5.0,
          //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: currentImage == index ? Theme.of(context).primaryColor : Colors.blueGrey,
          //         ),
          //       ),
          //     );
          //   }),
          // ),
        )
      ],
    );
  }
}

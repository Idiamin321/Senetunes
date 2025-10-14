import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class TrackCarouselWidget extends StatefulWidget {
  final List<Track> tracks;
  final String? title;

  TrackCarouselWidget({required this.tracks, this.title, Key? key}) : super(key: key) {
    final random = Random();
    for (var i = tracks.length - 1; i > 0; i--) {
      final n = random.nextInt(i + 1);
      final temp = tracks[i];
      tracks[i] = tracks[n];
      tracks[n] = temp;
    }
  }

  @override
  _TrackCarouselWidgetState createState() => _TrackCarouselWidgetState();
}

class _TrackCarouselWidgetState extends State<TrackCarouselWidget> {
  int currentImage = 0;
  final cs.CarouselController _controller = cs.CarouselController();

  Widget _buildSliderItem(Track track) {
    final cover = track.albumInfo.media.cover;
    final medium = track.albumInfo.media.medium;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: (cover.isNotEmpty || medium.isNotEmpty)
          ? BaseImage(
        radius: 3,
        overlay: false,
        imageUrl: cover.isNotEmpty ? cover : medium,
      )
          : Container(
        height: 180,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        cs.CarouselSlider.builder(
          carouselController: _controller,
          options: cs.CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            initialPage: 0,
            height: 178,
            onPageChanged: (index, reason) => setState(() => currentImage = index),
          ),
          itemCount: widget.tracks.length,
          itemBuilder: (context, index, _) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.albumDetail,
                arguments: widget.tracks[index].albumInfo,
              );
            },
            child: _buildSliderItem(widget.tracks[index]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3, 4, 5].asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: (currentImage % 5 == entry.key) ? 7 : 6,
                height: (currentImage % 5 == entry.key) ? 7 : 6,
                margin: const EdgeInsets.only(top: 12.0, left: 2.0, right: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 0.5),
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(currentImage % 5 == entry.key ? 0.9 : 0.0),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

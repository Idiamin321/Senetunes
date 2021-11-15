import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:shimmer/shimmer.dart';

class BaseImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double radius;
  final int heroId;
  final bool overlay;
  final List<double> overlayStops;
  final double overlayOpacity;

  BaseImage(
      {this.imageUrl,
      this.height,
      this.width,
      this.radius,
      this.heroId,
      overlay,
      overlayStops,
      overlayOpacity})
      : overlay = overlay ?? false,
        overlayStops = overlayStops ?? [0.1, 0.5],
        overlayOpacity = overlayOpacity ?? 0.2;

  _buildOverlay(BuildContext context) => Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: new LinearGradient(
            colors: [
              Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(overlayOpacity),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: overlayStops,
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
          ),
        ),
      );

  _buildImage() => CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.fitHeight,
        height: height,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius != null ? radius : 15)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        width: width,
        placeholder: (context, url) =>
            ClipRRect(
              borderRadius: BorderRadius.circular(radius != null ? radius : 15),
            child:Shimmer(
              enabled: true,
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white70,
                  Colors.white54,
                ],
                stops: [
                  0.1,
                  0.3,
                  0.4,
                ],
                begin: Alignment(-1.0, -0.3),
                end: Alignment(1.0, 0.3),
                tileMode: TileMode.clamp,
              ),
              period: Duration(milliseconds: 800),
                child: Container(
                  height: height,
                  width: double.infinity,
                  color: Colors.red,
                  ),
                // highlightColor: Colors.white,
                // baseColor: Colors.grey[300],

            ),
            // Image.asset(
            //   'assets/images/you.jpg',
            //   fit: BoxFit.fitHeight,
            // ),
        //   ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius != null ? radius : 15),
            child: Image.asset(
              'assets/images/you.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return overlay
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImage(),
              ),
              _buildOverlay(context),
            ],
          )
        : _buildImage();
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BaseImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final double radius;
  final int? heroId;
  final bool overlay;
  final List<double> overlayStops;
  final double overlayOpacity;

  const BaseImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.radius = 10,
    this.heroId,
    this.overlay = false,
    List<double>? overlayStops,
    this.overlayOpacity = 0.2,
  }) : overlayStops = overlayStops ?? const [0.1, 0.5];

  Widget _buildOverlay(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        colors: [
          Theme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(overlayOpacity),
          Theme.of(context).scaffoldBackgroundColor,
        ],
        stops: overlayStops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
      ),
    ),
  );

  Widget _placeholder() => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Container(
      height: height,
      width: width ?? double.infinity,
      color: const Color(0x11000000),
    ),
  );

  Widget _error() => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/you.jpg',
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.fitHeight,
    ),
  );

  Widget _buildImage() {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) return _error();

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitHeight,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, _) => _placeholder(),
      errorWidget: (context, _, __) => _error(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final img = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _buildImage(),
    );

    return overlay ? Stack(children: [img, _buildOverlay(context)]) : img;
  }
}

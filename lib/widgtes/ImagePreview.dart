import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final List<String> images;
  ImagePreview({this.images});
  @override
  Widget build(BuildContext context) {
    return images != null || images.length == 0
        ? Container(
            margin: EdgeInsets.all(0),
            child: Row(
              children: images.length >= 2
                  ? images
                      .getRange(0, 1)
                      .map(
                        (e) => CachedNetworkImage(
                          imageUrl: e,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                      .toList()
                  : [
                      CachedNetworkImage(
                        imageUrl: images[0],
                        fit: BoxFit.fitHeight,
                      ),
                    ],
            ),
          )
        : Container();
  }
}

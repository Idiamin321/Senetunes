import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:shimmer/shimmer.dart';

class ImagePreview extends StatelessWidget {
  final List<String> images;

  ImagePreview({this.images});

  @override
  Widget build(BuildContext context) {
    return images != null || images.length == 0
        ? Container(
            margin: EdgeInsets.only(right: 0),
            // alignment: Alignment.center,
      width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.red,
              // color:background,
              borderRadius: BorderRadius.circular(15),
            ),
            child:
      // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: images.length >= 2
            //       ? images
            //           .getRange(0, 1)
            //           .map(
            //             (e) => ClipRRect(
            //               borderRadius: BorderRadius.circular(15),
            //               child: Container(
            //                 width: 150,
            //                 margin: EdgeInsets.all(0),
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(15),
            //                 ),
            //                 child: CachedNetworkImage(
            //                   imageUrl: e,
            //                   fit: BoxFit.fitWidth,
            //                   imageBuilder: (context, imageProvider) => Container(
            //                     decoration: BoxDecoration(
            //                       borderRadius:
            //                       BorderRadius.all(Radius.circular(15)),
            //                       image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            //                     ),
            //                   ),
            //                   placeholder: (context, url) => ClipRRect(
            //                     borderRadius: BorderRadius.circular(15),
            //                     child: Image.asset('assets/images/you.jpg'),
            //                   ),
            //                   errorWidget: (context, url, error) => ClipRRect(
            //                     borderRadius: BorderRadius.circular(15),
            //                     child: Image.asset('assets/images/you.jpg'),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //           .toList()
            //       : [
            //           ClipRRect(
            //             borderRadius: BorderRadius.circular(15),
            //             child:
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          // height: 140,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: images[0]??"",
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Shimmer(
                                  enabled: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFEBEBF4),
                                      Color(0xFFF4F4F4),
                                      Color(0xFFEBEBF4),
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
                                  period: Duration(milliseconds: 400),
                                ),
                            //     ClipRRect(
                            //   borderRadius: BorderRadius.circular(15),
                            //   child: Image.asset('assets/images/you.jpg',fit:BoxFit.fitWidth),
                            // ),
                            errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset('assets/images/you.jpg',fit:BoxFit.fitWidth),
                            ),
                          ),
                        ),
                      // ),
            //         ],
            // ),
          )
        : Container();
  }
}

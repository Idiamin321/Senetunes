import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';

import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Media.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

import '../../providers/CartProvider.dart';

class CartTile extends StatelessWidget with BaseMixins {
  CartTile({this.album, this.remove});

  final Album album;
  final Function remove;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = context.read<CartProvider>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child:

          // ),
          // Expanded(
          //   flex: 1,
          //   child:
          BaseImage(
            imageUrl: album.media.thumbnail,
            heroId: album.id,
            width: 50,
            height: 50,
            radius: 7,
          ),
          // ),
          Expanded(
            //   flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.5,

              alignment: Alignment.centerLeft,
              // fit: BoxFit.scaleDown,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: white),
                    ),
                    Text(
                      album.artistInfo.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                          text: "${$t(context, "price")}:  ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: "${album.price} €",
                              style: TextStyle(
                                color: primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
          ),
          // ],
          // ),
          // ),
          InkWell(
              child: Icon(
                Icons.close_outlined,
                color: Colors.white70,
                size: 26,
              ),
              onTap: remove),
        ],
      ),
    );
  }
}

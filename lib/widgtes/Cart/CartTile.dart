import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseImage.dart';
import 'package:provider/provider.dart';

import '../../providers/CartProvider.dart';

class CartTile extends StatelessWidget {
  CartTile({this.album, this.remove});
  final Album album;
  final Function remove;
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = context.read<CartProvider>();
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                      child: Icon(
                        Icons.delete_outline,
                        color: primary,
                      ),
                      onTap: remove),
                ),
                Expanded(
                  flex: 1,
                  child: BaseImage(
                    imageUrl: album.media.thumbnail,
                    heroId: album.id,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        album.name,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "${album.price} FCFA",
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/PlayerProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/WidgetHeader.dart';
import 'package:flutter_rekord_app/widgtes/common/BaseImage.dart';
import 'package:provider/provider.dart';

class AlbumsWidget extends StatelessWidget with BaseMixins {
  final List<Album> albums;
  final String title;
  AlbumsWidget({this.title, this.albums});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Column(
        children: [
          WidgetHeader(title: title, route: AppRoutes.albums),
          Expanded(
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  Album album = albums[index];
                  return Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        album.isBought
                            ? Expanded(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        $t(context, "bought"),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 15, color: primary),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: primary,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        Expanded(
                          flex: 15,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                print(album.isBought);
                                print(album.id);
                                var playerProvider =
                                    Provider.of<PlayerProvider>(context, listen: false);

                                playerProvider.currentAlbum = album;

                                Navigator.of(context).pushNamed(
                                  AppRoutes.albumDetail,
                                  arguments: album,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  album.media.thumbnail == null
                                      ? Container()
                                      : BaseImage(
                                          imageUrl: album.media.thumbnail,
                                          height: 100,
                                          width: 100,
                                          radius: 5,
                                        ),
                                  //  albumCard(album.media.thumbnail, 100, 100),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                                    child: Container(
                                      child: Text(
                                        '${album.name}',
                                        softWrap: true,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        !album.isBought
                            ? Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                        EdgeInsets.zero),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                  ),
                                  child: Container(
                                    width: 95,
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              "Ajouter au panier",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "${album.price} €",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<CartProvider>().addAlbum(album);
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

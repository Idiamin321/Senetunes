import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class AlbumsWidget extends StatelessWidget with BaseMixins {
  final List<Album> albums;
  final String title;

  AlbumsWidget({this.title, this.albums});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      child: Column(
        children: [
          WidgetHeader(title: title, route: AppRoutes.albums),
          Expanded(
            child: Container(
              // height:800,color: Colors.red,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  Album album = albums[index];
                  return Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        album.isBought
                            ? Expanded(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        $t(context, "bought"),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: white,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.check_circle,
                                        color: white,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        Expanded(
                          flex: 15,
                          child: InkWell(
                            onTap: () {
                              print(album.isBought);
                              print(album.id);
                              var playerProvider = Provider.of<PlayerProvider>(
                                  context,
                                  listen: false);

                              playerProvider.currentAlbum = album;

                              Navigator.of(context).pushNamed(
                                AppRoutes.albumDetail,
                                arguments: album,
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BaseImage(
                                        imageUrl: album.media.medium,
                                        height: 140,
                                        width: 140,
                                        radius: 15,
                                      ),
                                //  albumCard(album.media.medium, 100, 100),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                                //   child:
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: AutoSizeText(
                                      '${album.name}',
                                      // textAlign: TextAlign.center,
                                      softWrap: true,
                                      maxFontSize: 14,
                                      minFontSize: 14, maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          // fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                        !album.isBought
                            ? Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(EdgeInsets.zero),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Container(
                                      width: 95,
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                "Ajouter au panier",
                                                // textAlign: TextAlign.center,
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
                                      if (context.read<AuthProvider>().user ==
                                          null)
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            title: Center(
                                              child: Icon(
                                                Icons.warning,
                                                size: 30,
                                                color: primary,
                                              ),
                                            ),
                                            content: Text(
                                                "Vous devez être connecté avant d'acheter un album",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.popAndPushNamed(
                                                      context,
                                                      AppRoutes.loginRoute);
                                                },
                                                child: Text(
                                                    $t(
                                                      context,
                                                      'sign_in',
                                                    ),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color: primary)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.popAndPushNamed(
                                                      context,
                                                      AppRoutes.registerRoute);
                                                },
                                                child: Text(
                                                    $t(
                                                      context,
                                                      'create_new_Account',
                                                    ),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color: primary)),
                                              ),
                                            ],
                                          ),
                                        );
                                      else
                                        context
                                            .read<CartProvider>()
                                            .addAlbum(album);
                                    },
                                  ),
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

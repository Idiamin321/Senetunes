import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class AlbumTile extends StatelessWidget with BaseMixins {
  final Album album;
  final bool downloadScreen;

  AlbumTile({this.album, this.downloadScreen});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      // height: 100,
      margin: EdgeInsets.only(left: 10,right:10,top:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child:
            // Row(mainAxisAlignment: MainAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
                BaseImage(
                  heroId: album?.id,
                  imageUrl: album?.media?.thumbnail,
                  height: 250,
                  width: responsive(context,
                      isTablet: 170.0, isPhone: 180.0, isSmallPhone: 135.0),
                  radius: 5.0,
                ),
            //     Positioned(
            //       right: 0,
            //       bottom: 10,
            //       child: PlayerBuilder.isPlaying(
            //         player: context.watch<PlayerProvider>().player,
            //         builder: (context, isPlaying) {
            //           return downloadScreen != null && downloadScreen == true
            //               ? Container()
            //               : IconButton(
            //                   icon: Icon(
            //                     isPlaying &&
            //                             album.id ==
            //                                 context
            //                                     .watch<PlayerProvider>()
            //                                     .currentAlbum
            //                                     .id
            //                         ? AntDesign.pausecircleo
            //                         : AntDesign.playcircleo,
            //                     size: 30,
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   onPressed: () {
            //                     context.read<PlayerProvider>().handlePlayButton(
            //                         album: album,
            //                         track: album.tracks[0],
            //                         index: 0,
            //                         context: context);
            //                   },
            //                 );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          ),
          Expanded(flex:3,
            child: Container(
              // color: Colors.red,height: 90,
              // padding: EdgeInsets.only(top:5, bottom: 0),
              alignment: Alignment.centerLeft,
              child: Text(
                "${album?.name}",maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: white),
              ),
            ),
          ),
          Expanded(
            flex:2,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (downloadScreen == null || downloadScreen == false)
                  Text(
                    '${album.tracks.length} sons',
                    style: TextStyle(
                      fontSize: 12,
                      color:Colors.white70,
                    ),
                  ),
                // SizedBox(width: 5),
                if (!album.isBought)
                // if(true)
                  if (downloadScreen == null || downloadScreen == false)
                    Container(
                      height: 35,
                      width: width * 0.20,

                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 0,horizontal: 2)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Column(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Ajouter au panier",
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "${album.price} €",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          if (context.read<AuthProvider>().user == null)
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                  style:TextStyle(color:Colors.black)
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(context, AppRoutes.loginRoute);
                                    },
                                    child: Text(
                                      $t(
                                        context,
                                        'sign_in',
                                      ),
                                      textAlign: TextAlign.end,
                                      style:TextStyle(color:primary)
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(context, AppRoutes.registerRoute);
                                    },
                                    child: Text(
                                      $t(
                                        context,
                                        'create_new_Account',
                                      ),
                                      textAlign: TextAlign.end,
                                      style:TextStyle(color:primary)
                                    ),
                                  ),
                                ],
                              ),
                            );
                          else
                            context.read<CartProvider>().addAlbum(album);
                        },
                      ),
                    ),
              ],
            ),
          ),
          SizedBox(height:15),
        ],
      ),
    );
  }
}

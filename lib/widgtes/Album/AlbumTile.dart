import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/PlayerProvider.dart';
import 'package:flutter_rekord_app/widgtes/common/BaseImage.dart';
import 'package:provider/provider.dart';

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
      height: 100,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                BaseImage(
                  heroId: album?.id,
                  imageUrl: album?.media?.thumbnail,
                  height: height * 0.2,
                  width: responsive(context, isTablet: 170.0, isPhone: 150.0, isSmallPhone: 135.0),
                  radius: 5.0,
                ),
                Positioned(
                  right: 0,
                  bottom: 10,
                  child: PlayerBuilder.isPlaying(
                    player: context.watch<PlayerProvider>().player,
                    builder: (context, isPlaying) {
                      return downloadScreen != null && downloadScreen == true
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                isPlaying &&
                                        album.id == context.watch<PlayerProvider>().currentAlbum.id
                                    ? AntDesign.pausecircleo
                                    : AntDesign.playcircleo,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                context.read<PlayerProvider>().handlePlayButton(
                                    album: album,
                                    track: album.tracks[0],
                                    index: 0,
                                    context: context);
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "${album?.name}",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (downloadScreen == null || downloadScreen == false)
                  Text(
                    '${album.tracks.length} sons',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                SizedBox(width: 20),
                if (!album.isBought)
                  if (downloadScreen == null || downloadScreen == false)
                    Container(
                      height: 30,
                      width: width * 0.2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Ajouter au panier",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
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
                                      fontSize: 10,
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
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

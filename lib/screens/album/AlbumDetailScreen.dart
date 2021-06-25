import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/PlayerProvider.dart';
import 'package:flutter_rekord_app/widgtes/Album/AlbumFavouriteButton.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseConnectivity.dart';
import 'package:flutter_rekord_app/widgtes/Common/DownloadButton.dart';
import 'package:flutter_rekord_app/widgtes/common/BaseImage.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackTile.dart';
import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatefulWidget {
  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> with BaseMixins {
  double heightScreen;
  double paddingBottom;
  double width;
  final GlobalKey _scaffoldKey = GlobalKey();

  _buildContent(Album album, PlayerProvider playerProvider) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BaseImage(
            imageUrl: album.media.cover,
            height: heightScreen,
            width: width,
            radius: 0,
            overlay: true,
            overlayOpacity: 0.1,
            overlayStops: [0.3, 0.8],
          ),
          Positioned(
            top: heightScreen / 6.5,
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: heightScreen / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                album.name,
                                softWrap: true,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.info_outline,
                                          size: 30,
                                          color: primary,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor:
                                                  Theme.of(context).scaffoldBackgroundColor,
                                              title: Center(
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: 30,
                                                  color: primary,
                                                ),
                                              ),
                                              content: Text(
                                                album.description,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: AlbumFavouriteButton(
                                        iconSize: 25.0,
                                        album: album,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: DownloadButton(
                                        album: album,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                  if (!album.isBought)
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                "Ajouter au panier",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                "${album.price} €",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          context.read<CartProvider>().addAlbum(album);
                                          print(context.read<CartProvider>().cart);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: PlayerBuilder.isPlaying(
                          player: playerProvider.player,
                          builder: (context, isPlaying) {
                            return TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                                  textStyle:
                                      MaterialStateProperty.all(TextStyle(color: Colors.white))),
                              icon: Icon(
                                isPlaying && album.id == playerProvider.currentAlbum.id
                                    ? SimpleLineIcons.control_pause
                                    : SimpleLineIcons.control_play,
                                size: 12,
                              ),
                              label: new Text(
                                $t(context, 'play_tracks'),
                              ),
                              onPressed: () {
                                playerProvider.handlePlayButton(
                                    album: album,
                                    track: album.tracks[0],
                                    index: 0,
                                    context: context);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    bool downloadScreen = false;
    List<Track> downloadedTracks;
    Album album;

    heightScreen = mediaQueryData.size.height;
    paddingBottom = mediaQueryData.padding.bottom;
    width = mediaQueryData.size.width;
    album = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      body: BaseConnectivity(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: BaseAppBar(
                isHome: false,
              ).leadingIcon(
                isCart: false,
                isHome: false,
                cartLength: context.watch<CartProvider>().cart.length,
                context: context,
              ),
              expandedHeight: heightScreen / 2.0,
              pinned: true,
              floating: false,
              elevation: 1,
              snap: false,
              actions: <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildContent(album, playerProvider),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TrackTile(
                    track: album.tracks[index],
                    index: index,
                    album: album,
                  );
                },
                childCount: album.tracks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

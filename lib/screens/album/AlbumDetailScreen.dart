import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumFavouriteButton.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/DownloadButton.dart';
import 'package:senetunes/widgtes/Common/PopOverWidget.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BaseImage(
              imageUrl: album.media.cover,
              height: 250,
              width: width,
              radius: 10,
              overlay: true,
              overlayOpacity: 0.1,
              overlayStops: [0.3, 0.8],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 120,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),

              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.name,
                              softWrap: true, maxLines: 1,
                              // overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: white,
                              ),
                            ),
                            Text(
                              "${album.tracks.length} ${$t(context, 'music')}",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ]),
                    ),
                    if (!album.isBought)
                      Expanded(
                        flex: 3,
                        child: Container(
                          // height: 60,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5, top: 5),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "${album.price} €",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  // style: ButtonStyle(
                                  //   backgroundColor: MaterialStateProperty.all<Color>(
                                  //       Colors.black12),
                                  //   // Theme.of(context).primaryColor),
                                  // ),
                                  child: Wrap(
                                    spacing: 3,
                                    direction: Axis.horizontal,alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    runAlignment: WrapAlignment.end,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/svg/shopping-cart.svg',
                                        height: 16,
                                        color: white,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "Ajouter au panier",
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
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
                              ]),
                        ),
                      ),
                  ],
                ),),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.white70,
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
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: AlbumFavouriteButton(
                              iconSize: 20.0,
                              album: album,
                            ),
                          ),
                          FittedBox(
                              fit: BoxFit.contain,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  // if (GlobalConfiguration().getValue('downloadFirst'))
                                  //   PopOverWidget(
                                  //       key: 'downloadFirst',
                                  //       message:
                                  //       "Ce bouton vous permet de télécharger les Albums que vous avez acheté et de les écouter où vous voulez sans connexion internet",
                                  //       context: context,
                                  //       popoverDirection: PopoverDirection.top);
                                  // else if (album != null)
                                  await context.read<DownloadProvider>().downloadAlbum(album, context);

                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/svg/download.svg",
                                  height: 20,
                                  color: Colors.white70,
                                ),
                              )
                          ),
                        ]),
              ]),
            ),
          ),
          // Positioned(
          //   top: heightScreen / 3.5,
          //   width: width,
          //   child: Container(
          //     color: Colors.red,
          //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //     child: Container(
          //       color: Colors.white,
          //       height: heightScreen / 5.5,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisSize: MainAxisSize.max,
          //         children: [
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Expanded(
          //                   flex: 2,
          //                   child: SizedBox(
          //                     width: MediaQuery.of(context).size.width/2,
          //                     // fit: BoxFit.contain,
          //                     child: Text(
          //                       album.name,
          //                       softWrap: true,
          //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,
          //                       color: white,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: Container(
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                       crossAxisAlignment: CrossAxisAlignment.stretch,
          //                       children: [
          //                         Expanded(
          //                           child: FittedBox(
          //                             fit: BoxFit.contain,
          //                             child: IconButton(
          //                               icon: Icon(
          //                                 Icons.info_outline,
          //                                 size: 30,
          //                                 color: primary,
          //                               ),
          //                               onPressed: () {
          //                                 showDialog(
          //                                   context: context,
          //                                   builder: (context) => AlertDialog(
          //                                     backgroundColor:
          //                                         Theme.of(context).scaffoldBackgroundColor,
          //                                     title: Center(
          //                                       child: Icon(
          //                                         Icons.info_outline,
          //                                         size: 30,
          //                                         color: primary,
          //                                       ),
          //                                     ),
          //                                     content: Text(
          //                                       album.description,
          //                                       textAlign: TextAlign.center,
          //                                     ),
          //                                   ),
          //                                 );
          //                               },
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: FittedBox(
          //                             fit: BoxFit.scaleDown,
          //                             child: AlbumFavouriteButton(
          //                               iconSize: 25.0,
          //                               album: album,
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: FittedBox(
          //                             fit: BoxFit.contain,
          //                             child: DownloadButton(
          //                               album: album,
          //                               context: context,
          //                             ),
          //                           ),
          //                         ),
          //                         if (!album.isBought)
          //                           Expanded(
          //                             flex: 2,
          //                             child: ElevatedButton(
          //                               style: ButtonStyle(
          //                                 backgroundColor: MaterialStateProperty.all<Color>(
          //                                     Theme.of(context).primaryColor),
          //                               ),
          //                               child: Column(
          //                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                 children: [
          //                                   FittedBox(
          //                                     fit: BoxFit.contain,
          //                                     child: Text(
          //                                       "Ajouter au panier",
          //                                       style: TextStyle(
          //                                         color: Colors.white,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                   FittedBox(
          //                                     fit: BoxFit.contain,
          //                                     child: Text(
          //                                       "${album.price} €",
          //                                       style: TextStyle(
          //                                         color: Colors.white,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                               onPressed: () {
          //                                 if (context.read<AuthProvider>().user == null)
          //                                   showDialog(
          //                                     context: context,
          //                                     builder: (context) => AlertDialog(
          //                                       backgroundColor:
          //                                           Theme.of(context).scaffoldBackgroundColor,
          //                                       title: Center(
          //                                         child: Icon(
          //                                           Icons.warning,
          //                                           size: 30,
          //                                           color: primary,
          //                                         ),
          //                                       ),
          //                                       content: Text(
          //                                         "Vous devez être connecté avant d'acheter un album",
          //                                         textAlign: TextAlign.center,
          //                                           style:TextStyle(color:Colors.black)
          //                                       ),
          //                                       actions: [
          //                                         TextButton(
          //                                           onPressed: () {
          //                                             Navigator.popAndPushNamed(
          //                                                 context, AppRoutes.loginRoute);
          //                                           },
          //                                           child: Text(
          //                                             $t(
          //                                               context,
          //                                               'sign_in',
          //                                             ),
          //                                             textAlign: TextAlign.end,
          //                                               style:TextStyle(color:primary)
          //                                           ),
          //                                         ),
          //                                         TextButton(
          //                                           onPressed: () {
          //                                             Navigator.popAndPushNamed(
          //                                                 context, AppRoutes.registerRoute);
          //                                           },
          //                                           child: Text(
          //                                             $t(
          //                                               context,
          //                                               'create_new_Account',
          //                                             ),
          //                                             textAlign: TextAlign.end,
          //                                               style:TextStyle(color:primary)
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   );
          //                                 else
          //                                   context.read<CartProvider>().addAlbum(album);
          //                               },
          //                             ),
          //                           ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               alignment: Alignment.center,
          //               child: PlayerBuilder.isPlaying(
          //                 player: playerProvider.player,
          //                 builder: (context, isPlaying) {
          //                   return TextButton.icon(
          //                     style: ButtonStyle(
          //                         backgroundColor:
          //                             MaterialStateProperty.all(Theme.of(context).primaryColor),
          //                         textStyle:
          //                             MaterialStateProperty.all(TextStyle(color: Colors.white))),
          //                     icon: Icon(
          //                       isPlaying && album.id == playerProvider.currentAlbum.id
          //                           ? SimpleLineIcons.control_pause
          //                           : SimpleLineIcons.control_play,
          //                       size: 12,
          //                     ),
          //                     label: new Text(
          //                       $t(context, 'play_tracks'),
          //                         style:TextStyle(color:white)
          //                     ),
          //                     onPressed: () {
          //                       playerProvider.handlePlayButton(
          //                           album: album,
          //                           track: album.tracks[0],
          //                           index: 0,
          //                           context: context);
          //                     },
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
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
      backgroundColor: background,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, 'albums'),
          centerTitle: true,
          isBack: true,
        ),
      ),
      body: BaseConnectivity(
        child: CustomScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: _buildContent(album, playerProvider),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: album.tracks.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TrackTile(
                        track: album.tracks[index],
                        index: index,
                        album: album,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

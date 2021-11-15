import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/Animations/AnimationRotate.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/DownloadButton.dart';
import 'package:senetunes/widgtes/Common/PopOverWidget.dart';
import 'package:senetunes/widgtes/Playlist/PlaylistChoice.dart';
import 'package:senetunes/widgtes/PositionSeekWidget.dart';
import 'package:senetunes/widgtes/track/TrackFavouriteButton.dart';

class PlayerScreen extends StatefulWidget with BaseMixins {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with BaseMixins, TickerProviderStateMixin {
  AnimationController _musicAnimationController;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _musicAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: Duration(seconds: 3),
    );
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _musicAnimationController.repeat();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _musicAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCart = ModalRoute.of(context).settings.name == AppRoutes.cart;
    Track track;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var playerProvider = Provider.of<PlayerProvider>(context);
    playerProvider.audioSessionListener();
    if (playerProvider.isTrackLoaded == false) Navigator.of(context).pop();

    return Scaffold(
      backgroundColor: background,
      body: PlayerBuilder.realtimePlayingInfos(
        player: playerProvider.player,
        builder: (context, infos) {
          track = playerProvider.currentTrack;
          return SingleChildScrollView(
            child: Column(
              children: [
                PreferredSize(
                  child: Container(
                    color: background,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 20.0, bottom: 10.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/svg/back_arrow.svg",
                            height: 25,
                            color: white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Album",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: white,
                                    ),
                                  ),
                                  Text(
                                    playerProvider.currentAlbum.name,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        !isCart
                            ?
                            // Expanded(
                            //         child:
                            IconButton(
                                padding: EdgeInsets.zero,
                                icon:
                                    context.watch<CartProvider>().cart.length >
                                            0
                                        ? Badge(
                                            position: BadgePosition.topEnd(
                                                top: 10, end: 10),
                                            badgeContent: Text(
                                              context
                                                  .watch<CartProvider>()
                                                  .cart
                                                  .length
                                                  .toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/icons/svg/shopping-cart.svg',
                                              height: 25,
                                            )
                                            // child: Icon(Ionicons.md_cart),
                                            )
                                        : SvgPicture.asset(
                                            'assets/icons/svg/shopping-cart.svg',
                                            height: 25,
                                          ),
                                // : Icon(Ionicons.md_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.cart);
                                },
                                // ),
                              )
                            : SizedBox(
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                  preferredSize: const Size.fromHeight(100),
                ),
                buildTopContainer(
                    height, playerProvider, width, context, track),
                track == null
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: buildCurrentTrackInfo(track),
                      ),
                SizedBox(height: height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: buildTrackProgreesSlider(infos, track, playerProvider),
                ),
                SizedBox(height: height * 0.08),
                buildPlayerActions(
                    height, playerProvider, context, width, track),
                // SizedBox(height: height * 0.08),
                // buildPlayerBttomActions(context, playerProvider, track),
                // width > 500
                //     ? SizedBox(
                //         height: 5,
                //       )
                //     : SizedBox(height: height * 0.02)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentTrackInfo(Track track) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            track.name != null
                ? Expanded(
                    child: Text(
                      track.name,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox(),
            Row(
              children: [
                TrackFavouriteButton(track: track),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (GlobalConfiguration().getValue('playlistFirst'))
                      PopOverWidget(
                          key: 'playlistFirst',
                          message:
                              "Utilisez ce bouton afin de créer une Playlist et d'y ajouter vos musiques",
                          context: context,
                          popoverDirection: PopoverDirection.top);
                    else
                      showDialog(
                          context: context,
                          builder: (context) => PlaylistChoice(track));
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            )
          ],
        ),
        Text(
          track.artistInfo == null ? "" : track.artistInfo.name,
          style: TextStyle(
            fontSize: 14,
            color: white,
          ),
        ),
      ],
    );
  }

  Widget buildTrackProgreesSlider(
      RealtimePlayingInfos infos, Track track, PlayerProvider playerProvider) {
    return infos != null
        ? PositionSeekWidget(
            currentPosition: infos.currentPosition,
            duration: infos.duration,
            seekTo: (to) {
              playerProvider.player.seek(to);
            },
          )
        : Container();
  }

  Widget _buildCircularContainer(double radius) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _musicAnimationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
      builder: (context, child) {
        return Container(
          width: _musicAnimationController.value * radius,
          height: _musicAnimationController.value * radius,
          decoration: BoxDecoration(
            color: primary.withOpacity(1 - _musicAnimationController.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Container buildTopContainer(double height, PlayerProvider playerProvider,
      double width, BuildContext context, Track track) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: height / 3,
      width: height / 3,
      margin: EdgeInsets.symmetric(vertical: 25),
      // color: Colors.red,
      // child:
      // Stack(
      //   children: <Widget>[
      // if (playerProvider.getTrackCover() != null)
      //   BaseImage(
      //     imageUrl: playerProvider.getTrackCover(),
      //     width: width,
      //     height: height,
      //     radius: 0,
      //     overlay: true,
      //     overlayOpacity: 0.1,
      //     overlayStops: [0.0, 0.9],
      //   ),
      //  Container(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      // Expanded(child: SizedBox(height: height * 0.07)),
      // Expanded(
      //   flex: 2,
      //   child: Container(
      //     margin: EdgeInsets.only(right: 12.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Expanded(
      //           child: IconButton(
      //             icon: Icon(
      //               Icons.arrow_back,
      //               color: Colors.white,
      //             ),
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //           ),
      //         ),
      //         Expanded(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: <Widget>[
      //               Expanded(
      //                 child: Text(
      //                   $t(context, 'now_playing'),
      //                   style: TextStyle(fontSize: 12),
      //                 ),
      //               ),
      //               Expanded(child: SizedBox(height: 5)),
      //               Expanded(
      //                 child: Text(playerProvider.currentAlbum.name, style: TextStyle()),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Expanded(
      //           child: TrackTileActions(
      //             title: 'Detail',
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   color: Colors.white.withOpacity(0.1),
      //                   borderRadius: BorderRadius.circular(50.0)),
      //               child: Icon(
      //                 Octicons.info,
      //                 color: Colors.white,
      //               ),
      //             ),
      //             route: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => TrackDetailsScreen(
      //                     track: playerProvider.currentTrack,
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Expanded(
      //   child: SizedBox(height: 30),
      // ),
      child: (playerProvider.getTrackThumbnail != null)
          ? AnimationRotate(
              stop: !playerProvider.isPlaying(),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  _buildCircularContainer(300),
                  _buildCircularContainer(350),
                  _buildCircularContainer(400),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.8),
                          blurRadius: 30.0,
                          spreadRadius: 15,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ],
                      border: Border.all(
                        width: 3,
                        color: primary,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BaseImage(
                        imageUrl: playerProvider.getTrackThumbnail(),
                        width: 220,
                        height: 220,
                        radius: 500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(),
      // Expanded(
      //   child: SizedBox(height: 15),
      // ),
      // Expanded(
      //   child: Text(
      //     track.name,
      //     style: TextStyle(fontSize: height * 0.025),
      //   ),
      // ),
      // Expanded(
      //   child: SizedBox(
      //     height: 6.0,
      //   ),
      // ),
      // if (track?.artistInfo?.name != null)
      //   Expanded(
      //     child: Text(
      //       track.artistInfo.name,
      //       style: TextStyle(fontSize: 14.0),
      //     ),
      //   ),
      // Expanded(
      //   child: SizedBox(height: 6.0),
      // ),
      // ],
      // ),
      //      ),
      //     )
      //   ],
      // ),
    );
  }

  Row buildPlayerActions(double height, PlayerProvider playerProvider,
      BuildContext context, double width, Track track) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(!playerProvider.loopPlaylist && playerProvider.loopMode
              ? Icons.repeat_one
              : Icons.repeat),
          color: activeColor(context, playerProvider.loopMode),
          onPressed: () {
            playerProvider.handleLoop();
          },
        ),
        SizedBox(width: width * 0.05),
        InkWell(
          onTap: () {
            if (playerProvider.currentIndex != 0) playerProvider.prev();
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (-1.svg",
            height: height * 0.04,
            color: playerProvider.isFirstTrack()
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: width * 0.05),
        PlayerBuilder.isPlaying(
            player: playerProvider.player,
            builder: (context, isPlaying) {
              return RawMaterialButton(
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: AnimatedIcon(
                  progress: _iconAnimationController,
                  size: 24,
                  icon: isPlaying
                      ? AnimatedIcons.pause_play
                      : AnimatedIcons.play_pause,
                ),
                // child: Icon(
                //   isPlaying ? Icons.pause : Icons.play_arrow,
                //   color: Colors.white,
                // ),
                onPressed: () async {
                  _iconAnimationController.reverse();
                  playerProvider.playOrPause();
                  // isPlaying
                  //     ? _iconAnimationController.forward()
                  //     : _iconAnimationController.reverse();
                  // _iconAnimationController.repeat();
                  isPlaying
                      ? _musicAnimationController.reset()
                      : _musicAnimationController.repeat();
                },
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              );
            }),
        SizedBox(width: width * 0.05),
        InkWell(
          onTap: () {
            if (playerProvider.isLastTrack(playerProvider.currentIndex + 1))
              return;
            playerProvider.next();
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (2).svg",
            height: height * 0.04,
            color: playerProvider.isLastTrack(playerProvider.currentIndex + 1)
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: width * 0.07),
        DownloadButton(
          context: context,
          track: track,
        )
      ],
    );
  }

  Material buildPlayerBttomActions(
      BuildContext context, PlayerProvider playerProvider, Track track) {
    bool playlistDone;
    bool favDone;
    bool downloadDone;
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          AddToPlaylistButton(
            track: track,
          ),
          TrackFavouriteButton(track: track),
          IconButton(
            icon: Icon(Icons.shuffle),
            color: activeColor(context, playerProvider.shuffled),
            onPressed: () => playerProvider.handleShuffle(),
          ),
          IconButton(
            icon: Icon(!playerProvider.loopPlaylist && playerProvider.loopMode
                ? Icons.repeat_one
                : Icons.repeat),
            color: activeColor(context, playerProvider.loopMode),
            onPressed: () => playerProvider.handleLoop(),
          ),
          DownloadButton(
            context: context,
            track: track,
          )
        ],
      ),
    );
  }
}

class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({Key key, @required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          MaterialIcons.playlist_add,
        ),
        onPressed: () {
          if (GlobalConfiguration().getValue('playlistFirst'))
            PopOverWidget(
                key: 'playlistFirst',
                message:
                    "Utilisez ce bouton afin de créer une Playlist et d'y ajouter vos musiques",
                context: context,
                popoverDirection: PopoverDirection.top);
          else
            showDialog(
                context: context, builder: (context) => PlaylistChoice(track));
        });
  }
}

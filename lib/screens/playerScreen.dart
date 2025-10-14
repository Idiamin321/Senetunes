import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';

import 'package:senetunes/config/AppColors.dart';
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
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with BaseMixins, TickerProviderStateMixin {
  late final AnimationController _musicAnimationController;
  late final AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _musicAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: const Duration(seconds: 3),
    )..repeat();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _musicAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCart =
        ModalRoute.of(context)?.settings.name == AppRoutes.cart;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final playerProvider = context.watch<PlayerProvider>();
    playerProvider.audioSessionListener();
    if (playerProvider.isTrackLoaded == false) {
      Future.microtask(() => Navigator.of(context).pop());
    }

    return Scaffold(
      backgroundColor: background,
      body: PlayerBuilder.realtimePlayingInfos(
        player: playerProvider.player,
        builder: (context, infos) {
          final Track? track = playerProvider.currentTrack;

          return SingleChildScrollView(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: Container(
                    color: background,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 15, top: 20, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                            "assets/icons/svg/back_arrow.svg",
                            height: 25,
                            color: white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Album",
                                  style: TextStyle(fontSize: 14, color: white),
                                ),
                                Text(
                                  playerProvider.currentAlbum?.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isCart)
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: context.watch<CartProvider>().cart.isNotEmpty
                                ? badges.Badge(
                              position: badges.BadgePosition.topEnd(
                                  top: 10, end: 10),
                              badgeContent: Text(
                                context
                                    .watch<CartProvider>()
                                    .cart
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w400),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/svg/shopping-cart.svg',
                                height: 25,
                              ),
                            )
                                : SvgPicture.asset(
                              'assets/icons/svg/shopping-cart.svg',
                              height: 25,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.cart),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),

                // Pochette / disque animé
                buildTopContainer(height, playerProvider, width, context),

                if (track != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildCurrentTrackInfo(track),
                  ),

                SizedBox(height: height * 0.03),

                // Slider progression
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: buildTrackProgressSlider(infos, playerProvider),
                ),

                SizedBox(height: height * 0.08),

                // Boutons player
                buildPlayerActions(
                    height, playerProvider, context, width, track),
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
            Expanded(
              child: Text(
                track.name ?? '',
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 15,
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                TrackFavouriteButton(track: track),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (GlobalConfiguration().getValue('playlistFirst') ==
                        true) {
                      PopOverWidget(
                        key: 'playlistFirst',
                        message:
                        "Utilisez ce bouton afin de créer une Playlist et d'y ajouter vos musiques",
                        context: context,
                        popoverDirection: PopoverDirection.top,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => PlaylistChoice(track),
                      );
                    }
                  },
                  icon: const Icon(Icons.more_vert, color: white),
                ),
              ],
            ),
          ],
        ),
        Text(
          track.artistInfo?.name ?? '',
          style: const TextStyle(fontSize: 14, color: white),
        ),
      ],
    );
  }

  Widget buildTrackProgressSlider(
      RealtimePlayingInfos? infos, PlayerProvider playerProvider) {
    if (infos == null) return const SizedBox.shrink();
    return PositionSeekWidget(
      currentPosition: infos.currentPosition,
      duration: infos.duration,
      seekTo: (to) => playerProvider.player.seek(to),
    );
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
      double width, BuildContext context) {
    final cover = playerProvider.getTrackCover();
    final hasCover = (cover != null && cover.toString().isNotEmpty);

    return Container(
      height: height / 3,
      width: height / 3,
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: hasCover
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
                    spreadRadius: 15.0,
                    offset: const Offset(0.0, 3.0),
                  ),
                ],
                border: Border.all(width: 3, color: primary),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BaseImage(
                  imageUrl: cover,
                  width: 220,
                  height: 220,
                  radius: 500,
                ),
              ),
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Row buildPlayerActions(double height, PlayerProvider playerProvider,
      BuildContext context, double width, Track? track) {
    final disabledColor =
    Theme.of(context).colorScheme.secondary.withOpacity(0.35);
    final enabledColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(!playerProvider.loopPlaylist && playerProvider.loopMode
              ? Icons.repeat_one
              : Icons.repeat),
          color: activeColor(context, playerProvider.loopMode),
          onPressed: () => playerProvider.handleLoop(),
        ),
        SizedBox(width: width * 0.05),
        InkWell(
          onTap: () {
            if (playerProvider.currentIndex != 0) playerProvider.prev();
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (-1).svg",
            height: height * 0.04,
            color: playerProvider.isFirstTrack()
                ? disabledColor
                : enabledColor,
          ),
        ),
        SizedBox(width: width * 0.05),
        PlayerBuilder.isPlaying(
          player: playerProvider.player,
          builder: (context, isPlaying) {
            return RawMaterialButton(
              elevation: 2.0,
              fillColor: enabledColor,
              child: AnimatedIcon(
                progress: _iconAnimationController,
                size: 24,
                icon: isPlaying
                    ? AnimatedIcons.pause_play
                    : AnimatedIcons.play_pause,
              ),
              onPressed: () {
                _iconAnimationController.reverse();
                playerProvider.playOrPause();
                if (isPlaying) {
                  _musicAnimationController.reset();
                } else {
                  _musicAnimationController.repeat();
                }
              },
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
            );
          },
        ),
        SizedBox(width: width * 0.05),
        InkWell(
          onTap: () {
            if (!playerProvider.isLastTrack(playerProvider.currentIndex + 1)) {
              playerProvider.next();
            }
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (2).svg",
            height: height * 0.04,
            color: playerProvider.isLastTrack(playerProvider.currentIndex + 1)
                ? disabledColor
                : enabledColor,
          ),
        ),
        SizedBox(width: width * 0.07),
        DownloadButton(context: context, track: track),
      ],
    );
  }
}

class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({super.key, required this.track});
  final Track? track;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_add, color: white),
      onPressed: () {
        if (GlobalConfiguration().getValue('playlistFirst') == true) {
          PopOverWidget(
            key: 'playlistFirst',
            message:
            "Utilisez ce bouton afin de créer une Playlist et d'y ajouter vos musiques",
            context: context,
            popoverDirection: PopoverDirection.top,
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => PlaylistChoice(track),
          );
        }
      },
    );
  }
}

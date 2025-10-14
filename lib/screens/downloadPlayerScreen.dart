import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/Animations/AnimationRotate.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Playlist/PlaylistChoice.dart';
import 'package:senetunes/widgtes/PositionSeekWidget.dart';
import 'package:senetunes/widgtes/track/TrackFavouriteButton.dart';

var trackName = "";
var artistName = "";

class DownloadPlayerScreen extends StatefulWidget with BaseMixins {
  final List<Track> allTracks;
  final Track currentOne;

  const DownloadPlayerScreen({
    super.key,
    required this.allTracks,
    required this.currentOne,
  });

  @override
  _DownloadPlayerScreenState createState() => _DownloadPlayerScreenState();
}

class _DownloadPlayerScreenState extends State<DownloadPlayerScreen>
    with BaseMixins, TickerProviderStateMixin {
  late AnimationController _musicAnimationController;
  late AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    trackName = widget.currentOne.name ?? '';
    artistName = widget.currentOne.artistInfo?.name ?? '';

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
    final isCart = ModalRoute.of(context)?.settings.name == AppRoutes.cart;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final playerProvider = Provider.of<PlayerProvider>(context);
    playerProvider.audioSessionListener();
    if (playerProvider.isTrackLoaded == false) {
      Future.microtask(() => Navigator.of(context).pop());
    }

    return Scaffold(
      backgroundColor: background,
      body: PlayerBuilder.realtimePlayingInfos(
        player: playerProvider.player,
        builder: (context, infos) {
          final track = playerProvider.currentTrack ?? widget.currentOne;

          return SingleChildScrollView(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: Container(
                    color: background,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 20.0, bottom: 10.0, right: 10),
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
                                const Text("Album",
                                    style:
                                    TextStyle(fontSize: 14, color: white)),
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
                                softWrap: true,
                                style: const TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w400,
                                ),
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
                          const SizedBox(width: 0),
                      ],
                    ),
                  ),
                ),
                buildTopContainer(height, playerProvider, width, context, track),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildCurrentTrackInfo(
                    widget.allTracks[playerProvider.currentIndex],
                    playerProvider,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: buildTrackProgressSlider(infos, track, playerProvider),
                ),
                SizedBox(height: height * 0.08),
                buildPlayerActions(
                    height, playerProvider, context, width, track),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentTrackInfo(Track track, PlayerProvider playerProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.name ?? '',
          overflow: TextOverflow.fade,
          style: const TextStyle(
              fontSize: 15, color: white, fontWeight: FontWeight.w600),
        ),
        Text(
          track.artistInfo?.name ?? '',
          style: const TextStyle(fontSize: 14, color: white),
        ),
      ],
    );
  }

  Widget buildTrackProgressSlider(
      RealtimePlayingInfos? infos, Track track, PlayerProvider playerProvider) {
    return infos != null
        ? PositionSeekWidget(
      currentPosition: infos.currentPosition,
      duration: infos.duration,
      seekTo: (to) => playerProvider.player.seek(to),
    )
        : const SizedBox.shrink();
  }

  Widget _buildCircular(double radius) {
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
    return Container(
      height: height / 3,
      width: height / 3,
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: AnimationRotate(
        stop: !playerProvider.isPlaying(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildCircular(300),
            _buildCircular(350),
            _buildCircular(400),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.8),
                    blurRadius: 30.0,
                    spreadRadius: 15,
                    offset: const Offset(0.0, 3.0),
                  ),
                ],
                border: Border.all(width: 3, color: primary),
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
      ),
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
          iconSize: 32,
          color: activeColor(context, playerProvider.loopMode),
          onPressed: () => playerProvider.handleLoop(),
        ),
        SizedBox(width: width * 0.05),
        InkWell(
          onTap: () {
            if (playerProvider.currentIndex != 0) {
              playerProvider.handleDownloadPlayButton(
                album: widget.allTracks[playerProvider.currentIndex].albumInfo,
                track: widget.allTracks[playerProvider.currentIndex - 1],
                index: playerProvider.currentIndex - 1,
                context: context,
              );
            }
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (-1).svg",
            height: height * 0.04,
            color: playerProvider.currentIndex == 0
                ? Theme.of(context).colorScheme.secondary
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
                icon:
                isPlaying ? AnimatedIcons.pause_play : AnimatedIcons.play_pause,
              ),
              onPressed: () {
                playerProvider.playOrPause();
                _iconAnimationController.reverse();
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
            final nextIndex = playerProvider.currentIndex + 1;
            if (nextIndex < widget.allTracks.length) {
              playerProvider.handleDownloadPlayButton(
                album: widget.allTracks[nextIndex].albumInfo,
                track: widget.allTracks[nextIndex],
                index: nextIndex,
                context: context,
              );
            }
          },
          child: SvgPicture.asset(
            "assets/icons/svg/next (2).svg",
            height: height * 0.04,
            color: playerProvider.currentIndex == widget.allTracks.length - 1
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: width * 0.07),
        SvgPicture.asset("assets/icons/svg/download.svg",
            height: 30, color: Theme.of(context).colorScheme.secondary),
      ],
    );
  }
}

// Utilisé par AddToPlaylistButton plus bas
class AddToPlaylistButton extends StatelessWidget {
  const AddToPlaylistButton({super.key, required this.track});
  final Track track;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(MaterialIcons.playlist_add),
      onPressed: () {
        showDialog(
            context: context, builder: (context) => PlaylistChoice(track));
      },
    );
  }
}

// (les variables globales de l’ancien fichier sont inutiles pour le lecteur)
final AssetsAudioPlayer player = AssetsAudioPlayer();
dynamic directory;
var isLoaded = false;
Future<void> init() async {
  isLoaded = false;
  directory = await getTemporaryDirectory();
  player.playlistAudioFinished.listen((_) {});
  isLoaded = true;
}

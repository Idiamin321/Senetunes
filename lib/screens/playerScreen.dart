import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/PlayerProvider.dart';
import 'package:flutter_rekord_app/screens/Track/TrackDetailsScreen.dart';
import 'package:flutter_rekord_app/widgtes/Album//AlbumTileActions.dart';
import 'package:flutter_rekord_app/widgtes/Common/Animations/AnimationRotate.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseImage.dart';
import 'package:flutter_rekord_app/widgtes/Common/DownloadButton.dart';
import 'package:flutter_rekord_app/widgtes/Common/PopOverWidget.dart';
import 'package:flutter_rekord_app/widgtes/Playlist/PlaylistChoice.dart';
import 'package:flutter_rekord_app/widgtes/PositionSeekWidget.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackFavouriteButton.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget with BaseMixins {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    Track track;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var playerProvider = Provider.of<PlayerProvider>(context);
    playerProvider.audioSessionListener();
    return Scaffold(
      appBar: PreferredSize(
        child: BaseAppBar(
          isHome: false,
        ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: PlayerBuilder.realtimePlayingInfos(
        player: playerProvider.player,
        builder: (context, infos) {
          track = playerProvider.currentTrack;

          return SingleChildScrollView(
            child: Column(
              children: [
                buildTopContainer(height, playerProvider, width, context, track),
                SizedBox(height: height * 0.03),
                buildTrackProgreesSlider(infos, track, playerProvider),
                SizedBox(height: height * 0.08),
                buildPlayerActions(height, playerProvider, context, width),
                SizedBox(height: height * 0.08),
                buildPlayerBttomActions(context, playerProvider, track),
                width > 500
                    ? SizedBox(
                        height: 5,
                      )
                    : SizedBox(height: height * 0.08)
              ],
            ),
          );
        },
      ),
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

  Container buildTopContainer(double height, PlayerProvider playerProvider, double width,
      BuildContext context, Track track) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: isLandscape ? height / 1.35 : height / 2,
      child: Stack(
        children: <Widget>[
          if (playerProvider.getTrackCover() != null)
            BaseImage(
              imageUrl: playerProvider.getTrackCover(),
              width: width,
              height: height,
              radius: 0,
              overlay: true,
              overlayOpacity: 0.1,
              overlayStops: [0.0, 0.9],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(child: SizedBox(height: height * 0.07)),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    $t(context, 'now_playing'),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(child: SizedBox(height: 5)),
                                Expanded(
                                  child: Text(playerProvider.currentAlbum.name, style: TextStyle()),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TrackTileActions(
                              title: 'Detail',
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: Icon(
                                  Octicons.info,
                                  color: Colors.white,
                                ),
                              ),
                              route: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrackDetailsScreen(
                                      track: playerProvider.currentTrack,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(height: 30),
                  ),
                  if (playerProvider.getTrackThumbnail != null)
                    Expanded(
                      flex: 2,
                      child: AnimationRotate(
                        stop: !playerProvider.isPlaying(),
                        child: BaseImage(
                          imageUrl: playerProvider.getTrackThumbnail(),
                          width: 150,
                          height: 150,
                          radius: 100,
                        ),
                      ),
                    ),
                  Expanded(
                    child: SizedBox(height: 15),
                  ),
                  Expanded(
                    child: Text(
                      track.name,
                      style: TextStyle(fontSize: height * 0.025),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 6.0,
                    ),
                  ),
                  if (track?.artistInfo?.name != null)
                    Expanded(
                      child: Text(
                        track.artistInfo.name,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  Expanded(
                    child: SizedBox(height: 6.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildPlayerActions(
      double height, PlayerProvider playerProvider, BuildContext context, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(SimpleLineIcons.control_rewind),
          iconSize: height * 0.04,
          color: playerProvider.isFirstTrack()
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          onPressed: () {
            playerProvider.prev();
          },
        ),
        SizedBox(width: width * 0.09),
        PlayerBuilder.isPlaying(
            player: playerProvider.player,
            builder: (context, isPlaying) {
              return RawMaterialButton(
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  playerProvider.playOrPause();
                },
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              );
            }),
        SizedBox(width: width * 0.09),
        IconButton(
          icon: Icon(SimpleLineIcons.control_forward),
          color: playerProvider.isLastTrack(playerProvider.currentIndex + 1)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          iconSize: height * 0.04,
          onPressed: () {
            if (playerProvider.isLastTrack(playerProvider.currentIndex + 1)) return;
            playerProvider.next();
          },
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
            showDialog(context: context, builder: (context) => PlaylistChoice(track));
        });
  }
}

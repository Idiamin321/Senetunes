import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:senetunes/providers/PlayerProvider.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({
    Key key,
    @required this.playerProvider,
  }) : super(key: key);

  final PlayerProvider playerProvider;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: PlayerBuilder.isPlaying(
          player: playerProvider.player,
          builder: (context, isPlaying) {
            return isPlaying
                ? Card(
                    margin: EdgeInsets.all(0),
                    color: Colors.white.withOpacity(0.5),
                    child: ListTile(
                      leading: ClipRRect(
                        child: Image.asset('assets/images/you.jpg'),
                      ),
                      title: Text('title'),
                      subtitle: Text('artist'),
                      trailing: IconButton(
                          icon: isPlaying
                              ? Icon(AntDesign.pausecircleo)
                              : Icon(
                                  SimpleLineIcons.control_play,
                                ),
                          onPressed: () {
                            print('HELLO');
                            playerProvider.playOrPause();
                          }),
                    ),
                  )
                : Text('');
          },
        ));
  }
}

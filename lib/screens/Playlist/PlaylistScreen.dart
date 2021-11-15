import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/PopOverWidget.dart';
import 'package:senetunes/widgtes/Playlist/PlaylistCard.dart';
import 'package:senetunes/widgtes/Playlist/PlaylistChoice.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:toast/toast.dart';

import '../playerScreen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with BaseMixins {
  PlaylistProvider playlistProvider;
  bool create;
  String playlistName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playlistProvider = context.watch<PlaylistProvider>();
    playlistProvider.getPlaylists();
  }

  @override
  void initState() {
    super.initState();
    playlistProvider = context.read<PlaylistProvider>();
    playlistProvider.getPlaylists();
    create = false;
    playlistName = "";
  }

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    return Scaffold(
      backgroundColor: background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Container(
        margin:EdgeInsets.only(bottom: track != null ? 50 : 10),
        child: InkWell(
        onTap: () async {
          openBottomSheet(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(100),
          ),
          margin: EdgeInsets.only(
              left: 20, right: 20, top: 10),
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          child: Wrap(
            spacing: 8,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: white,
              ),
              Text($t(context, "create_playlist"),
                  style: TextStyle(
                      color: white, fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),),
      // //backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(
            context,
            'playlist',
          ),
          centerTitle: false,
          isBack: true,
        ),
        // child: BaseAppBar(
        //   isHome: false,
        // ),
      ),
      body: BaseConnectivity(
      child: BaseScaffold(
      isLoaded: true,
        child:Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
        margin:EdgeInsets.only(bottom:track!=null?45:10,left:5,right:5,),
                // color: Theme.of(context).scaffoldBackgroundColor,
                color: background,
                child: TrackContainer(),
              ),
            ),
          ],
        ),
      ),),
    );
  }

  openBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: barColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  $t(context, "create_a_playlist"),
                  style: TextStyle(
                    fontSize: 15,
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child:Column(children:[
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   heightFactor: 1,
                  //   child: Text(
                  //     $t(context, 'enter_a_title'),
                  //     style: TextStyle(
                  //       fontFamily: "Montserrat",
                  //       color: Colors.white70,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                  TextField(
                  onChanged: (e) => playlistName = e,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () {
                    print(MediaQuery.of(context).viewPadding.bottom);
                  },
                  decoration: InputDecorationStyle.defaultStyle.copyWith(
                    contentPadding:
                        EdgeInsets.only(right: 25, top: 15, bottom: 15),
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: $t(context, "enter_a_title"),
                  ),
                ),]),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        height: 60,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          $t(context, "add"),
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (playlistName == null) {
                          Toast.show(
                              "Playlist name shouldn't be empty", context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                        } else {
                          playlistProvider.createPlaylist(playlistName);
                          // playlistProvider.addSong(
                          //     playlistName, new Track());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          );
        });
  }
}

class TrackContainer extends StatefulWidget {
  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PlaylistProvider>().getPlaylists();
  }

  @override
  void initState() {
    super.initState();
    context.read<PlaylistProvider>().getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = context.watch<PlaylistProvider>();
    return Container(
      child: playlistProvider.playlistsNames.isNotEmpty
          ? GridView.builder(physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 10.0,bottom:90),
              itemCount: playlistProvider.playlistsNames.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return PlaylistCard(
                  playlistName: playlistProvider.playlistsNames[index],
                  playlistRemove: () {
                    setState(() {
                      playlistProvider.deletePlaylist(
                          playlistProvider.playlistsNames[index]);
                      Navigator.of(context).pop();
                    });
                  },
                );
              })
          : BaseMessageScreen(
              title: $t(context, 'playlist_empty'),
              icon: Icons.playlist_add,
            ),
    );
  }
}

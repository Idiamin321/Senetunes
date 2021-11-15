import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  @override
  _PlaylistDetailsScreenState createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    String playlistName = ModalRoute.of(context).settings.arguments;
    print(context.read<PlaylistProvider>().playlists);
    return Scaffold(
      backgroundColor: background,
      // //backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
      child:BaseScreenHeading(
        title: playlistName,
        centerTitle: false,
        isBack: true,
      ),
      //   child: BaseAppBar(
      //     isHome: false,
      //   ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: background,
              margin: EdgeInsets.symmetric(horizontal: 10),
              // color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(playlistName),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackContainer extends StatefulWidget {
  TrackContainer(this.playlistName);

  final String playlistName;

  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  PlaylistProvider playlistProvider;
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
        padding: EdgeInsets.only(bottom: 0.0),
        child: playlistProvider.playlists[widget.playlistName].length > 0
            ? ListView.builder(
                itemCount: playlistProvider.playlists[widget.playlistName].length,
                itemBuilder: (context, index) {
                  Track track = playlistProvider.findTrack(
                      playlistProvider.playlists[widget.playlistName][index], context);
                  Album album = playlistProvider.findAlbum(track, context);
                  return TrackTile(
                    track: track,
                    index: index,
                    album: album,
                  );
                },
              )
            : Container());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/PlaylistProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScreenHeading.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackTile.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseScreenHeading(
            title: playlistName,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
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
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    playlistProvider = context.watch<PlaylistProvider>();
    playlistProvider.getPlaylists();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playlistProvider = context.read<PlaylistProvider>();
    playlistProvider.getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 0.0),
        child: playlistProvider.playlists[widget.playlistName].length > 0
            ? ListView.builder(
                itemCount: playlistProvider.playlists[widget.playlistName].length,
                itemBuilder: (context, index) {
                  Track track = playlistProvider.findTrack(playlistProvider.playlists[widget.playlistName][index], context);
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

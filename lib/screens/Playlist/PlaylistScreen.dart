import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/PlaylistProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScreenHeading.dart';
import 'package:flutter_rekord_app/widgtes/Playlist/PlaylistCard.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatelessWidget with BaseMixins {
  @override
  Widget build(BuildContext context) {
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
            title: $t(
              context,
              'playlist',
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(),
            ),
          ),
        ],
      ),
    );
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
      padding: EdgeInsets.only(bottom: 0.0),
      child: playlistProvider.playlistsNames.isNotEmpty
          ? GridView.builder(
              itemCount: playlistProvider.playlistsNames.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return PlaylistCard(
                  playlistName: playlistProvider.playlistsNames[index],
                  playlistRemove: () {
                    setState(() {
                      playlistProvider.deletePlaylist(playlistProvider.playlistsNames[index]);
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

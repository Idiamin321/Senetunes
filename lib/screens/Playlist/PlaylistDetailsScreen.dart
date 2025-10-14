import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  @override
  _PlaylistDetailsScreenState createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen>
    with BaseMixins {
  late PlaylistProvider playlistProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playlistProvider = context.watch<PlaylistProvider>();
    // Charge/rafraîchit les playlists
    playlistProvider.getPlaylists();
  }

  @override
  void initState() {
    super.initState();
    // NOTE: read() en initState est OK
    // et on (re)chargera aussi en didChangeDependencies.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistProvider>().getPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String playlistName =
    (ModalRoute.of(context)?.settings.arguments ?? '') as String;

    final tracksNames = playlistProvider.playlists[playlistName] ?? <String>[];

    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: playlistName,
          centerTitle: false,
          isBack: true,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: background,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: tracksNames.isNotEmpty
                  ? ListView.builder(
                itemCount: tracksNames.length,
                itemBuilder: (context, index) {
                  final Track track = playlistProvider.findTrack(
                    tracksNames[index],
                    context,
                  );
                  final Album? album =
                  playlistProvider.findAlbum(track, context);
                  if (album == null) {
                    // ignorer les entrées orphelines
                    return const SizedBox.shrink();
                  }
                  return TrackTile(
                    track: track,
                    index: index,
                    album: album,
                  );
                },
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

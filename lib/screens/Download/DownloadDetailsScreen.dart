import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/DownloadProvider.dart';
import 'package:flutter_rekord_app/providers/PlaylistProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScreenHeading.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackTile.dart';
import 'package:provider/provider.dart';

class DownloadDetailsScreen extends StatefulWidget {
  @override
  _DownloadDetailsScreenState createState() => _DownloadDetailsScreenState();
}

class _DownloadDetailsScreenState extends State<DownloadDetailsScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    Album downloadedAlbum = ModalRoute.of(context).settings.arguments;
    print(context.read<PlaylistProvider>().playlists);
    return Scaffold(
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
            title: downloadedAlbum.name,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(downloadedAlbum),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackContainer extends StatefulWidget {
  TrackContainer(this.downloadedAlbum);

  final Album downloadedAlbum;

  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  DownloadProvider downloadProvider;
  List<Track> tracks;
  @override
  Widget build(BuildContext context) {
    downloadProvider = context.watch<DownloadProvider>();
    tracks = downloadProvider.downloadSongs
        .where((element) => element.albumId == widget.downloadedAlbum.id)
        .toList();
    return Container(
        padding: EdgeInsets.only(bottom: 0.0),
        child: tracks.length > 0
            ? ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: TrackTile(
                          track: tracks[index],
                          index: index,
                          album: widget.downloadedAlbum,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                            child: Icon(
                              Icons.delete_outline,
                              color: primary,
                            ),
                            onTap: () {
                              setState(() {
                                downloadProvider.removeSong(
                                    downloadProvider.returnSong(tracks[index]),
                                    lastSong: tracks.length < 2);
                              });
                            }),
                      ),
                    ],
                  );
                },
              )
            : Container());
  }
}

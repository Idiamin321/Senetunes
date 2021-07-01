import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/ImagePreview.dart';

class PlaylistCard extends StatefulWidget {
  PlaylistCard({this.playlistName, this.playlistRemove});
  final String playlistName;
  final Function playlistRemove;
  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = context.watch<PlaylistProvider>();
    List<String> playlist = playlistProvider.playlists[widget.playlistName];

    return Container(
      height: 200,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.playlistDetails,
            arguments: widget.playlistName,
          );
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        alignment: AlignmentDirectional.topCenter,
                        fit: BoxFit.cover,
                        child: Text(
                          widget.playlistName,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      PopupMenuButton<String>(
                        child: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).primaryColor,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: widget.playlistRemove,
                                child: Text("effacé"),
                              ),
                            ),
                          ];
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: ImagePreview(
                      images: playlist
                          .map((e) =>
                              playlistProvider.findTrack(e, context).albumInfo.media.thumbnail)
                          .toList())),
            ],
          ),
        ),
      ),
    );
  }
}

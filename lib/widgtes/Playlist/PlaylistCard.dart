import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/ImagePreview.dart';

class PlaylistCard extends StatefulWidget {
  const PlaylistCard({Key? key, required this.playlistName, required this.playlistRemove})
      : super(key: key);

  final String playlistName;
  final VoidCallback playlistRemove;

  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();
    final List<String> playlist =
    (playlistProvider.playlists[widget.playlistName] ?? <String>[]);

    final String thumb = playlist.isEmpty
        ? ""
        : playlistProvider
        .findTrack(playlist.first, context)
        .albumInfo
        .media
        .thumbnail;

    return Container(
      height: 200,
      color: background,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.playlistDetails,
            arguments: widget.playlistName,
          );
        },
        child: Card(
          color: background,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ImagePreview(
                  images: [thumb],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  color: background,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          widget.playlistName,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 16,
                            color: white,
                          ),
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
                                child: const Text(
                                  "effacé",
                                  style: TextStyle(color: primary),
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${playlist.length} ${$t(context, "music")}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

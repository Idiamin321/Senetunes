import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/ImagePreview.dart';

class PlaylistCard extends StatefulWidget {
  PlaylistCard({this.playlistName, this.playlistRemove});

  final String playlistName;
  final Function playlistRemove;

  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> with BaseMixins{
  List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = context.watch<PlaylistProvider>();
    List<String> playlist = playlistProvider.playlists[widget.playlistName];
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
                  images:[playlist.length==0?"":playlistProvider
                          .findTrack(playlist[0], context)
                          .albumInfo==null?"you.png":playlistProvider
                      .findTrack(playlist.first, context)
                      .albumInfo
                          .media
                          .thumbnail],

                  // images:playlist
                  //     .map((e) => playlistProvider
                  //         .findTrack(e, context)
                  //         .albumInfo
                  //         .media
                  //         .thumbnail)
                  //     .toList(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                  color: background,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width:70,
                        // alignment: AlignmentDirectional.topCenter,
                        // fit: BoxFit.cover,
                        child:
                        Text(
                          widget.playlistName??"",
                          overflow: TextOverflow.fade,
                          style: TextStyle(
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
                                child: Text(
                                  "effacé",
                                  style: TextStyle(
                                    color: primary,
                                  ),
                                ),
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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.topLeft,
                  child:  Text(
                  "${playlistProvider.playlists[widget.playlistName].length} ${$t(context,"music")}"
                      .toString(),
                  style: TextStyle(color: Colors.white70,
                  fontSize: 12,
                  ),
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/PlaylistProvider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class PlaylistChoice extends StatefulWidget {
  PlaylistChoice(this.track);
  final Track track;

  @override
  _PlaylistChoiceState createState() => _PlaylistChoiceState();
}

class _PlaylistChoiceState extends State<PlaylistChoice> with BaseMixins {
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
    return AlertDialog(
      elevation: 1,
      backgroundColor: Theme.of(context).primaryColor.withRed(230),
      content: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              $t(context, "add_to_playlist"),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
            Expanded(
              child: playlistProvider.playlistsNames.length > 0
                  ? ListView.builder(
                      itemCount: playlistProvider.playlistsNames.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 15, bottom: 3.5),
                          child: InkWell(
                            child: Text(playlistProvider.playlistsNames[index] ?? ""),
                            onTap: () {
                              setState(
                                () {
                                  playlistProvider.addSong(
                                      playlistProvider.playlistsNames[index], widget.track);
                                },
                              );
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
            Container(
              height: 30,
              margin: EdgeInsets.only(top: 6),
              child: !create
                  ? ElevatedButton(
                      child: Text(
                        $t(context, "create_playlist"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            create = true;
                          },
                        );
                      },
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            onChanged: (e) => playlistName = e,
                            decoration: InputDecoration(
                              hintText: $t(context, "enter_playlist_name"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              "Ajouter",
                              style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              if (playlistName == null) {
                                Toast.show("Playlist name shouldn't be empty", context,
                                    duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                              } else {
                                playlistProvider.createPlaylist(playlistName);
                                playlistProvider.addSong(playlistName, widget.track);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

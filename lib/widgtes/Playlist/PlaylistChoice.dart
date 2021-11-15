import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
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
      backgroundColor: white,
      // backgroundColor: Theme.of(context).primaryColor.withRed(230),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              $t(context, "add_to_playlist"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                // color: Colors.white,
                color: primary,
              ),
            ),
            Divider(
              // color: Colors.white,
              color: primary,
              thickness: 2,
            ),
            Expanded(
              child: playlistProvider.playlistsNames.length > 0
                  ? ListView.builder(
                      itemCount: playlistProvider.playlistsNames.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Container(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // CircleAvatar(
                                        //   radius: 10,
                                        //   backgroundColor:
                                        //   Theme.of(context).primaryColor,
                                        //   child:
                                        // ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            playlistProvider
                                                    .playlistsNames[index] ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Icon(
                                          Icons.playlist_add,
                                          color:Theme.of(context).primaryColor,
                                          size: 26,
                                        ),
                                      ]),
                                  Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ]),
                          ),
                          onTap: () {
                            setState(
                              () {
                                playlistProvider.addSong(
                                    playlistProvider.playlistsNames[index],
                                    widget.track);
                              },
                            );
                            Navigator.pop(context);
                          },
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
                          color: white,
                          // color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primary),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            onTap: () {
                              print(MediaQuery.of(context).viewPadding.bottom);
                            },
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              // contentPadding: EdgeInsets.only(right: 25, top: 15, bottom: 15),
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                              hintText: $t(context, "enter_a_title"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              "Ajouter",
                              style: TextStyle(
                                fontSize: 12,
                                color: white,
                                // color: Theme.of(context).primaryColor,
                              ),
                            ),
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(primary),
                            ),
                            onPressed: () {
                              if (playlistName == null || playlistName == "") {
                                Toast.show(
                                    "Playlist name shouldn't be empty", context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.TOP);
                              } else {
                                playlistProvider.createPlaylist(playlistName);
                                playlistProvider.addSong(
                                    playlistName, widget.track);
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

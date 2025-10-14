import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:toast/toast.dart';

class PlaylistChoice extends StatefulWidget {
  const PlaylistChoice(this.track, {Key? key}) : super(key: key);

  final Track track;

  @override
  _PlaylistChoiceState createState() => _PlaylistChoiceState();
}

class _PlaylistChoiceState extends State<PlaylistChoice> with BaseMixins {
  late PlaylistProvider playlistProvider;
  bool create = false;
  String playlistName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playlistProvider = context.watch<PlaylistProvider>();
    playlistProvider.getPlaylists();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistProvider>().getPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final names = playlistProvider.playlistsNames;

    return AlertDialog(
      elevation: 1,
      backgroundColor: white,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'add_to_playlist',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, color: primary),
            ),
            const Divider(color: primary, thickness: 2),
            Expanded(
              child: names.isNotEmpty
                  ? ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final name = names[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        playlistProvider.addSong(name, widget.track);
                      });
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(Icons.playlist_add,
                                color: Theme.of(context).primaryColor, size: 26),
                          ],
                        ),
                        const Divider(height: 1, color: Colors.black),
                      ],
                    ),
                  );
                },
              )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              height: 30,
              child: !create
                  ? ElevatedButton(
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all<Color>(primary),
                ),
                onPressed: () {
                  setState(() => create = true);
                },
                child: const Text('create_playlist', style: TextStyle(color: white)),
              )
                  : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      onChanged: (e) => playlistName = e,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                        hintText: 'enter_a_title',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        backgroundColor: MaterialStateProperty.all<Color>(primary),
                      ),
                      onPressed: () {
                        if (playlistName.trim().isEmpty) {
                          Toast.show("Playlist name shouldn't be empty", context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                        } else {
                          final name = playlistName.trim();
                          playlistProvider.createPlaylist(name);
                          playlistProvider.addSong(name, widget.track);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Ajouter',
                          style: TextStyle(fontSize: 12, color: white)),
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

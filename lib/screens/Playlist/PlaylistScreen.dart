import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Playlist/PlaylistCard.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with BaseMixins {
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
    final PlayerProvider playerProvider =
    Provider.of<PlayerProvider>(context, listen: false);
    final Track? track = playerProvider.currentTrack;

    return Scaffold(
      backgroundColor: background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: InkWell(
          onTap: () async {
            openBottomSheet(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(100),
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            child: Wrap(
              spacing: 8,
              children: const [
                Icon(Icons.add_circle_outline_rounded, color: white),
                Text(
                  'create_playlist',
                  style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'playlist',
          centerTitle: false,
          isBack: true,
        ),
      ),
      body: BaseConnectivity(
        child: BaseScaffold(
          isLoaded: true,
          child: Column(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 45, left: 5, right: 5),
                  child: TrackContainer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: barColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'create_a_playlist',
                  style: TextStyle(fontSize: 15, color: white, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextField(
                  onChanged: (e) => playlistName = e,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(right: 25, top: 15, bottom: 15),
                    hintStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                    hintText: 'enter_a_title',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(100)),
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        height: 60,
                        alignment: Alignment.center,
                        child: const Text('add',
                            style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      onTap: () {
                        if (playlistName.trim().isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        playlistProvider.createPlaylist(playlistName.trim());
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          );
        });
      },
    );
  }
}

class TrackContainer extends StatefulWidget {
  const TrackContainer({Key? key}) : super(key: key);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistProvider>().getPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();
    final names = playlistProvider.playlistsNames;

    return names.isNotEmpty
        ? GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10.0, bottom: 90),
      itemCount: names.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return PlaylistCard(
          playlistName: names[index],
          playlistRemove: () {
            setState(() {
              playlistProvider.deletePlaylist(names[index]);
              Navigator.of(context).pop();
            });
          },
        );
      },
    )
        : BaseMessageScreen(
      title: $t(context, 'playlist_empty'),
      icon: Icons.playlist_add,
    );
  }
}

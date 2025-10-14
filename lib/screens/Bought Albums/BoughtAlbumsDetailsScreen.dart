import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class BoughtAlbumsDetailsScreen extends StatefulWidget {
  @override
  _BoughtAlbumsDetailsScreenState createState() =>
      _BoughtAlbumsDetailsScreenState();
}

class _BoughtAlbumsDetailsScreenState extends State<BoughtAlbumsDetailsScreen>
    with BaseMixins {
  @override
  Widget build(BuildContext context) {
    Album boughtAlbum = ModalRoute.of(context).settings.arguments;
    AlbumProvider p = Provider.of<AlbumProvider>(context);
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    boughtAlbum.tracks.map((e) => {e.displayedName});
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: boughtAlbum.name,
          centerTitle: false,
          isBack: true,
        ),
        // child: BaseAppBar(
        //   isHome: false,
        // ),
      ),
      body: BaseScaffold(
        isLoaded: true,
        child: Padding(
          padding: EdgeInsets.only(
              left: 10, right: 10, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: background,
                  // margin: EdgeInsets.only(
                  //     left: 10, right: 10),
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  child: TrackContainer(boughtAlbum),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackContainer extends StatefulWidget {
  TrackContainer(this.boughtAlbum);

  final Album boughtAlbum;

  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 0.0),
        color: background,
        child: widget.boughtAlbum.tracks.length > 0
            ? ListView.builder(
                itemCount: widget.boughtAlbum.tracks.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: TrackTile(
                          track: widget.boughtAlbum.tracks[index],
                          index: index,
                          album: widget.boughtAlbum,
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container());
  }
}

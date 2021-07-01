import 'package:flutter/material.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class BoughtAlbumsDetailsScreen extends StatefulWidget {
  @override
  _BoughtAlbumsDetailsScreenState createState() => _BoughtAlbumsDetailsScreenState();
}

class _BoughtAlbumsDetailsScreenState extends State<BoughtAlbumsDetailsScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    Album boughtAlbum = ModalRoute.of(context).settings.arguments;
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
            title: boughtAlbum.name,
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(boughtAlbum),
            ),
          ),
        ],
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

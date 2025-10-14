import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';

class BoughtAlbumsScreen extends StatelessWidget with BaseMixins {
  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    return Scaffold(
        backgroundColor: background,
        //backgroundColor: Theme.of(context).cardColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: BaseScreenHeading(
            title: $t(context, 'bought_albums'),
            centerTitle: false,
            isBack: true,
          ),
          // child: BaseAppBar(
          //   isHome: false,
          // ),
        ),
        body: SafeArea(
            child: BaseConnectivity(
                child: BaseScaffold(
          isLoaded: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: background,
                  padding: EdgeInsets.only(bottom: 40),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  child: TrackContainer(),
                ),
              ),
            ],
          ),
        ))));
  }
}

class TrackContainer extends StatefulWidget with BaseMixins {
  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  AlbumProvider albumProvider;

  @override
  Widget build(BuildContext context) {
    albumProvider = context.watch<AlbumProvider>();
    print(albumProvider.boughtAlbums);

    return Container(
      padding: EdgeInsets.only(bottom: 0.0),
      child: albumProvider.boughtAlbums.length > 0
          ? albumProvider.isLoaded
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: ScrollController(),
                  itemCount: albumProvider.boughtAlbums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context,
                          isSmallPhone: 2, isPhone: 2, isTablet: 4),
                      childAspectRatio: responsive(context,
                          isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.boughtAlbumsDetails,
                          arguments:
                              albumProvider.boughtAlbums.elementAt(index),
                        );
                      },
                      child: AlbumTile(
                        album: albumProvider.boughtAlbums.elementAt(index),
                      ),
                    );
                  },
                )
              : CustomCircularProgressIndicator()
          : BaseMessageScreen(
              title: $t(context, 'bought_albums_empty'),
              icon: Icons.money_off,
            ),
    );
  }
}

import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class AlbumsScreen extends StatelessWidget with BaseMixins {
  final ScrollController scrollController = new ScrollController();

  _buildGridItem(BuildContext context, Album album) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.albumDetail,
            arguments: album,
          );
        },
        child: AlbumTile(album: album),
      );

  @override
  Widget build(BuildContext context) {
    AlbumProvider p = Provider.of<AlbumProvider>(context);
    final PlayerProvider playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, "albums"),
          centerTitle: false,
          isBack: true,
        ),
        // child: BaseAppBar(
        //   isHome: false,
        //   // darkMode: context.watch<ThemeProvider>().darkMode,
        // ),
      ),
      // //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
              isLoaded: p.isLoaded,
              child: Padding(
                padding: EdgeInsets.only(left: 15,right:15,bottom:track!=null?50:0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: p.allAlbums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context, isSmallPhone:2, isPhone: 2, isTablet: 4),
                      childAspectRatio:
                          responsive(context, isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return _buildGridItem(context, p.allAlbums[index]);
                  },
                ),
              )),
        ),
      ),
    );
  }
}

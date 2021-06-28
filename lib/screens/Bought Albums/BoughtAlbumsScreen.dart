import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:flutter_rekord_app/widgtes/Album/AlbumTile.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScreenHeading.dart';
import 'package:flutter_rekord_app/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:provider/provider.dart';

class BoughtAlbumsScreen extends StatelessWidget with BaseMixins {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseScreenHeading(title: $t(context, 'bought_albums')),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(),
            ),
          ),
        ],
      ),
    );
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
                      crossAxisCount: responsive(context, isSmallPhone: 2, isPhone: 2, isTablet: 4),
                      childAspectRatio:
                          responsive(context, isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.boughtAlbumsDetails,
                          arguments: albumProvider.boughtAlbums.elementAt(index),
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

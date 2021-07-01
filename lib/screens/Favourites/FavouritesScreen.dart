import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/FavoriteProvider.dart';
import 'package:senetunes/widgtes/Artist/AlbumsList.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class FavouritesScreen extends StatelessWidget with BaseMixins {
  const FavouritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseScreenHeading(title: $t(context, 'fvrt')),
            TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Theme.of(context).primaryColor,
                  ),
                  insets: EdgeInsets.only(left: 13, right: 0, bottom: 0)),
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 20, right: 0, bottom: 0),
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(fontSize: 14),
              unselectedLabelColor: Colors.grey,
              indicatorPadding: EdgeInsets.all(0),
              tabs: [
                Tab(
                  child: Text(
                    $t(context, 'tracks'),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    $t(context, 'albums'),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBarView(
                children: [
                  TrackContainer(favoriteProvider: favoriteProvider),
                  AlbumsList(albums: favoriteProvider.favoriteAlbums),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class TrackContainer extends StatelessWidget with BaseMixins {
  const TrackContainer({
    Key key,
    @required this.favoriteProvider,
  }) : super(key: key);

  final FavoriteProvider favoriteProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: favoriteProvider.favoriteTracks.length > 0
            ? favoriteProvider.isLoaded
                ? ListView.builder(
                    itemCount: favoriteProvider.favoriteTracks.length,
                    itemBuilder: (context, index) {
                      Album album =
                          new Album(name: 'Favourites', tracks: favoriteProvider.favoriteTracks);
                      return TrackTile(
                        track: album.tracks[index],
                        index: index,
                        album: album,
                      );
                    },
                  )
                : CustomCircularProgressIndicator()
            : BaseMessageScreen(
                title: $t(context, 'no_tracks'),
                icon: Icons.data_usage,
                subtitle: $t(context, 'msg_no_tracks'),
              ));
  }
}

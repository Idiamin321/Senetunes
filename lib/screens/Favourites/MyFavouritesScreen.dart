import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/FavoriteProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Artist/AlbumsList.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/BasicAppBar.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class Choice {
  final String title;
  final String image;

  Choice(this.title, this.image);
}

List<Choice> tabs = [
  Choice('tracks', 'assets/images/music.png'),
  Choice('albums', 'assets/images/album.png'),
];

class MyFavouritesScreen extends StatelessWidget with BaseMixins {
  const MyFavouritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: background,
      //backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          centerTitle: false,
          isBack: true,
          title: $t(context, 'fvrt'),
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: true,
            child: Container(
              color: background,

              child: DefaultTabController(
                length: tabs.length,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // BaseScreenHeading(
                    //   title: $t(context, 'fvrt'),
                    //   centerTitle: false,
                    //   isBack: false,
                    // ),
                    TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        // insets: EdgeInsets.only(left: 13, right: 0, bottom: 0),
                      ),
                      isScrollable: true,
                      // labelPadding: EdgeInsets.only(left: 20, right: 0, bottom: 0),
                      // indicatorColor: Theme.of(context).primaryColor,
                      // indicatorWeight: 1.0,
                      // indicatorSize: TabBarIndicatorSize.label,
                      // labelColor: Theme.of(context).primaryColor,
                      // labelStyle: TextStyle(fontSize: 14),
                      // unselectedLabelColor: Colors.grey,
                      // indicatorPadding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.zero,
                      tabs: tabs
                          .map(
                            (Choice tab) => Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 100,
                              color: background,
                              // color: Colors.red,
                              margin: EdgeInsets.only(right: 5, left: 5),
                              child: Tab(
                                // text: tab.title,
                                icon: Stack(children: [
                                  Image.asset(tab.image),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        $t(context, tab.title),
                                        softWrap: true,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          )
                          .toList(),
                      // [
                      //   Tab(
                      //     text: "ss",
                      //     icon: SizedBox(
                      //       width: MediaQuery.of(context).size.width / 2.5,
                      //       child: Image.asset(
                      //         "assets/images/music.png",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      //   Tab(
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width / 2.5,
                      //       child: Text(
                      //         $t(context, 'albums'),
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(color: Theme.of(context).primaryColor),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      // ),
                    ),
                    Expanded(
                        child: Container(
                      color: background,
                      // color: Theme.of(context).scaffoldBackgroundColor,
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
            ),
          ),
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
    final PlayerProvider playerProvider =
    Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: favoriteProvider.favoriteTracks.length > 0
            ? favoriteProvider.isLoaded
                ? ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
                    itemCount: favoriteProvider.favoriteTracks.length,
                    itemBuilder: (context, index) {
                      Album album = new Album(
                          name: 'Favourites',
                          tracks: favoriteProvider.favoriteTracks);
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

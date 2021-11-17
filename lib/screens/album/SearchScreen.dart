import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';

import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/screens/Favourites/FavouritesScreen.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/Search/SearchBox.dart';
import 'package:senetunes/widgtes/common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with BaseMixins {
  String searchKeyword = "";
  List<Track> searchedTracks = [];
  List<Album> searchedAlbums = [];
  bool trackSelected = true;
  bool albumSelected = false;

  List<Choice> tabs = [
    Choice('tracks', 'assets/images/music.png'),
    Choice('albums', 'assets/images/album.png'),
  ];

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = Provider.of<AlbumProvider>(context);

    return
      Scaffold(
      backgroundColor: background,
      body:
      SafeArea(
        child: Center(
          child: Column(
            children: [
              SearchBox(
                onSearch: (s) {
                  setState(() {
                    searchKeyword = s;
                  });
                  if (s.length > 0) {
                    if (trackSelected == true) searchedTracks = albumProvider.searchData(s);
                    if (albumSelected == true) searchedAlbums = albumProvider.searchAlbums(s);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        trackSelected = true;
                        albumSelected = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      height: 100,
                      // color: Colors.red,
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Tab(
                        // text: tab.title,
                        icon: Stack(children: [
                          Image.asset(tabs[0].image),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                $t(context, tabs[0].title),
                                softWrap: true,
                                style: TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          trackSelected ? Positioned(child: Container(color: Theme.of(context).primaryColor, height: 10.0)) :
                          Container(),
                        ]),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        trackSelected = false;
                        albumSelected = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      height: 100,
                      // color: Colors.red,
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Tab(
                        // text: tab.title,
                        icon: Stack(children: [
                          Image.asset(tabs[1].image),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                $t(context, tabs[1].title),
                                softWrap: true,
                                style: TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          albumSelected ? Positioned(child: Container(color: Theme.of(context).primaryColor, height: 10.0)) :
                          Container(),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),

              trackSelected ? Expanded(
                flex: 2,
                child: albumProvider.isLoaded
                    ? searchedTracks.length == 0
                        ? BaseMessageScreen(
                            title: searchKeyword == null || searchKeyword.isEmpty
                                ? trackSelected ? $t(context, 'search_screen_title') : 'Search Albums'
                                : $t(context, 'search_screen_title_not_found'),
                            subtitle: $t(context, 'search_screen_subtitle'),
                            icon: Icons.search,
                          )
                        : ListView.builder(
                            itemCount: searchedTracks.length,
                            itemBuilder: (context, index) {
                              return TrackTile(
                                track: searchedTracks[index],
                                index: index,
                                album: searchedTracks[index].albumInfo,
                              );
                            })
                    : CustomCircularProgressIndicator(),
              ) :
              albumSelected ? Expanded(
                flex: 2,
                child: albumProvider.isLoaded
                    ? searchedAlbums.length == 0
                    ? BaseMessageScreen(
                  title: searchKeyword == null || searchKeyword.isEmpty
                      ? trackSelected ? $t(context, 'search_screen_title') : 'Search Albums'
                      : $t(context, 'search_screen_title_not_found'),
                  subtitle: $t(context, 'search_screen_subtitle'),
                  icon: Icons.search,
                )
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: searchedAlbums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context, isSmallPhone:2, isPhone: 2, isTablet: 4),
                      childAspectRatio:
                      responsive(context, isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return _buildGridItem(context, searchedAlbums[index]);
                  },
                )
                    : CustomCircularProgressIndicator(),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }
}



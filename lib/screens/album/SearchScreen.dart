import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:senetunes/widgtes/Search/SearchBox.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/track/TrackTile.dart';

class Choice {
  final String title;
  final String image;
  const Choice(this.title, this.image);
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with BaseMixins {
  String searchKeyword = "";
  List<Track> searchedTracks = [];
  List<Album> searchedAlbums = [];
  bool trackSelected = true;
  bool albumSelected = false;

  final List<Choice> tabs = const [
    Choice('tracks', 'assets/images/music.png'),
    Choice('albums', 'assets/images/album.png'),
  ];

  Widget _buildGridItem(BuildContext context, Album album) => InkWell(
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
    final albumProvider = context.watch<AlbumProvider>();

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SearchBox(
                onSearch: (s) {
                  setState(() {
                    searchKeyword = s;
                  });
                  if (s.isNotEmpty) {
                    if (trackSelected) {
                      searchedTracks = albumProvider.searchData(s);
                    }
                    if (albumSelected) {
                      searchedAlbums = albumProvider.searchAlbums(s);
                    }
                  } else {
                    searchedTracks = [];
                    searchedAlbums = [];
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Onglet Tracks
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
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Tab(
                        icon: Stack(
                          children: [
                            Image.asset(tabs[0].image),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  $t(context, tabs[0].title),
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            trackSelected
                                ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 10.0,
                                  color: Theme.of(context).primaryColor),
                            )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Onglet Albums
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
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Tab(
                        icon: Stack(
                          children: [
                            Image.asset(tabs[1].image),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  $t(context, tabs[1].title),
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            albumSelected
                                ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 10.0,
                                  color: Theme.of(context).primaryColor),
                            )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Zone résultats
              if (trackSelected)
                Expanded(
                  flex: 2,
                  child: albumProvider.isLoaded
                      ? (searchedTracks.isEmpty
                      ? BaseMessageScreen(
                    title: searchKeyword.isEmpty
                        ? $t(context, 'search_screen_title')
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
                    },
                  ))
                      : const CustomCircularProgressIndicator(),
                )
              else if (albumSelected)
                Expanded(
                  flex: 2,
                  child: albumProvider.isLoaded
                      ? (searchedAlbums.isEmpty
                      ? BaseMessageScreen(
                    title: searchKeyword.isEmpty
                        ? $t(context, 'search_screen_title')
                        : $t(context, 'search_screen_title_not_found'),
                    subtitle: $t(context, 'search_screen_subtitle'),
                    icon: Icons.search,
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchedAlbums.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(
                        context,
                        isSmallPhone: 2,
                        isPhone: 2,
                        isTablet: 4,
                      ),
                      childAspectRatio: responsive(
                        context,
                        isPhone: 0.8,
                        isSmallPhone: 0.8,
                        isTablet: 0.6,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      return _buildGridItem(
                          context, searchedAlbums[index]);
                    },
                  ))
                      : const CustomCircularProgressIndicator(),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/providers/CategoryProvider.dart';
import 'package:flutter_rekord_app/providers/DownloadProvider.dart';
import 'package:flutter_rekord_app/providers/PlaylistProvider.dart';
import 'package:flutter_rekord_app/widgtes/Album/AlbumsWidget.dart';
import 'package:flutter_rekord_app/widgtes/Artist/ArtistCarousel/ArtistWidget.dart';
import 'package:flutter_rekord_app/widgtes/Category/CategoryTile.dart';
import 'package:flutter_rekord_app/widgtes/Category/CategoryWidget.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseConnectivity.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScaffold.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackCarousel/TrackCarouselWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../mixins/BaseMixins.dart';
import '../providers/AlbumProvider.dart';
import '../providers/ArtistProvider.dart';
import '../widgtes/Common/BaseDrawer.dart';

class ExploreScreen extends StatelessWidget with BaseMixins {
  final ScrollController scrollController = new ScrollController();

  void requestStorageAccess() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = context.watch<AlbumProvider>();
    ArtistProvider artistProvider = context.watch<ArtistProvider>();
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    context.read<PlaylistProvider>().getPlaylists();
    requestStorageAccess();
    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
          albumProvider.allAlbums, artistProvider.allArtists);
      context.read<DownloadProvider>().initFlutterDownloader(albumProvider.allTracks);
    }
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BaseAppBar(
            isHome: true,
            logoPath: 'assets/images/logo.png',
            // darkMode: isDark,
          ),
        ),
        drawer: BaseDrawer(),
        body: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: albumProvider.isLoaded && artistProvider.isLoaded,
            // scrollController: scrollController,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Expanded(
                    child: TabBar(tabs: [
                      Column(
                        children: [
                          Expanded(child: Icon(Icons.home)),
                          Expanded(
                            child: Tab(
                              child: Text(
                                $t(context, "home"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.loop,
                            ),
                          ),
                          Expanded(
                            child: Tab(
                              child: Text(
                                $t(context, "categories"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.15,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: ListView(
                            children: [
                              TrackCarouselWidget(
                                title: $t(context, "tracks"),
                                tracks: albumProvider.allTracks,
                              ),
                              AlbumsWidget(
                                title: $t(context, "albums"),
                                albums: albumProvider.allAlbums,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ArtistWidget(
                                title: $t(context, "artists"),
                                artists: artistProvider.allArtists,
                              ),
                              CategoryWidget(
                                title: $t(context, "categories"),
                                categories: categoryProvider.categories,
                              )
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: categoryProvider.categories.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  responsive(context, isSmallPhone: 2, isPhone: 2, isTablet: 4),
                              childAspectRatio: responsive(context,
                                  isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.categoryDetail,
                                  arguments: categoryProvider.categories[index],
                                );
                              },
                              child: CategoryTile(
                                category: categoryProvider.categories[index],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

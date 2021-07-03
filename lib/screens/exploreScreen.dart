import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumsWidget.dart';
import 'package:senetunes/widgtes/Artist/ArtistCarousel/ArtistWidget.dart';
import 'package:senetunes/widgtes/Category/CategoryTile.dart';
import 'package:senetunes/widgtes/Category/CategoryWidget.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/track/TrackCarousel/TrackCarouselWidget.dart';

import '../mixins/BaseMixins.dart';
import '../providers/AlbumProvider.dart';
import '../providers/ArtistProvider.dart';
import '../widgtes/Common/BaseDrawer.dart';

class ExploreScreen extends StatelessWidget with BaseMixins {
  final ScrollController scrollController = new ScrollController();
  void requestStorageAccess() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = context.watch<AlbumProvider>();
    ArtistProvider artistProvider = context.watch<ArtistProvider>();
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    context.read<PlaylistProvider>().getPlaylists();
    requestStorageAccess();
    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateBoughtAlbums(authProvider.boughtAlbumsIds);
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
          albumProvider.allAlbums, artistProvider.allArtists);
      context.read<DownloadProvider>().initFlutterDownloader(albumProvider.allTracks);
    }
    return SafeArea(
      child: Scaffold(
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: ()async {
      //       try {
      //         final directory = await getTemporaryDirectory();
      //         Dio dio = Dio();
      //         Response r = await dio.download("http://www.senetunes.com/download/17c456468621afde34d4a84cbf019ab88d331957", "${directory.path}/temp.mp3");
      //         print(r.statusCode);
      //         final player = AudioPlayer();
      //         var duration = await player.setFilePath(
      //             "${directory.path}/temp.mp3");
      //         await player.play();
      //       } on PlayerException catch(e,t){
      //         await FirebaseCrashlytics.instance.recordError(e, t);
      // }}
      //   ),
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
            isHome: true,
            isLoaded: albumProvider.isLoaded && artistProvider.isLoaded,
            // scrollController: scrollController,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Expanded(
                    child: TabBar(tabs: [
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            size: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Tab(
                            child: Text(
                              $t(context, "home"),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.loop,
                            size: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Tab(
                            child: Text(
                              $t(context, "categories"),
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

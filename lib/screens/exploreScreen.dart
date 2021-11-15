import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/models/Media.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/providers/DownloadLogic.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/PlaylistProvider.dart';
import 'package:senetunes/screens/Favourites/FavouritesScreen.dart';
import 'package:senetunes/screens/MyAccountScreen.dart';
import 'package:senetunes/screens/album/SearchScreen.dart';
import 'package:senetunes/widgtes/Album/AlbumsWidget.dart';
import 'package:senetunes/widgtes/Artist/ArtistCarousel/ArtistWidget.dart';
import 'package:senetunes/widgtes/Category/CategoryTile.dart';
import 'package:senetunes/widgtes/Category/CategoryWidget.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/Search/SearchBox.dart';
import 'package:senetunes/widgtes/track/TrackCarousel/TrackCarouselWidget.dart';

import '../mixins/BaseMixins.dart';
import '../providers/AlbumProvider.dart';
import '../providers/ArtistProvider.dart';
import '../widgtes/Common/BaseDrawer.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

import 'Auth/UserAccountPage.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with BaseMixins {
  final ScrollController scrollController = new ScrollController();

  void requestStorageAccess() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  PageController _pageController = new PageController();

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = context.watch<AlbumProvider>();
    ArtistProvider artistProvider = context.watch<ArtistProvider>();
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    PlayerProvider playerProvider = context.watch<PlayerProvider>();
    DownloadLogic downloadLogic = context.watch<DownloadLogic>();
    downloadLogic.bindBackgroundIsolate();
    context.read<PlaylistProvider>().getPlaylists();
    requestStorageAccess();
    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateBoughtAlbums(authProvider.boughtAlbumsIds);
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
          albumProvider.allAlbums, artistProvider.allArtists);
    }
    Track track;
    track = playerProvider.currentTrack;

    return OfflineBuilder(
        child: SizedBox(),
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity,
            Widget builderChild,) {
          final bool connected = connectivity != ConnectivityResult.none;
          return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        drawerEnableOpenDragGesture: false,
        drawer: BaseDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingNavbar(
          backgroundColor: barColor,
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.only(
              left: 15, right: 15, top: 15, bottom: track != null&&connected ? 60 : 15),
          borderRadius: 100,
          onTap: (int val) {
            print(val);
            // Navigator.pushNamed(context, AppRoutes.userAccountPage);
            albumProvider.changeNav(val);
            _pageController.animateToPage(
              albumProvider.selectedIndex,
              duration: Duration(milliseconds: 150),
              curve: Curves.ease,
            );
            setState(() {});
            //returns tab id which is user tapped
          },
          selectedBackgroundColor: Colors.transparent,
          selectedItemColor: white,
          unselectedItemColor: Colors.grey,
          currentIndex: albumProvider.selectedIndex,
          items: [
            FloatingNavbarItem(
                customWidget: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: SvgPicture.asset(
                    "assets/icons/svg/home (5).svg",
                    height: 18,
                    color: albumProvider.selectedIndex == 0
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
                title: $t(context, 'home')),
            FloatingNavbarItem(
              customWidget: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: SvgPicture.asset(
                  "assets/icons/svg/love (1).svg",
                  height: 16,
                  color: albumProvider.selectedIndex == 1
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
              title: $t(context, "fvrt"),
            ),
            FloatingNavbarItem(
              customWidget: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: SvgPicture.asset(
                  "assets/icons/svg/Nom.svg",
                  height: 18,
                  color: albumProvider.selectedIndex == 2
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
              title: $t(context, "my_account"),
            ),
          ],
        ),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: BaseAppBar(
            isHome: true,
            logoPath: 'assets/images/logo.png',
          ),
        ),
        // drawer: BaseDrawer(),
        body: BaseConnectivity(
          child: BaseScaffold(
              isHome: true,
              isLoaded: albumProvider.isLoaded &&
                  artistProvider.isLoaded &&
                  playerProvider.isLoaded,
              child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  pageSnapping: true,
                  controller: _pageController,
                  onPageChanged: (num) {
                    albumProvider.changeNav(num);
                  },
                  children: [
                    HomeScreen(),
                    FavouritesScreen(),
                    MyAccountScreen()
                  ])),
        ),
      ),
    );});
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = context.watch<AlbumProvider>();
    ArtistProvider artistProvider = context.watch<ArtistProvider>();
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    PlayerProvider playerProvider = context.watch<PlayerProvider>();
    DownloadLogic downloadLogic = context.watch<DownloadLogic>();
    downloadLogic.bindBackgroundIsolate();
    context.read<PlaylistProvider>().getPlaylists();
    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateBoughtAlbums(authProvider.boughtAlbumsIds);
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
          albumProvider.allAlbums, artistProvider.allArtists);
    }
    Track track;
    track = playerProvider.currentTrack;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(100),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    autofocus: false,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(color: Colors.white70),
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SearchScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        EvilIcons.search,
                        color: Colors.white70,
                      ),
                      hintText: 'Recherche...',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(bottom: track != null ? 120 : 70),
                  itemBuilder: (context, index) {
                    return Column(
                      // shrinkWrap: true,
                      children: [
                        TrackCarouselWidget(
                          title: $t(context, "tracks"),
                          tracks: albumProvider.allTracks,
                        ),
                        ArtistWidget(
                          title: $t(context, "artists"),
                          artists: artistProvider.allArtists,
                        ),
                        AlbumsWidget(
                          title: $t(context, "albums"),
                          albums: albumProvider.allAlbums,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CategoryWidget(
                          title: $t(context, "categories"),
                          categories: categoryProvider.categories,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

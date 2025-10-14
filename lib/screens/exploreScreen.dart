import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
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
import 'package:senetunes/widgtes/Category/CategoryWidget.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:senetunes/widgtes/track/TrackCarousel/TrackCarouselWidget.dart';

import '../mixins/BaseMixins.dart';
import '../providers/AlbumProvider.dart';
import '../providers/ArtistProvider.dart';
import '../widgtes/Common/BaseDrawer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with BaseMixins {
  final ScrollController scrollController = ScrollController();
  late PageController _pageController;

  void requestStorageAccess() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = context.watch<AlbumProvider>();
    final artistProvider = context.watch<ArtistProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final authProvider = context.watch<AuthProvider>();
    final playerProvider = context.watch<PlayerProvider>();
    final downloadLogic = context.watch<DownloadLogic>();

    downloadLogic.bindBackgroundIsolate();
    context.read<PlaylistProvider>().getPlaylists();
    requestStorageAccess();

    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateBoughtAlbums(authProvider.boughtAlbumsIds);
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
        albumProvider.allAlbums,
        artistProvider.allArtists,
      );
    }

    final Track? track = playerProvider.currentTrack;

    return OfflineBuilder(
      child: const SizedBox(),
      // connectivity_plus 6.x -> List<ConnectivityResult>
      connectivityBuilder: (BuildContext context,
          List<ConnectivityResult> connectivity, Widget builderChild) {
        final bool connected = !connectivity.contains(ConnectivityResult.none);

        return SafeArea(
          child: Scaffold(
            backgroundColor: background,
            drawerEnableOpenDragGesture: false,
            drawer: const BaseDrawer(),
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: BaseAppBar(
                isHome: true,
                logoPath: 'assets/images/logo.png',
              ),
            ),
            body: Stack(
              children: [
                BaseConnectivity(
                  child: BaseScaffold(
                    isHome: true,
                    isLoaded: albumProvider.isLoaded &&
                        artistProvider.isLoaded &&
                        playerProvider.isLoaded,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (num) {
                        albumProvider.changeNav(num);
                      },
                      children: const [
                        HomeScreen(),
                        FavouritesScreen(),
                        MyAccountScreen(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: connected ? 75 : 15,
                  child: _BottomNavBar(
                    currentIndex: albumProvider.selectedIndex,
                    onTap: (i) {
                      albumProvider.changeNav(i);
                      _pageController.animateToPage(
                        albumProvider.selectedIndex,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.ease,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _item(BuildContext context,
      {required int index, required String asset, required String title}) {
    final bool selected = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                asset,
                height: 18,
                color: selected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _item(context,
              index: 0,
              asset: "assets/icons/svg/home (5).svg",
              title: "Accueil"),
          _item(context,
              index: 1,
              asset: "assets/icons/svg/love (1).svg",
              title: "Favoris"),
          _item(context,
              index: 2, asset: "assets/icons/svg/Nom.svg", title: "Compte"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    final albumProvider = context.watch<AlbumProvider>();
    final artistProvider = context.watch<ArtistProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final authProvider = context.watch<AuthProvider>();
    final playerProvider = context.watch<PlayerProvider>();
    final downloadLogic = context.watch<DownloadLogic>();

    downloadLogic.bindBackgroundIsolate();
    context.read<PlaylistProvider>().getPlaylists();

    if (albumProvider.isLoaded && artistProvider.isLoaded) {
      albumProvider.updateBoughtAlbums(authProvider.boughtAlbumsIds);
      albumProvider.updateTracksAndAlbumsWithArtists(artistProvider.allArtists);
      artistProvider.updateArtistsWithAlbums(albumProvider.allAlbums);
      categoryProvider.updateWithAlbumsAndArtists(
        albumProvider.allAlbums,
        artistProvider.allArtists,
      );
    }

    final Track? track = playerProvider.currentTrack;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(100),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.white70),
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SearchScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  decoration: const InputDecoration(
                    prefixIcon:
                    Icon(EvilIcons.search, color: Colors.white70),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
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
                const SizedBox(height: 10),
                CategoryWidget(
                  title: $t(context, "categories"),
                  categories: categoryProvider.categories,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

/*
 * AppRoutes
 * 
 * Define all routes for our app. We can access route
 * name as [AppRoutes.myRouteName]  anywhere in our app
 * Add or remove routes according to your requiremnts
 *  
 */

import 'package:flutter/material.dart';
import 'package:senetunes/screens/Artist/ArtistDetailScreen.dart';
import 'package:senetunes/screens/Artist/ArtistsScreen.dart';
import 'package:senetunes/screens/Auth/ConfirmationScreen.dart';
import 'package:senetunes/screens/Auth/LoginScreen.dart';
import 'package:senetunes/screens/Auth/RegisterScreen.dart';
import 'package:senetunes/screens/Auth/UserAccountPage.dart';
import 'package:senetunes/screens/Bought%20Albums/BoughtAlbumsDetailsScreen.dart';
import 'package:senetunes/screens/Bought%20Albums/BoughtAlbumsScreen.dart';
import 'package:senetunes/screens/Download/DownloadDetailsScreen.dart';
import 'package:senetunes/screens/Info/AboutUs.dart';
import 'package:senetunes/screens/Info/ContactUs.dart';
import 'package:senetunes/screens/PlayerScreen.dart';
import 'package:senetunes/screens/Playlist/PlaylistDetailsScreen.dart';
import 'package:senetunes/screens/Playlist/PlaylistScreen.dart';
import 'package:senetunes/screens/WebView/WebView.dart';
import 'package:senetunes/screens/album/AlbumDetailScreen.dart';
import 'package:senetunes/screens/album/AlbumsScreen.dart';
import 'package:senetunes/screens/exploreScreen.dart';
import 'package:senetunes/widgtes/Common/BaseAuthCheck.dart';

import '../screens/Cart/Cart.dart';
import '../screens/Category/CategoryDetailScreen.dart';
import '../screens/Category/CategoryScreen.dart';
import '../screens/Download/DownloadScreen.dart';
import '../screens/Favourites/FavouritesScreen.dart';

class AppRoutes {
  static const home = '/home';
  static const albums = '/albums';
  static const albumDetail = '/album';
  static const artists = '/artists';
  static const artist = '/artist';
  static const player = '/player';
  static const loginRoute = '/loginRoute';
  static const registerRoute = '/registerRoute';
  // static const profileEditRoute = '/profileEditRoute';
  static const confirmScreenRoute = '/confirmScreenRoute';
  static const favourites = '/favourites';
  static const userAccountPage = '/userAccountPage';
  static const cart = '/cart';
  static const webView = '/webView';
  static const aboutUs = '/aboutUs';
  static const contactUs = '/contactUs';
  static const downloadScreenRoute = '/downloadScreenRoute';
  static const downloadDetails = '/downloadDetails';
  static const playlistScreen = '/playlistScreen';
  static const playlistDetails = '/playlistDetails';
  static const categoryScreen = '/categoryScreen';
  static const categoryDetail = '/categoryDetail';
  static const boughtAlbumsScreenRoute = '/boughtAlbumsScreenRoute';
  static const boughtAlbumsDetails = '/boughtAlbumsDetails';
  Map<String, WidgetBuilder> routes() {
    return {
      home: (context) => ExploreScreen(),
      albums: (context) => AlbumsScreen(),
      albumDetail: (context) => AlbumDetailScreen(),
      player: (context) => PlayerScreen(),
      artists: (context) => ArtistsScreen(),
      artist: (context) => ArtistDetailScreen(),
      loginRoute: (context) => BaseAuthCheck(
            redirect: ExploreScreen(),
            child: LoginScreen(),
          ),
      registerRoute: (context) => BaseAuthCheck(
            redirect: ExploreScreen(),
            child: RegisterScreen(),
          ),
      // profileEditRoute: (context) => ProfileEditPage(),
      confirmScreenRoute: (context) => ConfirmationScreen(),
      favourites: (context) => FavouritesScreen(),
      userAccountPage: (context) => UserAccountPage(),
      cart: (context) => Cart(),
      webView: (context) => WebViewCart(),
      aboutUs: (context) => AboutUs(),
      contactUs: (context) => ContactUs(),
      downloadScreenRoute: (context) => DownloadScreen(),
      downloadDetails: (context) => DownloadDetailsScreen(),
      playlistScreen: (context) => PlaylistScreen(),
      playlistDetails: (context) => PlaylistDetailsScreen(),
      categoryScreen: (context) => CategoryScreen(),
      categoryDetail: (context) => CategoryDetailScreen(),
      boughtAlbumsScreenRoute: (context) => BoughtAlbumsScreen(),
      boughtAlbumsDetails: (context) => BoughtAlbumsDetailsScreen()
    };
  }
}

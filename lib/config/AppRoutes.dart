/*
 * AppRoutes
 * 
 * Define all routes for our app. We can access route
 * name as [AppRoutes.myRouteName]  anywhere in our app
 * Add or remove routes according to your requiremnts
 *  
 */

import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/screens/Artist/ArtistDetailScreen.dart';
import 'package:flutter_rekord_app/screens/Artist/ArtistsScreen.dart';
import 'package:flutter_rekord_app/screens/Auth/ConfirmationScreen.dart';
import 'package:flutter_rekord_app/screens/Auth/LoginScreen.dart';
import 'package:flutter_rekord_app/screens/Auth/ProfileEditScreen.dart';
import 'package:flutter_rekord_app/screens/Auth/RegisterScreen.dart';
import 'package:flutter_rekord_app/screens/Auth/UserAccountPage.dart';
import 'package:flutter_rekord_app/screens/Download/DownloadDetailsScreen.dart';
import 'package:flutter_rekord_app/screens/Info/AboutUs.dart';
import 'package:flutter_rekord_app/screens/Info/ContactUs.dart';
import 'package:flutter_rekord_app/screens/PlayerScreen.dart';
import 'package:flutter_rekord_app/screens/Playlist/PlaylistDetailsScreen.dart';
import 'package:flutter_rekord_app/screens/WebView/WebView.dart';
import 'package:flutter_rekord_app/screens/album/AlbumDetailScreen.dart';
import 'package:flutter_rekord_app/screens/album/AlbumsScreen.dart';
import 'package:flutter_rekord_app/screens/exploreScreen.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAuthCheck.dart';

import 'file:///D:/Freelancing/Reskin%20and%20add%20payment%20gateway%20in%20Flutter%20app/My%20app/rekord-flutter-master/lib/screens/Playlist/PlaylistScreen.dart';

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
  static const profileEditRoute = '/profileEditRoute';
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
      profileEditRoute: (context) => ProfileEditPage(),
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
    };
  }
}

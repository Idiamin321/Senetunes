import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:flutter_rekord_app/providers/ArtistProvider.dart';
import 'package:flutter_rekord_app/providers/AuthProvider.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/CategoryProvider.dart';
import 'package:flutter_rekord_app/providers/FavoriteProvider.dart';
import 'package:flutter_rekord_app/providers/PlayerProvider.dart';
import 'package:flutter_rekord_app/providers/ThemeProvider.dart';
import 'package:flutter_rekord_app/providers/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/DownloadProvider.dart';
import '../providers/PlaylistProvider.dart';
/*
 *  Providers
 * 
 *  List of provider that we want to init on app start
 *  you can add or remove provider according to your 
 *  requirments. Or you can use provider on any build
 *  widget. Please check providers docs for more details
 *   
 *  https://pub.dev/packages/provider
 */

List<SingleChildWidget> providers() {
  return [
    ChangeNotifierProvider<PlayerProvider>(
      create: (_) => PlayerProvider(),
    ),
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider<AlbumProvider>(
      create: (context) => AlbumProvider(),
    ),
    ChangeNotifierProvider<ArtistProvider>(
      create: (context) => ArtistProvider(),
    ),
    ChangeNotifierProvider<CategoryProvider>(
      create: (context) => CategoryProvider(),
    ),
    ChangeNotifierProvider<UsersProvider>(
      create: (context) => UsersProvider(),
    ),
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider<FavoriteProvider>(
      create: (context) => FavoriteProvider(),
    ),
    ChangeNotifierProvider<CartProvider>(
      create: (context) => CartProvider(),
    ),
    ChangeNotifierProvider<DownloadProvider>(
      create: (context) => DownloadProvider(),
    ),
    ChangeNotifierProvider<PlaylistProvider>(
      create: (context) => PlaylistProvider(),
    ),
  ];
}

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/providers/ArtistProvider.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/providers/FavoriteProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/ThemeProvider.dart';
import 'package:senetunes/providers/UsersProvider.dart';

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
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
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

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/CartProvider.dart';

class BaseDrawer extends StatelessWidget with BaseMixins {
  Widget leadingIcon({int cartLength}) {
    return cartLength > 0
        ? Badge(
            position: BadgePosition.topEnd(top: 10, end: 10),
            badgeContent: Text(cartLength.toString()),
            child: Icon(Ionicons.md_cart))
        : Icon(Ionicons.md_cart);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            ListTile(
              leading: leadingIcon(cartLength: context.watch<CartProvider>().cart.length),
              title: Text(
                $t(
                  context,
                  'cart',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
            ),
            ListTile(
              leading: Icon(Entypo.modern_mic),
              title: Text(
                $t(
                  context,
                  'artists',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.artists);
              },
            ),
            ListTile(
              leading: Icon(Entypo.folder_music),
              title: Text(
                $t(
                  context,
                  'all_songs',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.albums);
              },
            ),
            ListTile(
              leading: Icon(MaterialCommunityIcons.playlist_music),
              title: Text(
                $t(
                  context,
                  'playlist',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.playlistScreen);
              },
            ),
            ListTile(
              leading: Icon(Octicons.heart),
              title: Text(
                $t(
                  context,
                  'fvrt',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.favourites);
              },
            ),
            ListTile(
              leading: Icon(Foundation.download),
              title: Text(
                $t(
                  context,
                  'downloads',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.downloadScreenRoute);
              },
            ),
            ListTile(
              leading: Icon(MaterialIcons.attach_money),
              title: Text(
                $t(
                  context,
                  'bought_albums',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
              },
            ),
            ListTile(
              leading: Icon(Ionicons.ios_options),
              title: Text(
                $t(
                  context,
                  'settings',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.userAccountPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}

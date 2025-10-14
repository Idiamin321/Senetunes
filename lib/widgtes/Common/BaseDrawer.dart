import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/CartProvider.dart';

class BaseDrawer extends StatelessWidget with BaseMixins {
  Widget leadingIcon({int cartLength}) {
    return cartLength > 0
        ? badges.Badge(
      position: badges.BadgePosition.topEnd(top: 10, end: 10),
      badgeContent: Text(
        cartLength.toString(),
        softWrap: true,
        style: const TextStyle(
          color: white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
      child: const Icon(Ionicons.md_cart, color: primary),
    )
        : const Icon(Ionicons.md_cart, color: primary);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
          ListTile(
            leading: leadingIcon(
              cartLength: context.watch<CartProvider>().cart.length,
            ),
            title: Text($t(context, 'cart'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          ListTile(
            leading: const Icon(Entypo.modern_mic, color: primary),
            title: Text($t(context, 'artists'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.artists);
            },
          ),
          ListTile(
            leading: const Icon(Entypo.folder_music, color: primary),
            title: Text($t(context, 'all_songs'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.albums);
            },
          ),
          ListTile(
            leading: const Icon(MaterialCommunityIcons.playlist_music),
            title: Text($t(context, 'playlist'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.playlistScreen);
            },
          ),
          ListTile(
            leading: const Icon(Octicons.heart, color: primary),
            title: Text($t(context, 'fvrt'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.favourites);
            },
          ),
          ListTile(
            leading: const Icon(Foundation.download, color: primary),
            title: Text($t(context, 'downloads'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.downloadScreenRoute);
            },
          ),
          ListTile(
            leading: const Icon(MaterialIcons.attach_money, color: primary),
            title: Text($t(context, 'bought_albums'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
            },
          ),
          ListTile(
            leading: const Icon(Ionicons.ios_options, color: primary),
            title: Text($t(context, 'settings'), style: const TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.userAccountPage);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';

class MyAccountScreen extends StatelessWidget with BaseMixins {
  Widget leadingIcon({int cartLength}) {
    return cartLength > 0
        ? badges.Badge(
      position: badges.BadgePosition.topEnd(top: 18, end: 10),
      badgeContent: Text(
        cartLength.toString(),
        softWrap: true,
        style: const TextStyle(
          color: white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/svg/shopping-cart.svg',
        height: 18,
        color: primary,
      ),
    )
        : SvgPicture.asset(
      'assets/icons/svg/shopping-cart.svg',
      height: 18,
      color: primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthProvider>();
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 75),
      color: background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: leadingIcon(
                cartLength: context.watch<CartProvider>().cart.length,
              ),
            ),
            title: Text(
              $t(context, 'my_basket'),
              style: const TextStyle(color: white),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          const Divider(height: 0, color: Colors.white70),
          ListTile(
            minLeadingWidth: 20,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: SvgPicture.asset(
                "assets/icons/svg/love (1).svg",
                height: 18,
                color: primary,
              ),
            ),
            title: Text(
              $t(context, 'fvrt'),
              style: const TextStyle(color: white),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            onTap: () => Navigator.pushNamed(context, AppRoutes.myfavourites),
          ),
          const Divider(height: 0, color: Colors.white70),
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: SvgPicture.asset(
                "assets/icons/svg/music-file (1).svg",
                height: 18,
                color: primary,
              ),
            ),
            title: Text(
              $t(context, 'playlist'),
              style: const TextStyle(color: white),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.playlistScreen),
          ),
          const Divider(height: 0, color: Colors.white70),
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: SvgPicture.asset(
                "assets/icons/svg/music-folder.svg",
                height: 18,
                color: primary,
              ),
            ),
            title: Text(
              $t(context, 'albums'),
              style: const TextStyle(color: white),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            onTap: () => Navigator.pushNamed(context, AppRoutes.albums),
          ),
          const Divider(height: 0, color: Colors.white70),
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: SvgPicture.asset(
                "assets/icons/svg/download.svg",
                height: 18,
                color: primary,
              ),
            ),
            title: Text(
              $t(context, 'downloads'),
              style: const TextStyle(color: white),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            onTap: () => Navigator.pushNamed(
                context, AppRoutes.downloadScreenRoute),
          ),
          const Divider(height: 0, color: Colors.white70),
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: const SizedBox(
              height: 50,
              child: Icon(Ionicons.ios_options, color: primary),
            ),
            trailing: const Icon(Icons.navigate_next, color: Colors.white70),
            title: Text(
              $t(context, 'settings'),
              style: const TextStyle(color: white),
            ),
            onTap: () => Navigator.pushNamed(context, AppRoutes.userAccountPage),
          ),
          const Divider(height: 0, color: Colors.white70),
          if (provider.isLoggedIn)
            Column(
              children: const [
                Divider(height: 0, color: Colors.white70),
              ],
            ),
        ],
      ),
    );
  }
}

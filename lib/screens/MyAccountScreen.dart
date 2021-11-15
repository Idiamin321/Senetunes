import 'package:animated_drawer/views/home_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/screens/exploreScreen.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class MyAccountScreen extends StatelessWidget with BaseMixins {
  Widget leadingIcon({int cartLength}) {
    return cartLength > 0
        ? Badge(
            position: BadgePosition.topEnd(top: 18, end:10),
            badgeContent: Text(cartLength.toString(),
              softWrap: true,style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 10),
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
    return
        // Scaffold(
        //   appBar: PreferredSize(
        //     preferredSize: const Size.fromHeight(100),
        //     child: Container(
        //       color: background,
        //       padding: const EdgeInsets.only(
        //           left: 15.0, top: 10.0, bottom: 10.0, right: 10),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Wrap(
        //             spacing: 0,
        //             alignment: WrapAlignment.center,
        //             crossAxisAlignment: WrapCrossAlignment.center,
        //             children: [
        //               SizedBox(),
        //               Text(
        //                 $t(
        //                   context,
        //                   'my_account',
        //                 ),
        //                 style: TextStyle(
        //                   fontSize: 24,
        //                   color: white,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           IconButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, AppRoutes.userAccountPage);
        //             },
        //             icon: SvgPicture.asset(
        //               'assets/icons/svg/gear (2).svg',
        //               height: 25,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // body:
        Container(
          margin: EdgeInsets.only(left: 20,right:20,bottom:75),
      // color: Theme.of(context).scaffoldBackgroundColor,
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
                  cartLength: context.watch<CartProvider>().cart.length),
            ),
            title: Text(
              $t(
                context,
                'my_basket',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
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
              $t(
                context,
                'fvrt',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.myfavourites);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
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
              $t(
                context,
                'playlist',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.playlistScreen);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
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
              $t(
                context,
                'albums',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.albums);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
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
              $t(
                context,
                'downloads',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.downloadScreenRoute);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
          ListTile(
            minLeadingWidth: 25,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 50,
              child: SvgPicture.asset(
                "assets/icons/svg/music-album.svg",
                height: 18,
                color: primary,
              ),
            ),
            title: Text(
              $t(
                context,
                'bought_albums',
              ),
              style: TextStyle(color: white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
          ListTile(minLeadingWidth: 25,contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height:50,
              child: Icon(
                Ionicons.ios_options,
                color: primary,
              ),

            ),trailing: Icon(
              Icons.navigate_next,
              color: Colors.white70,
            ),title: Text(
                $t(
                  context,
                  'settings',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.userAccountPage);
            },
          ),
          Divider(
            height: 0,
            color: Colors.white70,
          ),
          if (provider.isLoggedIn)
            Column(
              children: [
                      ListTile(
                        minLeadingWidth: 25,
                        contentPadding: EdgeInsets.zero,
                        tileColor: background,
                        title: Text(
                          $t(
                            context,
                            'sign_out',
                          ),
                        ),
                        leading: SizedBox(
                          height: 50,
                          child: SvgPicture.asset(
                            "assets/icons/svg/logout (4).svg",
                            height: 18,
                            color: primary,
                          ),
                        ),
                        onTap: () => provider.logout(),
                      ),
                Divider(
                  height: 0,
                  color: Colors.white70,
                ),
              ],
            ),
        ],
      ),
      // ),
    );
  }
}

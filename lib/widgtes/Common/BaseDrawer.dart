import 'package:animated_drawer/views/home_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/screens/exploreScreen.dart';

class BaseDrawer extends StatelessWidget with BaseMixins {
  Widget leadingIcon({int cartLength}) {
    return cartLength > 0
        ? Badge(
            position: BadgePosition.topEnd(top: 10, end: 10),
            badgeContent: Text(cartLength.toString(),
              softWrap: true,style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 10),
            ),
            child: Icon(
              Ionicons.md_cart,
              color: primary,
            ),
          )
        : Icon(
            Ionicons.md_cart,
            color: primary,
          );
  }

  @override
  Widget build(BuildContext context) {
    return
        // Drawer(
        // child:
        Container(
      // color: Theme.of(context).scaffoldBackgroundColor,
      color: background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          ListTile(
            leading: leadingIcon(
                cartLength: context.watch<CartProvider>().cart.length),
            title: Text(
                $t(
                  context,
                  'cart',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          ListTile(
            leading: Icon(
              Entypo.modern_mic,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'artists',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.artists);
            },
          ),
          ListTile(
            leading: Icon(
              Entypo.folder_music,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'all_songs',
                ),
                style: TextStyle(color: white)),
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
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.playlistScreen);
            },
          ),
          ListTile(
            leading: Icon(
              Octicons.heart,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'fvrt',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.favourites);
            },
          ),
          ListTile(
            leading: Icon(
              Foundation.download,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'downloads',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.downloadScreenRoute);
            },
          ),
          ListTile(
            leading: Icon(
              MaterialIcons.attach_money,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'bought_albums',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
            },
          ),
          ListTile(
            leading: Icon(
              Ionicons.ios_options,
              color: primary,
            ),
            title: Text(
                $t(
                  context,
                  'settings',
                ),
                style: TextStyle(color: white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.userAccountPage);
            },
          ),
        ],
      ),
      // ),
    );
  }
}


// class DrawerScreen extends StatefulWidget {
//   const DrawerScreen({Key key}) : super(key: key);
//
//   @override
//   _DrawerScreenState createState() => _DrawerScreenState();
// }
//
// class DrawerItem {
//   final String title;
//   final IconData icon;
//   final int index;
//   const DrawerItem({
//     this.index,
//     this.title,
//     this.icon,
//   });
// }
//
// class DrawerItems {
//   static const home =
//   DrawerItem(title: 'Home', icon: Icons.home_rounded, index: 0);
//   static const cart =
//   DrawerItem(title: 'My Cart', icon: Icons.shopping_cart_rounded, index: 1);
//   static const favourites = DrawerItem(
//       title: 'My Favourites', icon: Icons.favorite_rounded, index: 2);
//   static const order =
//   DrawerItem(title: 'My Orders', icon: Icons.assignment_rounded, index: 3);
//   static const settings =
//   DrawerItem(title: 'Settings', icon: Icons.settings_rounded, index: 4);
//
//   static final List<DrawerItem> all = [
//     home,
//     cart,
//     favourites,
//     order,
//     settings,
//   ];
// }
//
// class _DrawerScreenState extends State<DrawerScreen> {
//    double xOffset;
//    double yOffset;
//    double scaleFactor;
//    bool isDrawerOpen;
//   int selectedIndex = 0;
//   DrawerItem item = DrawerItems.home;
//   bool isDragging = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // closeDrawer();
//     openDrawer();
//   }
//
//   void closeDrawer() => setState(() {
//     xOffset = 0;
//     yOffset = 0;
//     scaleFactor = 1;
//     isDrawerOpen = false;
//   });
//   void openDrawer() => setState(() {
//     xOffset = 270;
//     yOffset = 150;
//     scaleFactor = 0.65;
//     isDrawerOpen = true;
//   });
//
//   Widget _buildDrawer() => DrawerWidget(
//     selectedIndex,
//     onSelectedItem: (item) {
//       setState(() {
//         this.item = item;
//       });
//       closeDrawer();
//     },
//   );
//   Widget _buildPage() {
//     return WillPopScope(
//       onWillPop: () async {
//         if (isDrawerOpen) {
//           closeDrawer();
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: GestureDetector(
//         onTap: closeDrawer,
//         onHorizontalDragStart: (details) => isDragging = true,
//         onHorizontalDragUpdate: (details) {
//           const delta = 1;
//           if (details.delta.dx > delta) {
//             openDrawer();
//           } else if (details.delta.dx < -delta) {
//             closeDrawer();
//           }
//         },
//         child: AnimatedContainer(
//             transform: Matrix4.translationValues(xOffset, yOffset, 0)
//               ..scale(scaleFactor),
//             duration: const Duration(milliseconds: 200),
//             child: AbsorbPointer(
//                 absorbing: isDrawerOpen,
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(isDrawerOpen ? 0 : 0),
//                     child: getDrawerPage()))),
//       ),
//     );
//   }
//
//   Widget _buildSecondPage() {
//     return AnimatedContainer(
//         transform: Matrix4.translationValues(xOffset - 30, yOffset + 20, 0)
//           ..scale(scaleFactor - 0.05),
//         duration: const Duration(milliseconds: 100),
//         child: AbsorbPointer(
//             absorbing: isDrawerOpen,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(isDrawerOpen ? 0 : 0),
//                 child: Opacity(opacity: 0.7, child: ExploreScreen()))));
//   }
//
//   Widget getDrawerPage() {
//     switch (item) {
//       case DrawerItems.cart:
//         selectedIndex = 1;
//         return ExploreScreen();
//       default:
//         selectedIndex = 0;
//         return ExploreScreen();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white70,
//       body: Stack(children: [
//         _buildDrawer(),
//         _buildSecondPage(),
//         _buildPage(),
//       ]),
//     );
//   }
// }
//
//
// class DrawerWidget extends StatelessWidget with BaseMixins{
//   final ValueChanged<DrawerItem> onSelectedItem;
//   final int selectedIndex;
//   Widget leadingIcon({int cartLength}) {
//     return cartLength > 0
//         ? Badge(
//       position: BadgePosition.topEnd(top: 10, end: 10),
//       badgeContent: Text(cartLength.toString()),
//       child: Icon(Ionicons.md_cart,color: primary,),)
//         : Icon(Ionicons.md_cart,color: primary,);
//   }
//   const DrawerWidget(this.selectedIndex,
//       {this.onSelectedItem, Key key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 60, left: 15, bottom: 50),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               DrawerHeader(
//                 child: Image(
//                   image: AssetImage('assets/images/logo.png'),
//                 ),
//               ),
//             ],
//           ),
//
//           ListTile(
//             leading: leadingIcon(
//                 cartLength: context.watch<CartProvider>().cart.length),
//             title: Text(
//                 $t(
//                   context,
//                   'cart',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.cart);
//             },
//           ),
//           ListTile(
//             leading: Icon(Entypo.modern_mic,color: primary,),
//             title: Text(
//                 $t(
//                   context,
//                   'artists',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.artists);
//             },
//           ),
//           ListTile(
//             leading: Icon(Entypo.folder_music,color: primary,),
//             title: Text(
//                 $t(
//                   context,
//                   'all_songs',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.albums);
//             },
//           ),
//           ListTile(
//             leading: Icon(MaterialCommunityIcons.playlist_music),
//             title: Text(
//                 $t(
//                   context,
//                   'playlist',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.playlistScreen);
//             },
//           ),
//           ListTile(
//             leading: Icon(
//               Octicons.heart,
//               color: primary,
//             ),
//             title: Text(
//                 $t(
//                   context,
//                   'fvrt',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.favourites);
//             },
//           ),
//           ListTile(
//             leading: Icon(Foundation.download,color: primary,),
//             title: Text(
//                 $t(
//                   context,
//                   'downloads',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.downloadScreenRoute);
//             },
//           ),
//           ListTile(
//             leading: Icon(MaterialIcons.attach_money,color: primary,),
//             title: Text(
//                 $t(
//                   context,
//                   'bought_albums',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
//             },
//           ),
//           ListTile(
//             leading: Icon(Ionicons.ios_options,color: primary,),
//             title: Text(
//                 $t(
//                   context,
//                   'settings',
//                 ),
//                 style: TextStyle(color: white)),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.userAccountPage);
//             },
//           ),
//           // _buildDrawerItems(context),
//           ListTile(
//             onTap: () {
//               ScaffoldMessenger.of(context)
//                   .showSnackBar(const SnackBar(content: Text('Logging Out')));
//             },
//             leading: const Icon(
//               Icons.exit_to_app_rounded,
//               color: Colors.white,
//               size: 28,
//             ),
//             title: const Text(
//               'Sign Out',
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItems(BuildContext context) => Column(
//     children: DrawerItems.all
//         .map((item) => Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         onTap: () => onSelectedItem(item),
//         title: Text(
//           item.title,
//           style: TextStyle(
//               color: selectedIndex == item.index
//                   ? Theme.of(context).primaryColor
//                   : Colors.white,
//               fontSize: 20),
//         ),
//         leading: Icon(
//           item.icon,
//           color: selectedIndex == item.index
//               ? Theme.of(context).primaryColor
//               : Colors.white,
//           size: 28,
//         ),
//       ),
//     ))
//         .toList(),
//   );
// }

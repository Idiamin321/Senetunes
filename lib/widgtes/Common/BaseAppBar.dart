import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/screens/album/SearchScreen.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget {
  final bool darkMode;
  final String logoPath;
  final bool isHome;
  const BaseAppBar({Key key, this.logoPath, this.darkMode, this.isHome: false}) : super(key: key);

  Widget leadingIcon(
      {@required bool isHome,
      @required bool isCart,
      Brightness brightness,
      int cartLength,
      BuildContext context}) {
    return cartLength > 0 && !isCart
        ? Theme(
            data: Theme.of(context),
            child: Badge(
              position: BadgePosition.topEnd(top: 10, end: 10),
              badgeContent: Text(cartLength.toString()),
              child: IconButton(
                icon: Icon(
                  isHome != null && isHome ? Icons.menu : Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  if (isHome)
                    Scaffold.of(context).openDrawer();
                  else
                    Navigator.pop(context);
                },
              ),
            ),
          )
        : IconButton(
            icon: Icon(
              isHome ? Icons.menu : Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
              // color: darkMode ? Colors.black : Colors.white,
            ),
            onPressed: () {
              if (isHome)
                Scaffold.of(context).openDrawer();
              else
                Navigator.pop(context);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    // if(isHome == null) isHome = ModalRoute.of(context).settings.name == AppRoutes.home;
    final bool isCart = ModalRoute.of(context).settings.name == AppRoutes.cart;
    return AppBar(
      automaticallyImplyLeading: !isHome,
      leading: leadingIcon(
        isCart: isCart,
        isHome: isHome,
        brightness: MediaQuery.of(context).platformBrightness,
        cartLength: context.watch<CartProvider>().cart.length,
        context: context,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: logoPath != null
          ? Image(
              fit: BoxFit.scaleDown,
              width: 100,
              height: 100,
              image: AssetImage(logoPath),
            )
          : Container(),
      centerTitle: true,
      actions: [
        !isCart
            ? IconButton(
                icon: context.watch<CartProvider>().cart.length > 0
                    ? Badge(
                        position: BadgePosition.topEnd(top: 10, end: 10),
                        badgeContent: Text(context.watch<CartProvider>().cart.length.toString()),
                        child: Icon(Ionicons.md_cart))
                    : Icon(Ionicons.md_cart),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              )
            : SizedBox(
                width: 0,
              ),
        IconButton(
          icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen(),
                  fullscreenDialog: true,
                ));
          },
        ),
      ],
    );
  }
}

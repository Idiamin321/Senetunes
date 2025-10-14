import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/CartProvider.dart';

class BasicAppBar extends StatelessWidget {
  final bool? darkMode;
  final String? logoPath;
  final bool isHome;
  final String? title;

  const BasicAppBar({
    super.key,
    this.logoPath,
    this.title,
    this.darkMode,
    this.isHome = false,
  });

  Widget leadingIcon({
    required bool isHome,
    required bool isCart,
    Brightness? brightness,
    int cartLength = 0,
    required BuildContext context,
  }) {
    return IconButton(
      icon: Icon(
        isHome ? Icons.menu : Icons.arrow_back,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        // if (isHome) Scaffold.of(context).openDrawer();
        // else
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCart = ModalRoute.of(context)?.settings.name == AppRoutes.cart;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(title ?? "")),
          if (!isCart)
            IconButton(
              icon: context.watch<CartProvider>().cart.isNotEmpty
                  ? Badge(
                position: BadgePosition.topEnd(top: 10, end: 10),
                badgeContent: Text(
                  context.watch<CartProvider>().cart.length.toString(),
                ),
                child: SvgPicture.asset(
                  'assets/icons/svg/shopping-cart.svg',
                  height: 25,
                ),
              )
                  : SvgPicture.asset(
                'assets/icons/svg/shopping-cart.svg',
                height: 25,
              ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            )
          else
            const SizedBox(width: 0),
        ],
      ),
    );
  }
}

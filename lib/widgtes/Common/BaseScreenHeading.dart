import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/CartProvider.dart';

class BaseScreenHeading extends StatelessWidget {
  final String title;
  final bool isBack;
  final bool centerTitle;

  const BaseScreenHeading({
    super.key,
    required this.title,
    this.isBack = false,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final bool isCart = routeName == AppRoutes.cart;

    return Container(
      color: background,
      padding:
      const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: isCart
                ? const EdgeInsets.only(top: 25)
                : const EdgeInsets.only(top: 0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (isBack)
                  InkWell(
                    onTap: () {
                      final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                      if (cartProvider.showPopMessage == true) {
                        cartProvider.showPopMessage = false;
                      }
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/svg/back_arrow.svg',
                      height: 25,
                      color: white,
                    ),
                  ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 28,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isCart)
            IconButton(
              padding: const EdgeInsets.only(top: 25),
              icon: context.watch<CartProvider>().cart.isNotEmpty
                  ? Badge(
                position: BadgePosition.topEnd(top: 10, end: 10),
                badgeContent: Text(
                  context.watch<CartProvider>().cart.length.toString(),
                  softWrap: true,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
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
            ),
        ],
      ),
    );
  }
}

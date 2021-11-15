import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:provider/provider.dart';

class BaseScreenHeading extends StatelessWidget {
  final String title;
  final bool isBack;
  final bool centerTitle;

  const BaseScreenHeading({Key key, this.title, this.isBack, this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCart = ModalRoute.of(context).settings.name == AppRoutes.cart;
    return Container(
      color: background,
      padding:
          const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // centerTitle != null && centerTitle && isBack != null && isBack
          //     ? InkWell(
          //         onTap: () {
          //           Navigator.of(context).pop();
          //         },
          //         child: SvgPicture.asset(
          //           "assets/icons/svg/back_arrow.svg",
          //           height: 25,
          //           color: white,
          //         ),
          //       )
          //     : SizedBox(),
          // centerTitle && centerTitle != null
          //     ? Expanded(
          //         child: Text(
          //           title,
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontSize: 24,
          //             color: white,
          //           ),
          //         ),
          //       )
          //     : SizedBox(),
          // centerTitle == null || centerTitle==false
          //     ?
          Padding(
            padding:
                isCart ? EdgeInsets.only(top: 25) : EdgeInsets.only(top: 0),
            child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  isBack != null && isBack
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/svg/back_arrow.svg",
                            height: 25,
                            color: white,
                          ),
                        )
                      : SizedBox(),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width*0.7,
                    height:28,alignment: Alignment.centerLeft,
                    child:Text(
                    title,textAlign: TextAlign.start,softWrap: true,
                    overflow: TextOverflow.ellipsis,maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      color: white,
                    ),
                  ),),
                ]),
          ),
          // : SizedBox(),
          !isCart
              ? IconButton(
                  padding: EdgeInsets.only(top: 25),
                  icon: context.watch<CartProvider>().cart.length > 0
                      ? Badge(
                          position: BadgePosition.topEnd(top: 10, end: 10),
                          badgeContent: Text(context
                              .watch<CartProvider>()
                              .cart
                              .length
                              .toString(),
                            softWrap: true,style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 10),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/svg/shopping-cart.svg',
                            height: 25,
                          )
                          // child: Icon(Ionicons.md_cart),
                          )
                      : SvgPicture.asset(
                          'assets/icons/svg/shopping-cart.svg',
                          height: 25,
                        ),
                  // : Icon(Ionicons.md_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.cart);
                  },
                )
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Cart/CartTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';
import 'package:tuple/tuple.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with BaseMixins {
  CartProvider cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartProvider = context.watch<CartProvider>();
  }


  double total = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    cartProvider.getResponse(
        context,
        context.read<AuthProvider>().user == null
            ? ""
            : context.read<AuthProvider>().user.email);
    print("here!");
    total = 0.0;
    cartProvider.cart.forEach((element) {
      total += element.price;
      total = double.parse(total.toStringAsFixed(2));
    });
    return Scaffold(
      floatingActionButton: cartProvider.showPopMessage ? InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.boughtAlbumsScreenRoute);
        },
        child: Container(
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(100),
          ),
          margin: EdgeInsets.only(
            left: 50,
            right: 20,
            top: 10,
            bottom: track != null ? 60 : 10,
          ),
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text("Go to the bought Albums",
              style: TextStyle(
                  color: white, fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      ) : Container(),
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, "cart"),
          centerTitle: false,
          isBack: true,
        ),
        // BaseAppBar(
        //   isHome: false,
        //   // darkMode: context.watch<ThemeProvider>().darkMode,
        // ),
      ),
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: true,
            child: cartProvider.cart.length != 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: 20, left: 20, top: 10, bottom: 10),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${cartProvider.cart.length.toString()}  ${$t(context, "music")}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.only(bottom: track != null ? 50 : 30),
                          itemCount: cartProvider.cart.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 70,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      // color:Colors.red,
                                      margin: EdgeInsets.only(bottom: 0),
                                      child: CartTile(
                                        album: cartProvider.cart[index],
                                        remove: () {
                                          setState(
                                            () {
                                              cartProvider.removeAlbum(
                                                  cartProvider.cart[index]);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Divider(
                                      height: 0,
                                      color: white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 15,
                          top: 10,
                        ),
                        child: Text.rich(
                          TextSpan(
                              text: "Total:  ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                              ),
                              children: [
                                TextSpan(
                                  text: "${total.toString()} €",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          var request = await cartProvider.postRequest();
                          print(request);
                          if (request['response_code'] == '00') {
                            cartProvider.url = request['response_text'];
                            // Navigator.popAndPushNamed(
                            //     context, AppRoutes.boughtAlbumsScreenRoute);
                            Navigator.pushNamed(context, AppRoutes.webView,
                                arguments:
                                    Tuple2('Paydunya', cartProvider.url));
                          }
                          print(cartProvider.completed);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                            bottom: track != null ? 60 : 10,
                          ),
                          height: 60,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text($t(context, "order"),
                              style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      // Container(
                      //   margin:
                      //       EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      //   height: 50,
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(100),
                      //       ),
                      //     ),
                      //     // style: ButtonStyle(),
                      //     child: Theme(
                      //       data: Theme.of(context),
                      //       child: Text(
                      //         $t(context, "order"),
                      //         style: TextStyle(
                      //           color: Theme.of(context).primaryColor,
                      //         ),
                      //       ),
                      //     ),
                      //     onPressed: () async {
                      //       var request = await cartProvider.postRequest();
                      //       print(request);
                      //       if (request['response_code'] == '00') {
                      //         cartProvider.url = request['response_text'];
                      //         Navigator.popAndPushNamed(
                      //             context, AppRoutes.boughtAlbumsScreenRoute);
                      //         Navigator.pushNamed(context, AppRoutes.webView,
                      //             arguments:
                      //                 Tuple2('Paydunya', cartProvider.url));
                      //       }
                      //       print(cartProvider.completed);
                      //     },
                      //   ),
                      // ),
                    ],
                  )
                : BaseMessageScreen(
                    title: $t(context, 'cart_empty'),
                    icon: Icons.add_shopping_cart,
                  ),
          ),
        ),
      ),
    );
  }
}

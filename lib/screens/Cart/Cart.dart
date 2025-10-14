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
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:tuple/tuple.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with BaseMixins {
  late CartProvider cartProvider;
  double total = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartProvider = context.watch<CartProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final Track? _ = playerProvider.currentTrack;

    // ping PayDunya status (safe si user null)
    cartProvider.getResponse(
      context,
      context.read<AuthProvider>().user == null
          ? ""
          : context.read<AuthProvider>().user.email,
    );

    total = 0.0;
    for (final a in cartProvider.cart) {
      total += a.price;
      total = double.parse(total.toStringAsFixed(2));
    }

    return Scaffold(
      floatingActionButton: cartProvider.showPopMessage
          ? InkWell(
        onTap: () => Navigator.pushNamed(
            context, AppRoutes.boughtAlbumsScreenRoute),
        child: Container(
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(100),
          ),
          margin:
          const EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 60),
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            "Go to the bought Albums",
            style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      )
          : const SizedBox.shrink(),
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'cart',
          centerTitle: false,
          isBack: true,
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: true,
            child: cartProvider.cart.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${cartProvider.cart.length}  ${$t(context, "music")}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 50),
                    itemCount: cartProvider.cart.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                child: CartTile(
                                  album: cartProvider.cart[index],
                                  remove: () {
                                    setState(() {
                                      cartProvider.removeAlbum(cartProvider.cart[index]);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Divider(height: 0, color: white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 15, top: 10),
                  child: Text.rich(
                    TextSpan(
                      text: "Total:  ",
                      style: const TextStyle(color: Colors.white70, fontSize: 22),
                      children: [
                        TextSpan(
                          text: "$total €",
                          style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final request = await cartProvider.postRequest();
                    if (request['response_code'] == '00') {
                      cartProvider.url = request['response_text'];
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.webView,
                        arguments: Tuple2('Paydunya', cartProvider.url),
                      );
                      if (cartProvider.showPopMessage) {
                        // message de succès
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: white,
                            title: Center(
                              child: Icon(Icons.warning, size: 30, color: primary),
                            ),
                            content: const Text(
                              "Votre album a été acheté avec succès. Rendez-vous dans la page de vos Albums Achetés afin de l'écouter",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, AppRoutes.boughtAlbumsScreenRoute);
                                },
                                child: const Text("Mes albums achetés",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 60),
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      $t(context, "order"),
                      style: const TextStyle(
                          color: white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
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

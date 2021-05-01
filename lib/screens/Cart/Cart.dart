import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/widgtes/Cart/CartTile.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with BaseMixins {
  CartProvider cartProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    cartProvider = context.watch<CartProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BaseAppBar(
            isHome: false,
            // darkMode: context.watch<ThemeProvider>().darkMode,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cart.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: CartTile(
                                album: cartProvider.cart[index],
                                remove: () {
                                  setState(
                                    () {
                                      cartProvider.removeAlbum(cartProvider.cart[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(),
                  child: Theme(
                    data: Theme.of(context),
                    child: Text(
                      $t(context, "buy"),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    var request = await cartProvider.postRequest();
                    print(request);
                    if (request['response_code'] == '00') {
                      cartProvider.url = request['response_text'];
                      Navigator.pushNamed(context, AppRoutes.webView, arguments: Tuple2('Paydunya', cartProvider.url));
                    }
                    print(cartProvider.completed);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

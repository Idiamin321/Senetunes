import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/screens/Cart/Cart.dart';
import 'package:senetunes/screens/exploreScreen.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:tuple/tuple.dart';

class WebViewCart extends StatefulWidget {
  @override
  _WebViewCartState createState() => _WebViewCartState();
}

class _WebViewCartState extends State<WebViewCart> {
  CartProvider cartProvider;
  DownloadProvider downloadProvider;
  FlutterWebviewPlugin flutterWebViewPlugin;
  StreamSubscription<String> _onUrlChanged;
  bool canGoBack = false;
  bool canGoForward = false;

  @override
  void didChangeDependencies() {
    cartProvider = context.watch<CartProvider>();
    downloadProvider = context.watch<DownloadProvider>();
    super.didChangeDependencies();
  }

  @override
  void initState() {

    flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.onProgressChanged.listen((event) {
      setState(() {
        cartProvider.getResponse(
            context, context.read<AuthProvider>().user.email);
      });
    });
    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      canGoBack = await flutterWebViewPlugin.canGoBack();
      canGoForward = await flutterWebViewPlugin.canGoForward();
      setState(() {
        cartProvider.isBought=0;
        cartProvider.getResponse(
            context, context.read<AuthProvider>().user.email);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigator.of(context).pushNamedAndRemoveUntil( AppRoutes.cart, ModalRoute.withName(AppRoutes.home));
          Navigator.of(context).pop();
          cartProvider.getResponse(
              context, context.read<AuthProvider>().user.email);
          return true;
        },
        child: WebviewScaffold(
          ignoreSSLErrors: true,
          url: (ModalRoute.of(context).settings.arguments
                  as Tuple2<String, String>)
              .item2,
          mediaPlaybackRequiresUserGesture: false,
          appBar: AppBar(
            backgroundColor: background,
            //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/svg/back_arrow.svg",
                height: 25,
                color: white,
              ),
              onPressed: () {
                cartProvider.getResponse(
                    context, context.read<AuthProvider>().user.email);
                log("backkk");
                // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.cart, ModalRoute.withName(AppRoutes.home));
                Navigator.pop(context);
              },
            ),
            title: Text(
              (ModalRoute.of(context).settings.arguments
                      as Tuple2<String, String>)
                  .item1,
              style: TextStyle(
                color: white,
                // color: Theme.of(context).primaryColor,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: white,
                // color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey[400],
                onPressed: canGoBack
                    ? () {
                        flutterWebViewPlugin.goBack();
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                color: white,
                // color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey[400],
                onPressed: canGoForward
                    ? () {
                        flutterWebViewPlugin.goForward();
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.autorenew),
                color: white,
                // color: Theme.of(context).primaryColor,
                onPressed: () {
                  flutterWebViewPlugin.reload();
                },
              ),
            ],
          ),
          withZoom: true,
          hidden: true,
          initialChild: Container(
            child: CustomCircularProgressIndicator(),
            color: background,
          ),
        ));
  }
}

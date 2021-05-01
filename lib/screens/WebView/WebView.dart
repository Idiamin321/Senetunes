import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/DownloadProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
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
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      canGoBack = await flutterWebViewPlugin.canGoBack();
      canGoForward = await flutterWebViewPlugin.canGoForward();
      if (mounted) {
        setState(() {
          cartProvider.getResponse(context);
        });
      }
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
    return WebviewScaffold(
      ignoreSSLErrors: true,
      url: (ModalRoute.of(context).settings.arguments as Tuple2<String, String>).item2,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          (ModalRoute.of(context).settings.arguments as Tuple2<String, String>).item1,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey[400],
            onPressed: canGoBack
                ? () {
                    flutterWebViewPlugin.goBack();
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey[400],
            onPressed: canGoForward
                ? () {
                    flutterWebViewPlugin.goForward();
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.autorenew),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              flutterWebViewPlugin.reload();
            },
          ),
        ],
      ),
      withZoom: true,
      hidden: true,
      initialChild: CustomCircularProgressIndicator(),
    );
  }
}

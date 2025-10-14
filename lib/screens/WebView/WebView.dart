import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';

class WebViewCart extends StatefulWidget {
  const WebViewCart({super.key});

  @override
  State<WebViewCart> createState() => _WebViewCartState();
}

class _WebViewCartState extends State<WebViewCart> {
  late final CartProvider cartProvider;
  late final DownloadProvider downloadProvider;

  WebViewController? _controller;
  bool _loading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void didChangeDependencies() {
    cartProvider = context.watch<CartProvider>();
    downloadProvider = context.watch<DownloadProvider>();
    super.didChangeDependencies();
  }

  Future<void> _refreshNavAvailability() async {
    if (_controller == null) return;
    final canBack = await _controller!.canGoBack();
    final canFwd = await _controller!.canGoForward();
    if (mounted) {
      setState(() {
        _canGoBack = canBack;
        _canGoForward = canFwd;
      });
    }
  }

  WebViewController _buildController(String initialUrl, String email) {
    final c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest req) {
            cartProvider.isBought = 0;
            unawaited(cartProvider.getResponse(context, email));
            return NavigationDecision.navigate;
          },
          onPageStarted: (u) {
            setState(() => _loading = true);
          },
          onPageFinished: (u) async {
            setState(() => _loading = false);
            await _refreshNavAvailability();
            unawaited(cartProvider.getResponse(context, email));
          },
          onProgress: (progress) {
            unawaited(cartProvider.getResponse(context, email));
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl), headers: {
        'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Safari',
      });
    return c;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Tuple2<String, String>?;
    final title = args?.item1 ?? '';
    final url = args?.item2 ?? '';
    final email = context.read<AuthProvider>().user?.email ?? '';

    _controller ??= _buildController(url, email);

    return WillPopScope(
      onWillPop: () async {
        if (_controller != null && await _controller!.canGoBack()) {
          await _controller!.goBack();
          await _refreshNavAvailability();
          await cartProvider.getResponse(context, email);
          return false;
        }
        await cartProvider.getResponse(context, email);
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          leading: IconButton(
            icon: SvgPicture.asset(
              "assets/icons/svg/back_arrow.svg",
              height: 25,
              color: white,
            ),
            onPressed: () async {
              await cartProvider.getResponse(context, email);
              log("backkk");
              if (mounted) Navigator.of(context).pop();
            },
          ),
          title: Text(title, style: const TextStyle(color: white)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: white,
              disabledColor: Colors.grey,
              onPressed: _canGoBack
                  ? () async {
                await _controller?.goBack();
                await _refreshNavAvailability();
                await cartProvider.getResponse(context, email);
              }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: white,
              disabledColor: Colors.grey,
              onPressed: _canGoForward
                  ? () async {
                await _controller?.goForward();
                await _refreshNavAvailability();
                await cartProvider.getResponse(context, email);
              }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              color: white,
              onPressed: () async {
                await _controller?.reload();
                await _refreshNavAvailability();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            if (_controller != null) WebViewWidget(controller: _controller!),
            if (_loading)
              Container(
                color: background,
                alignment: Alignment.center,
                child: const CustomCircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

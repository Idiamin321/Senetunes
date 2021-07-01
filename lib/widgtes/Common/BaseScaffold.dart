import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/widgtes/track/TrackBottomBar.dart';

import 'CustomCircularProgressIndicator.dart';

class BaseScaffold extends StatefulWidget {
  final Widget child;
  final bool isLoaded;
  final bool isHome;
  BaseScaffold({this.child, this.isLoaded, this.isHome: false});
  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          !widget.isLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircularProgressIndicator(),
                    if (widget.isHome)
                      AutoSizeText(
                          "Veuillez patienter quelques instants, nous préparons vos albums")
                  ],
                )
              : widget.child,
          Positioned(
            bottom: 0.0,
            left: 0.0,
            height: 50,
            right: 0.0,
            child: TrackBottomBar(),
          ),
        ],
      ),
    );
  }
}

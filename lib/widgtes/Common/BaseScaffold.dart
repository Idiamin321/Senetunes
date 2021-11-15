import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/screens/Download/DownloadDetailsScreen.dart';
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

class _BaseScaffoldState extends State<BaseScaffold>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:background,
      // margin:EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          !widget.isLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircularProgressIndicator(),
                    SizedBox(height:10),
                    if (widget.isHome)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child:AutoSizeText(
                        "Veuillez patienter quelques instants, nous préparons vos albums",
                        textAlign: TextAlign.center,
                        style:TextStyle(color:white)
                      ),),
                  ],
                )
              : widget.child,
        OfflineBuilder(
        child: SizedBox(),
    connectivityBuilder: (BuildContext context,
    ConnectivityResult connectivity,
    Widget builderChild,) {
    final bool connected = connectivity != ConnectivityResult.none;
    return Positioned(
            bottom: 0.0,
            left: 0.0,
            height:55,
            right: 0.0,
            child: connected?TrackBottomBar():DownloadTrackBottomBar(),
          );
        }),
        ],
      ),
    );
  }
}

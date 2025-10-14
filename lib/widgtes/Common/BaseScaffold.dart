import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/widgtes/track/TrackBottomBar.dart';

import 'CustomCircularProgressIndicator.dart';

class BaseScaffold extends StatefulWidget {
  final Widget child;
  final bool isLoaded;
  final bool isHome;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.isLoaded,
    this.isHome = false,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Stack(
        children: [
          if (!widget.isLoaded)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomCircularProgressIndicator(),
                const SizedBox(height: 10),
                if (widget.isHome)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AutoSizeText(
                      'Veuillez patienter quelques instants, nous préparons vos albums',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: white),
                    ),
                  ),
              ],
            )
          else
            widget.child,
          // Bottom mini player
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 55,
            child: TrackBottomBar(),
          ),
        ],
      ),
    );
  }
}

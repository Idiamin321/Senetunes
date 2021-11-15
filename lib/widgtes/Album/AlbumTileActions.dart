import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/models/Track.dart';

class TrackTileActions extends StatelessWidget {
  final Track track;
  final String title;
  final Function route;
  final Widget child;

  TrackTileActions({Key key, this.child, this.title, this.route, this.track});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: child,
      // icon: Icon(
      //   Icons.more_vert,
      //   color: Theme.of(context).primaryColor,
      // ),
      onSelected: (String value) {
        if (value == 'details') {
          route();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'details',
          child: Text(
            '$title',
            style: TextStyle(
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}

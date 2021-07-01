import 'package:flutter/material.dart';
import 'package:senetunes/widgtes/track/TrackBottomBar.dart';

class BaseMessageScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  BaseMessageScreen({this.title, this.subtitle, this.icon, this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (icon != null)
                  Icon(
                    icon,
                    size: 60.0,
                    color: Theme.of(context).primaryColor,
                  ),
                SizedBox(height: 20.0),
                if (title != null)
                  Text('$title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                      )),
                SizedBox(height: 10.0),
                if (subtitle != null)
                  Text(
                    '$subtitle',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
                  ),
                SizedBox(
                  height: 20.0,
                ),
                if (child != null) child,
              ],
            ),
          ),
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

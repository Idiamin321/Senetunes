import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';

class BaseOverlay extends StatelessWidget {
  final Widget child;

  BaseOverlay({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: child,
      ),
      Container(
        height:180,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15),
        ),
        // child: child,
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 100, width: 160,
          child:
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
          child: child,
          ),
        ),
      ),
      // Container(
      //   decoration: new BoxDecoration(
      //     borderRadius: BorderRadius.circular(15),
      //     gradient: new LinearGradient(
      //       colors: [
      //         Color(0xff0C101B).withOpacity(.1),
      //         Theme.of(context).scaffoldBackgroundColor
      //       ],
      //       // stops: [0.3, 1],
      //       begin: FractionalOffset.topCenter,
      //       end: FractionalOffset.bottomCenter,
      //       tileMode: TileMode.clamp,
      //     ),
      //   ),
      // )
    ]);
  }
}

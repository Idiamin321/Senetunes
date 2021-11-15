import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';

class BaseAppIcon extends StatelessWidget {
  final double width;
  BaseAppIcon({this.width});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        'assets/images/logo.png',
        width: width != null ? width : 40,
      ),
    );
  }
}

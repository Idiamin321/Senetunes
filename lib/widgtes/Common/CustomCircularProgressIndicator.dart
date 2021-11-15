import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;
  CustomCircularProgressIndicator({this.size, this.color});
  @override
  Widget build(BuildContext context) {
    Color _color = color == null ? Theme.of(context).primaryColor : color;

    return Center(
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(100),
        // color: Theme.of(context).colorScheme.surface,
        color: barColor,
        child: Container(
          height: size,
          width: size,
          color:background,
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          ),
        ),
      ),
    );
  }
}

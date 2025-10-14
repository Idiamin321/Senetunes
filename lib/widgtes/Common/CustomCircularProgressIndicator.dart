import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const CustomCircularProgressIndicator({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).primaryColor;

    return Center(
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(100),
        color: barColor,
        child: Container(
          height: size,
          width: size,
          color: background,
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(c),
          ),
        ),
      ),
    );
  }
}

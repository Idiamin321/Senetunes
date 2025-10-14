import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/widgtes/common/CustomCircularProgressIndicator.dart';

class OutlineBorderButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color color;
  final double radius;
  final bool isLoaded;
  final Function onPressed;

  OutlineBorderButton({
    this.label,
    this.color,
    this.textColor,
    this.onPressed,
    this.radius,
    isLoaded,
  }) : isLoaded = isLoaded ?? true;

  @override
  Widget build(BuildContext context) {
    double _radius = radius;
    return isLoaded
        ? Container(
            width: double.infinity,
            height: 60,
            color: Colors.transparent,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
                side: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
              onPressed: () => onPressed(),
              child: Padding(
                child: Text(
                  label,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: textColor),
                ),
                padding: EdgeInsets.all(15.0),
              ),
              color: color,
            ),
          )
        : CustomCircularProgressIndicator();
  }
}

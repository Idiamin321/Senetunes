import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';

class BaseMessageScreen extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? child;

  const BaseMessageScreen({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
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
              const SizedBox(height: 20.0),
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: white,
                  ),
                ),
              const SizedBox(height: 10.0),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade500,
                  ),
                ),
              const SizedBox(height: 20.0),
              if (child != null) Center(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

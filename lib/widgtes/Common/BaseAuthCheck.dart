import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/providers/AuthProvider.dart';

class BaseAuthCheck extends StatelessWidget {
  final Widget child;
  final Widget redirect;
  const BaseAuthCheck({this.child, this.redirect, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return Container(
      child: provider.isLoggedIn ? redirect : child,
    );
  }
}

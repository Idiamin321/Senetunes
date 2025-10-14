import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';

class ConfirmationScreen extends StatelessWidget with BaseMixins {
  const ConfirmationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
      backgroundColor: background,
        body: BaseMessageScreen(
            title: $t(context, 'register_title'),
            icon: Icons.check_box,
            child: FlatButton.icon(
                icon: Icon(
                  EvilIcons.arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  $t(context, 'sign_in'),
                  style:
                      TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, AppRoutes.home);
                  // package:senetunes
                })),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';

class PopOverWidget {
  PopOverWidget({String key, String message, BuildContext context, PopoverDirection popoverDirection}) {
    GlobalConfiguration globalConfiguration = GlobalConfiguration();
    if (globalConfiguration.getValue(key) == true) {
      showPopover(
        radius: 10,
        direction: popoverDirection,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        bodyBuilder: (context) {
          globalConfiguration.updateValue(key, false);
          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 50,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(child: Text(message)),
            ),
          );
        },
      );
    }
  }
}

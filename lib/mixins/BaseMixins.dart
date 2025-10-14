import 'dart:math';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/Applocalizations.dart';

mixin BaseMixins {
  String $t(BuildContext context, String key, {String value = ''}) {
    return AppLocalizations.of(context).translate(key);
  }

  dynamic responsive(BuildContext context, {isPhone, isSmallPhone, isTablet}) {
    final width = MediaQuery.of(context).size.width;
    if (width > 500) {
      return isTablet;
    } else if (width < 370) {
      return isSmallPhone;
    } else {
      return isPhone;
    }
  }

  Color activeColor(BuildContext context, check, {Color iconColor}) {
    return check
        ? Theme.of(context).primaryColor
        : (iconColor ?? Theme.of(context).colorScheme.secondary);
  }

  List shuffle(List list) {
    final random = Random();
    var length = list.length;
    while (length > 1) {
      final pos = random.nextInt(length);
      length -= 1;
      final tmp = list[length];
      list[length] = list[pos];
      list[pos] = tmp;
    }
    return list;
  }
}

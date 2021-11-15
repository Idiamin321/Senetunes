import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/FavoriteProvider.dart';
import 'package:senetunes/widgtes/Common/PopOverWidget.dart';

class AlbumFavouriteButton extends StatelessWidget with BaseMixins {
  final Album album;

  final double iconSize;
  AlbumFavouriteButton({this.album, iconSize}) : iconSize = iconSize ?? 20;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favouriteProvider = Provider.of(context);
    return IconButton(
        icon: Icon(
          favouriteProvider.isFavouitedAlbum(album) ? AntDesign.heart : AntDesign.hearto,
          size: iconSize,
          color: activeColor(context, favouriteProvider.isFavouitedAlbum(album),
              iconColor: Colors.white70),
        ),
        onPressed: () {
          if (GlobalConfiguration().getValue('favFirst'))
            PopOverWidget(
                key: 'favFirst',
                message: "Vous adorez cette chanson ? Cliquez ici pour l'ajouter à vos favoris",
                context: context,
                popoverDirection: PopoverDirection.top);
          else
            favouriteProvider.addToFavouritesAlbum(album);
        });
  }
}

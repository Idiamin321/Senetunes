import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/FavoriteProvider.dart';
import 'package:senetunes/widgtes/Common/PopOverWidget.dart';

class TrackFavouriteButton extends StatelessWidget with BaseMixins {
  final Album album;
  final Track track;
  final double iconSize;
  TrackFavouriteButton({this.track, this.album, iconSize}) : iconSize = iconSize ?? 20;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favouriteProvider = Provider.of(context);

    return IconButton(
        icon: Icon(
          favouriteProvider.isFavouitedTrack(track) ? AntDesign.heart : AntDesign.hearto,
          color: favouriteProvider.isFavouitedTrack(track) ? primary :Colors.white70,
        ),
        iconSize: iconSize,
        color: activeColor(context, favouriteProvider.isFavouitedTrack(track)),
        onPressed: () {
          if (GlobalConfiguration().getValue('favFirst'))
            PopOverWidget(
                key: 'favFirst',
                message: "Vous adorez cette chanson ? Cliquez ici pour l'ajouter à vos favoris",
                context: context,
                popoverDirection: PopoverDirection.top);
          else
            favouriteProvider.addToFavouritesTrack(track);
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/DownloadProvider.dart';

import 'PopOverWidget.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton(
      {Key key, @required this.context, this.album, this.track});
  final Album album;
  final BuildContext context;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (GlobalConfiguration().getValue('downloadFirst'))
          PopOverWidget(
              key: 'downloadFirst',
              message:
                  "Ce bouton vous permet de télécharger les Albums que vous avez acheté et de les écouter où vous voulez sans connexion internet",
              context: context,
              popoverDirection: PopoverDirection.top);
        else await context.read<DownloadProvider>().downloadAlbum(album, context);
      },
      child: SvgPicture.asset(
        "assets/icons/svg/download.svg",
        height: 30,
        color: primary,
      ),
    );
  }
}

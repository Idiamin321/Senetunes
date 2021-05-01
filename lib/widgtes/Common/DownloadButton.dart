import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rekord_app/config/AppColors.dart';
import 'package:flutter_rekord_app/models/Album.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/DownloadProvider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import 'PopOverWidget.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key key, @required this.context, this.album, this.track});
  final Album album;
  final BuildContext context;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Foundation.download,
        size: 30,
        color: primary,
      ),
      onPressed: () async {
        if (GlobalConfiguration().getValue('downloadFirst'))
          PopOverWidget(
              key: 'downloadFirst',
              message:
                  "Ce bouton vous permet de télécharger les Albums que vous avez acheté et de les écouter où vous voulez sans connexion internet",
              context: context,
              popoverDirection: PopoverDirection.top);
        else if (album != null)
          await context.read<DownloadProvider>().downloadAlbum(album, context);
        else if (track != null) await context.read<DownloadProvider>().downloadAudio(track, context);
      },
    );
  }
}

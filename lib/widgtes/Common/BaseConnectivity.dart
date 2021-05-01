import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:flutter_rekord_app/providers/ArtistProvider.dart';
import 'package:flutter_rekord_app/providers/CategoryProvider.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:provider/provider.dart';
// Widget Name: Base Connectivity
// @version: 1.0.0
// @since: 1.0.0
// Description: A base widget to checked internet connectivity

class BaseConnectivity extends StatefulWidget {
  final Widget child;
  const BaseConnectivity({Key key, this.child}) : super(key: key);

  @override
  _BaseConnectivityState createState() => _BaseConnectivityState();
}

class _BaseConnectivityState extends State<BaseConnectivity> with BaseMixins {
  bool wasOffline = false;
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget builderChild,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (!connected && !wasOffline)
          wasOffline = true;
        else if (connected && wasOffline) {
          context.read<AlbumProvider>().fetchAlbums();
          context.read<ArtistProvider>().fetchArtists();
          context.read<CategoryProvider>().fetchCategories();
          wasOffline = false;
        }
        return connected
            ? widget.child
            : BaseMessageScreen(
                icon: Icons.perm_scan_wifi,
                title: $t(context, 'no_internet'),
              );
      },
      child: Container(),
    );
  }
}

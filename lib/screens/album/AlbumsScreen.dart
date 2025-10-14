import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/AlbumProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class AlbumsScreen extends StatelessWidget with BaseMixins {
  AlbumsScreen({super.key});

  final ScrollController scrollController = ScrollController();

  Widget _buildGridItem(BuildContext context, Album album) => InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoutes.albumDetail,
        arguments: album,
      );
    },
    child: AlbumTile(album: album),
  );

  @override
  Widget build(BuildContext context) {
    final albumProvider = context.watch<AlbumProvider>();
    // On force la création du provider de player si nécessaire (pas utilisé ici)
    context.read<PlayerProvider>();

    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'albums',
          centerTitle: false,
          isBack: true,
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: albumProvider.isLoaded,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                itemCount: albumProvider.allAlbums.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive(
                    context,
                    isSmallPhone: 2,
                    isPhone: 2,
                    isTablet: 4,
                  ),
                  childAspectRatio: responsive(
                    context,
                    isPhone: 0.8,
                    isSmallPhone: 0.8,
                    isTablet: 0.6,
                  ),
                ),
                itemBuilder: (context, index) {
                  return _buildGridItem(context, albumProvider.allAlbums[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/ArtistProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Artist/ArtistCardForScreen.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';

class ArtistsScreen extends StatelessWidget with BaseMixins {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // S'assure que PlayerProvider est initialisé (pas utilisé ici)
    context.read<PlayerProvider>();
    final artistProvider = context.watch<ArtistProvider>();

    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'artists',
          isBack: true,
          centerTitle: false,
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: artistProvider.isLoaded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: artistProvider.isLoaded
                          ? GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: responsive(
                            context,
                            isSmallPhone: 2,
                            isPhone: 3,
                            isTablet: 4,
                          ),
                          childAspectRatio: responsive(
                            context,
                            isPhone: 0.8,
                            isSmallPhone: 0.8,
                            isTablet: 0.6,
                          ),
                        ),
                        itemCount: artistProvider.allArtists.length,
                        itemBuilder: (context, index) {
                          return ArtistCard(
                            index: index,
                            artist: artistProvider.allArtists[index],
                          );
                        },
                      )
                          : const CustomCircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

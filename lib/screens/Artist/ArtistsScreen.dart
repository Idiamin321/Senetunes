import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/ArtistProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Artist/ArtistCardForScreen.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';

class ArtistsScreen extends StatelessWidget with BaseMixins {
  const ArtistsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    var artistProvider = Provider.of<ArtistProvider>(context);
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, 'artists'),
          isBack: true,
          centerTitle: false,
        ),
        // child: BaseAppBar(
        //   isHome: false,
        //   // darkMode: context.watch<ThemeProvider>().darkMode,
        // ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: true,
            child: Padding(
              padding: EdgeInsets.only(bottom:track!=null?40:0),
              child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: artistProvider.isLoaded
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        responsive(
                                            context,
                                            isSmallPhone: 2,
                                            isPhone: 3,
                                            isTablet: 4),
                                    childAspectRatio: responsive(context,
                                        isPhone: 0.8,
                                        isSmallPhone: 0.8,
                                        isTablet: 0.6)),
                            itemCount: artistProvider.allArtists.length,
                            itemBuilder: (context, index) {
                              return ArtistCard(
                                index: index,
                                artist: artistProvider.allArtists[index],
                              );
                            },
                          )
                        : CustomCircularProgressIndicator(),
                  ),
                ),
              ],
            ),),
          ),
        ),
      ),
    );
  }
}

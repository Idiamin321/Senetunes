import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/DownloadProvider.dart';
import 'package:flutter_rekord_app/widgtes/Album/AlbumTile.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseScreenHeading.dart';
import 'package:flutter_rekord_app/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:provider/provider.dart';

class DownloadScreen extends StatelessWidget with BaseMixins {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseScreenHeading(title: $t(context, 'download')),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackContainer(),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackContainer extends StatefulWidget with BaseMixins {
  @override
  _TrackContainerState createState() => _TrackContainerState();
}

class _TrackContainerState extends State<TrackContainer> with BaseMixins {
  DownloadProvider downloadProvider;
  @override
  void initState() {
    super.initState();
    downloadProvider = context.read<DownloadProvider>();
  }

  @override
  Widget build(BuildContext context) {
    downloadProvider = context.watch<DownloadProvider>();
    return Container(
      padding: EdgeInsets.only(bottom: 0.0),
      child: downloadProvider.downloadedAlbums.length > 0 &&
              downloadProvider.downloadSongs.length > 0
          ? downloadProvider.isLoaded
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: ScrollController(),
                  itemCount: downloadProvider.downloadedAlbums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context, isSmallPhone: 2, isPhone: 2, isTablet: 4),
                      childAspectRatio:
                          responsive(context, isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        downloadProvider.getDownloads();
                        Navigator.of(context).pushNamed(
                          AppRoutes.downloadDetails,
                          arguments: downloadProvider.downloadedAlbums.elementAt(index),
                        );
                      },
                      child: AlbumTile(
                        album: downloadProvider.downloadedAlbums.elementAt(index),
                        downloadScreen: true,
                      ),
                    );
                  },
                )
              // ? ListView.builder(
              //     itemCount: downloadProvider.downloadSongs.length,
              //     itemBuilder: (context, index) {
              //       _downloadedAlbums
              //           .add(playlistProvider.findAlbum(playlistProvider.findTrack(downloadProvider.downloadSongs[index].name, context), context));
              //       return AlbumTile(
              //         album: _downloadedAlbums.elementAt(index),
              //       );
              //     },
              //   )
              : CustomCircularProgressIndicator()
          : BaseMessageScreen(
              title: $t(context, 'download_empty'),
              icon: Icons.data_usage,
              subtitle: '',
            ),
    );
  }
}

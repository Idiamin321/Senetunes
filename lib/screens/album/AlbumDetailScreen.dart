import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/DownloadProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumFavouriteButton.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart'; // chemin corrigé
import 'package:senetunes/widgtes/track/TrackTile.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({super.key});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen>
    with BaseMixins {
  late double heightScreen;
  late double paddingBottom;
  late double width;

  final GlobalKey _scaffoldKey = GlobalKey();

  Widget _buildContent(Album album, PlayerProvider playerProvider) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BaseImage(
          imageUrl: album.media?.cover,
          height: 250,
          width: width,
          radius: 10,
          overlay: true,
          overlayOpacity: 0.1,
          overlayStops: const [0.3, 0.8],
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: 120,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album.name ?? '',
                            softWrap: true,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                          ),
                          Text(
                            "${album.tracks?.length ?? 0} ${$t(context, 'music')}",
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!(album.isBought ?? false))
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 5, top: 5),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "${album.price ?? 0} €",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              child: Wrap(
                                spacing: 3,
                                alignment: WrapAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/svg/shopping-cart.svg',
                                    height: 16,
                                    color: white,
                                  ),
                                  const FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "Ajouter au panier",
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration:
                                        TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (context.read<AuthProvider>().user ==
                                    null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      title: const Center(
                                        child: Icon(Icons.warning,
                                            size: 30, color: primary),
                                      ),
                                      content: const Text(
                                        "Vous devez être connecté avant d'acheter un album",
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(color: Colors.black),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.popAndPushNamed(
                                                context,
                                                AppRoutes.loginRoute);
                                          },
                                          child: Text(
                                            $t(context, 'sign_in'),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                color: primary),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.popAndPushNamed(
                                                context,
                                                AppRoutes.registerRoute);
                                          },
                                          child: Text(
                                            $t(context,
                                                'create_new_Account'),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                color: primary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  context
                                      .read<CartProvider>()
                                      .addAlbum(album);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.info_outline,
                        size: 20, color: Colors.white70),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          title: const Center(
                            child:
                            Icon(Icons.info_outline, size: 30, color: primary),
                          ),
                          content: Text(
                            album.description ?? '',
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AlbumFavouriteButton(
                        iconSize: 20.0, album: album),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await context
                            .read<DownloadProvider>()
                            .downloadAlbum(album, context);
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/svg/download.svg",
                        height: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    heightScreen = mediaQueryData.size.height;
    paddingBottom = mediaQueryData.padding.bottom;
    width = mediaQueryData.size.width;

    final Album album =
    ModalRoute.of(context)!.settings.arguments as Album;
    final playerProvider =
    Provider.of<PlayerProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: background,
      key: _scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'albums',
          centerTitle: true,
          isBack: true,
        ),
      ),
      body: BaseConnectivity(
        child: CustomScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    margin:
                    const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: _buildContent(album, playerProvider),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: album.tracks?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TrackTile(
                        track: album.tracks![index],
                        index: index,
                        album: album,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

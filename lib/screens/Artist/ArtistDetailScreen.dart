import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/models/Artist.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Artist/TrackTileForArtist.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

class ArtistDetailScreen extends StatelessWidget with BaseMixins {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: artist.name ?? '',
          isBack: true,
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  BaseImage(
                    overlay: false,
                    heroId: artist.id,
                    imageUrl: artist.media?.medium,
                    height: 160,
                    width: double.infinity,
                    radius: 0,
                  ),
                  SizedBox(
                    height: 255,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 15, top: 20, left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                $t(context, 'albums'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            itemCount: artist.albums.length,
                            itemBuilder: (context, index) {
                              final Album album = artist.albums[index];
                              return SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (album.isBought == true)
                                      const Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Acheté",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: white,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.check_circle,
                                              color: white,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    Expanded(
                                      flex: 15,
                                      child: InkWell(
                                        onTap: () {
                                          final playerProvider =
                                          context.read<PlayerProvider>();
                                          playerProvider.currentAlbum = album;

                                          Navigator.of(context).pushNamed(
                                            AppRoutes.albumDetail,
                                            arguments: album,
                                          );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            BaseImage(
                                              imageUrl: album.media?.medium,
                                              height: 140,
                                              width: 140,
                                              radius: 15,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                child: AutoSizeText(
                                                  album.name ?? '',
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxFontSize: 14,
                                                  minFontSize: 14,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (album.isBought != true)
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              padding:
                                              MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                                  EdgeInsets.zero),
                                              backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(Theme.of(context)
                                                  .primaryColor),
                                            ),
                                            onPressed: () {
                                              if (context
                                                  .read<AuthProvider>()
                                                  .user ==
                                                  null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        backgroundColor:
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        title: const Center(
                                                          child: Icon(
                                                            Icons.warning,
                                                            size: 30,
                                                            color: primary,
                                                          ),
                                                        ),
                                                        content: const Text(
                                                          "Vous devez être connecté avant d'acheter un album",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                context,
                                                                AppRoutes
                                                                    .loginRoute,
                                                              );
                                                            },
                                                            child: Text(
                                                              $t(context, 'sign_in'),
                                                              textAlign:
                                                              TextAlign.end,
                                                              style:
                                                              const TextStyle(
                                                                  color:
                                                                  primary),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                context,
                                                                AppRoutes
                                                                    .registerRoute,
                                                              );
                                                            },
                                                            child: Text(
                                                              $t(
                                                                context,
                                                                'create_new_Account',
                                                              ),
                                                              textAlign:
                                                              TextAlign.end,
                                                              style:
                                                              const TextStyle(
                                                                  color:
                                                                  primary),
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
                                            child: Container(
                                              width: 95,
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: [
                                                  const Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Text(
                                                        "Ajouter au panier",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        "${album.price ?? 0} €",
                                                        style: const TextStyle(
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 20, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          $t(context, 'best_music'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  TrakTileForArtist(artist: artist),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

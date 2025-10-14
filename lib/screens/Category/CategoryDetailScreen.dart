import 'package:flutter/material.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with BaseMixins {
  late double heightScreen;
  late double paddingBottom;
  late double width;

  Widget _buildContent(Category category) {
    final coverAlbum = category.albums.firstWhere(
          (e) => e.media?.cover != null && (e.media!.cover?.isNotEmpty ?? false),
      orElse: () => category.albums.first,
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BaseImage(
          imageUrl: coverAlbum.media?.cover,
          height: heightScreen,
          width: width,
          radius: 0,
          overlay: true,
          overlayOpacity: 0.1,
          overlayStops: const [0.3, 0.8],
        ),
        Positioned(
          top: heightScreen / 5.5,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: heightScreen / 2.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name ?? '',
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    heightScreen = mediaQueryData.size.height;
    paddingBottom = mediaQueryData.padding.bottom;
    width = mediaQueryData.size.width;

    final category =
    ModalRoute.of(context)?.settings.arguments as Category?;

    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'categories',
          centerTitle: true,
          isBack: true,
        ),
      ),
      body: BaseConnectivity(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    if (category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        height: heightScreen / 4,
                        child: _buildContent(category),
                      ),
                  ],
                ),
              ),
              if (category != null)
                SliverGrid(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.albumDetail,
                            arguments: category.albums[index],
                          );
                        },
                        child: AlbumTile(
                          album: category.albums[index],
                        ),
                      );
                    },
                    childCount: category.albums.length,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

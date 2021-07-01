import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/providers/CartProvider.dart';
import 'package:senetunes/widgtes/Album/AlbumTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class CategoryDetailScreen extends StatefulWidget {
  @override
  _CategoryDetailScreen createState() => _CategoryDetailScreen();
}

class _CategoryDetailScreen extends State<CategoryDetailScreen> with BaseMixins {
  double heightScreen;
  double paddingBottom;
  double width;

  _buildContent(Category category) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BaseImage(
            imageUrl: category.albums.firstWhere((e) => e.media.cover != null)?.media?.cover,
            height: heightScreen,
            width: width,
            radius: 0,
            overlay: true,
            overlayOpacity: 0.1,
            overlayStops: [0.3, 0.8],
          ),
          Positioned(
            top: heightScreen / 5.5,
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: heightScreen / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              category.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (category.description != null)
                      Expanded(
                        child: Container(
                          height: 100,
                          child: ListView(
                            children: [
                              Container(
                                width: width,
                                height: 0,
                                margin: EdgeInsets.only(bottom: 20),
                                child: ExpandableText(category.description,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        height: 1.5,
                                        fontSize: 12),
                                    expandText: $t(context, 'show_more'),
                                    collapseText: $t(
                                      context,
                                      'show_less',
                                    ),
                                    maxLines: 4,
                                    linkColor: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    heightScreen = mediaQueryData.size.height;
    paddingBottom = mediaQueryData.padding.bottom;
    width = mediaQueryData.size.width;

    Category category = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: BaseConnectivity(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: BaseAppBar(
                isHome: false,
              ).leadingIcon(
                isCart: false,
                isHome: false,
                cartLength: context.watch<CartProvider>().cart.length,
                context: context,
              ),
              expandedHeight: heightScreen / 3.0,
              pinned: true,
              floating: false,
              elevation: 1,
              snap: false,
              actions: <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildContent(category),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
    );
  }
}

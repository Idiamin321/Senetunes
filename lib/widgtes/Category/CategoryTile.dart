import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/widgtes/common/BaseImage.dart';

class CategoryTile extends StatelessWidget with BaseMixins {
  final Category category;
  CategoryTile({this.category});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 100,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                BaseImage(
                  heroId: category.id,
                  imageUrl: categoryProvider.getCategoryMedium(category) != null
                      ? categoryProvider.getCategoryMedium(category)
                      : categoryProvider.getCategoryThumbnail(category) != null
                          ? categoryProvider.getCategoryThumbnail(category)
                          : categoryProvider.getCategoryCover(category),
                  height: height * 0.2,
                  width: responsive(context, isTablet: 170.0, isPhone: 150.0, isSmallPhone: 135.0),
                  radius: 5.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "${category.name}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${category.albums.length} albums',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

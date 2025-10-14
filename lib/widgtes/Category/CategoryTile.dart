import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
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
      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                BaseImage(
                  heroId: category.id,
                  imageUrl: categoryProvider.getCategoryMedium(category),
                  height: height * 0.2,
                  width: responsive(context,
                      isTablet: 170.0, isPhone: 150.0, isSmallPhone: 135.0),
                  radius: 10.0,
                ),
              ],
            ),
          ),
          Expanded(
            flex:2,
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4,left:5,),
              child: Align(
                alignment: Alignment.centerLeft,
                child:AutoSizeText(
                "${category.name}",overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                minFontSize: 14,
                maxFontSize: 16,
                style: TextStyle(
                  // fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: white,
                ),),
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Padding(
              padding: EdgeInsets.only(left:5),
              child:Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  '${category.albums.length} albums',
                  maxFontSize: 14,minFontSize: 12,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
                // SizedBox(width: 20),
              ],
            ),),
          ),
        ],
      ),
    );
  }
}

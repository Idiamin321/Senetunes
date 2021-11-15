import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/ImagePreview.dart';

class CategoryWidget extends StatelessWidget with BaseMixins {
  final List<Category> categories;
  final String title;
  CategoryWidget({this.title, this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        children: [
          WidgetHeader(title: title, route: AppRoutes.categoryScreen),
          Expanded(
            child: Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  // print('==${category.albums[0].media.thumbnail}');
                  return Container(
                    width: 150,
                    // color: background,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.categoryDetail,
                          arguments: category,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseImage(
                            heroId: category.id,
                            imageUrl: category.albums[0].media.thumbnail,
                            height: 140,
                            width: 140,
                            radius: 15.0,
                          ),
//                           ImagePreview(
//                             images: [
//                               category.albums[0].media.thumbnail!=null?category.albums[0].media.thumbnail:
// "assets/images/you.jpg"
//                             ],
//                           ),
//                            albumCard(album.media.thumbnail, 100, 100),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 0),
                            child: Container(
                              child: AutoSizeText(
                                '${category.name}',
                                softWrap: true,
                                maxFontSize: 14,
                                minFontSize: 12,
                                style: TextStyle(
                                    // fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

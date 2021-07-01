import 'package:flutter/material.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/widgtes/Common/WidgetHeader.dart';
import 'package:senetunes/widgtes/ImagePreview.dart';

class CategoryWidget extends StatelessWidget with BaseMixins {
  final List<Category> categories;
  final String title;
  CategoryWidget({this.title, this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Column(
        children: [
          WidgetHeader(title: title, route: AppRoutes.categoryScreen),
          Expanded(
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  return Container(
                    width: 150,
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
                          ImagePreview(
                            images: [
                              category.albums
                                  .firstWhere((e) => e.media.thumbnail != null)
                                  .media
                                  .thumbnail
                            ],
                          ),
                          //  albumCard(album.media.thumbnail, 100, 100),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                            child: Container(
                              child: Text(
                                '${category.name}',
                                softWrap: true,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
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

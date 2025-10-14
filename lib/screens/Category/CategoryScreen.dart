import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Category/CategoryTile.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class CategoryScreen extends StatelessWidget with BaseMixins {
  CategoryScreen({super.key});

  final ScrollController scrollController = ScrollController();

  Widget _buildGridItem(BuildContext context, Category category) => InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoutes.categoryDetail,
        arguments: category,
      );
    },
    child: CategoryTile(category: category),
  );

  @override
  Widget build(BuildContext context) {
    // Force init (pas utilisé directement ici)
    context.read<PlayerProvider>();
    final p = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'categories',
          isBack: true,
          centerTitle: false,
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: p.isLoaded,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 50),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                itemCount: p.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive(
                    context,
                    isSmallPhone: 2,
                    isPhone: 3,
                    isTablet: 4,
                  ),
                  childAspectRatio: responsive(
                    context,
                    isPhone: 0.8,
                    isSmallPhone: 0.8,
                    isTablet: 0.6,
                  ),
                ),
                itemBuilder: (context, index) {
                  return _buildGridItem(context, p.categories[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

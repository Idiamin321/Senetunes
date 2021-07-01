import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/widgtes/Category/CategoryTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';

class CategoryScreen extends StatelessWidget with BaseMixins {
  final ScrollController scrollController = new ScrollController();

  _buildGridItem(BuildContext context, Category category) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.categoryDetail,
            arguments: category,
          );
        },
        child: CategoryTile(
          category: category,
        ),
      );

  @override
  Widget build(BuildContext context) {
    CategoryProvider p = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
          // darkMode: context.watch<ThemeProvider>().darkMode,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
              isLoaded: p.isLoaded,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: p.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context, isSmallPhone: 2, isPhone: 2, isTablet: 4),
                      childAspectRatio:
                          responsive(context, isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    print(p.getCategoryMedium(p.categories[index]));
                    return _buildGridItem(context, p.categories[index]);
                  },
                ),
              )),
        ),
      ),
    );
  }
}

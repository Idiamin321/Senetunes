import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Category.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/CategoryProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/widgtes/Category/CategoryTile.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

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
    final PlayerProvider playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    CategoryProvider p = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: $t(context, "categories"),
          isBack: true,
          centerTitle: false,
        ),
        //   child: BaseAppBar(
        //     isHome: false,
        //     // darkMode: context.watch<ThemeProvider>().darkMode,
        //   ),
      ),
      // //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
              isLoaded: p.isLoaded,
              child: Container(
                height:MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 10,left:10,right:10,bottom:track!=null?50:10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: p.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive(context,
                          isSmallPhone: 2, isPhone: 3, isTablet: 4),
                      childAspectRatio: responsive(context,
                          isPhone: 0.8, isSmallPhone: 0.8, isTablet: 0.6)),
                  itemBuilder: (context, index) {
                    print("===--=");
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

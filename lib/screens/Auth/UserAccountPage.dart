import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/PlayerProvider.dart';
import 'package:senetunes/providers/ThemeProvider.dart';
import 'package:senetunes/widgtes/Common/BaseConnectivity.dart';
import 'package:senetunes/widgtes/Common/BaseScaffold.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';
import 'package:senetunes/widgtes/Common/CustomCircularProgressIndicator.dart';

import '../../widgtes/Common/BaseAppBar.dart';

class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> with BaseMixins {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthProvider>();
    GlobalConfiguration cfg = GlobalConfiguration();
    var themeProvider = Provider.of<ThemeProvider>(context);
    final PlayerProvider playerProvider =
    Provider.of<PlayerProvider>(context, listen: false);
    Track track = playerProvider.currentTrack;

    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: BaseScreenHeading(
          title: 'Settings',
          isBack: true,
          centerTitle: false,
        ),
      ),
      body: SafeArea(
        child: BaseConnectivity(
          child: BaseScaffold(
            isLoaded: true,
            child: provider.isLoaded
                ? Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: provider.user != null
                      ? ListTile(
                    title: Text(
                      provider.user.firstName != null
                          ? provider.user.firstName
                          : "",
                      style: const TextStyle(color: white),
                    ),
                    subtitle: Text(
                      provider.user.email != null
                          ? provider.user.email
                          : "",
                      style: const TextStyle(color: white),
                    ),
                  )
                      : Column(
                    children: <Widget>[
                      ListTile(
                        tileColor: background,
                        title: Text($t(context, 'sign_in')),
                        leading: const Icon(
                          Icons.verified_user,
                          size: 22,
                          color: primary,
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.loginRoute),
                      ),
                      const Divider(height: 0),
                      ListTile(
                        tileColor: background,
                        title:
                        Text($t(context, 'create_new_Account')),
                        leading: const Icon(
                          Icons.account_circle,
                          size: 22,
                          color: primary,
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.registerRoute),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        tileColor: background,
                        title: Text($t(context, 'download')),
                        leading: SizedBox(
                          height: 50,
                          child: SvgPicture.asset(
                            "assets/icons/svg/download.svg",
                            height: 18,
                            color: primary,
                          ),
                        ),
                        onTap: () => {
                          Navigator.pushNamed(
                              context, AppRoutes.downloadScreenRoute)
                        },
                      ),
                      ListTile(
                        tileColor: background,
                        title: Text($t(context, 'help')),
                        leading: const Icon(
                          Icons.help,
                          size: 22,
                          color: primary,
                        ),
                        onTap: () => {
                          Navigator.pushNamed(
                              context, AppRoutes.contactUs)
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        tileColor: background,
                        title: Text($t(context, 'rate')),
                        leading: const Icon(
                          Icons.star,
                          size: 22,
                          color: primary,
                        ),
                        onTap: () async {
                          final inAppReview = InAppReview.instance;
                          if (await inAppReview.isAvailable()) {
                            await inAppReview.requestReview();
                          } else {
                            await inAppReview.openStoreListing();
                          }
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        tileColor: background,
                        title: Text($t(context, 'who_is_senetunes')),
                        leading: const Icon(
                          Icons.info,
                          size: 22,
                          color: primary,
                        ),
                        onTap: () => {
                          Navigator.pushNamed(
                              context, AppRoutes.aboutUs)
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (provider.isLoggedIn)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          tileColor: background,
                          title: Text($t(context, 'sign_out')),
                          leading: SizedBox(
                            height: 50,
                            child: SvgPicture.asset(
                              "assets/icons/svg/logout (4).svg",
                              height: 18,
                              color: primary,
                            ),
                          ),
                          onTap: () => provider.logout(),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
              ],
            )
                : const CustomCircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

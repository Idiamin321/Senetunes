import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Track.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/providers/CartProvider.dart';
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
    GlobalConfiguration cfg = new GlobalConfiguration();
    var themeProvider = Provider.of<ThemeProvider>(context);
    final PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);
    Track track;
    track = playerProvider.currentTrack;
    return new Scaffold(
        backgroundColor: background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: BaseScreenHeading(
            title: $t(context, 'settings'),
            isBack: true,
            centerTitle: false,
          ),
        ),
        body: SafeArea(
            child: BaseConnectivity(
                child: BaseScaffold(
                    isLoaded: true,
                    child: provider.isLoaded
                        ?
                        // SingleChildScrollView(
                        //           child:
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                
                                margin:EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: barColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: provider.user != null
                                    ? ListTile(
                                  title: Text(
                                          provider.user.firstName != null
                                              ? provider.user.firstName
                                              : "",
                                          style: TextStyle(color: white),
                                        ),
                                        subtitle: Text(
                                          provider.user.email != null
                                              ? provider.user.email
                                              : "",
                                          style: TextStyle(color: white),
                                        ),
                                        // trailing: Icon(Icons.edit),
                                        // onTap: () => Navigator.of(context).pushNamed(
                                        //   AppRoutes.profileEditRoute,
                                        //   arguments: provider.user.id, //user.id
                                        // ),
                                      )
                                    : Column(
                                        children: <Widget>[
                                          ListTile(
                                            tileColor: background,
                                            title: Text($t(context, 'sign_in')),
                                            leading: Icon(
                                              Icons.verified_user,
                                              size: 22,
                                              color: primary,
                                            ),
                                            onTap: () => Navigator.pushNamed(
                                                context, AppRoutes.loginRoute),
                                          ),
                                          Divider(height: 0),
                                          ListTile(
                                            tileColor: background,
                                            title: Text($t(
                                              context,
                                              'create_new_Account',
                                            )),
                                            leading: Icon(
                                              Icons.account_circle,
                                              size: 22,
                                              color: primary,
                                            ),
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                AppRoutes.registerRoute),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(height: 10),

                              //--------------------------------------
                              //Saved payments and credit cards UI

                              // if (provider.isLoggedIn)
                              //   Card(
                              //     elevation: 2,
                              //     margin: EdgeInsets.all(0),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(0),
                              //     ),
                              //     child: Column(
                              //       children: <Widget>[
                              //         ListTile(
                              //           title: Text($t(
                              //             context,
                              //             'your_payments',
                              //           )),
                              //           leading: Icon(
                              //             Icons.monetization_on,
                              //             size: 22,color:primary,
                              //           ),
                              //           onTap: () => {},
                              //         ),
                              //         Divider(height: 0),
                              //         ListTile(
                              //           title: Text($t(
                              //             context,
                              //             'save_payments',
                              //           )),
                              //           leading: Icon(
                              //             Icons.credit_card,
                              //             size: 22,color:primary,
                              //           ),
                              //           onTap: () => {},
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // SizedBox(height: 10),

                              //-----------------------------------------------

                              Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      tileColor: background,
                                      title: Text($t(context, 'download')),
                                      leading:SizedBox(
                                        height: 50,
                                        child: SvgPicture.asset(
                                          "assets/icons/svg/download.svg",
                                          height: 18,
                                          color: primary,
                                        ),
                                      ),
                                      onTap: () => {
                                        Navigator.pushNamed(context,
                                            AppRoutes.downloadScreenRoute)
                                      },
                                    ),
                                    ListTile(
                                      tileColor: background,
                                      title: Text($t(context, 'help')),
                                      leading: Icon(
                                        Icons.help,
                                        size: 22,
                                        color: primary,
                                      ),
                                      onTap: () => {
                                        Navigator.pushNamed(
                                            context, AppRoutes.contactUs)
                                      },
                                    ),
                                    Divider(height: 0),
                                    ListTile(
                                      tileColor: background,
                                      title: Text($t(context, 'rate')),
                                      leading: Icon(
                                        Icons.star,
                                        size: 22,
                                        color: primary,
                                      ),
                                      onTap: () async {
                                        AppReview.writeReview.then(
                                          (onValue) {
                                            print(onValue);
                                          },
                                        );
                                      },
                                    ),
                                    Divider(height: 0),
                                    ListTile(
                                      tileColor: background,
                                      title: Text($t(
                                        context,
                                        'who_is_senetunes',
                                      )),
                                      leading: Icon(
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
                              SizedBox(height: 10),
                              if (provider.isLoggedIn)
                                Card(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        tileColor: background,
                                        title: Text(
                                          $t(
                                            context,
                                            'sign_out',
                                          ),
                                        ),
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
                              Spacer(),
                              // Card(
                              //   margin: EdgeInsets.all(0),
                              //   child: ListTile(
                              //     tileColor: background,
                              //     title: Text($t(
                              //       context,
                              //       'mode_String',
                              //     )),
                              //     trailing: Switch(
                              //         value: !themeProvider.darkMode,
                              //         onChanged: (val) {
                              //           themeProvider.toggleChangeTheme();
                              //         }),
                              //     leading: Icon(
                              //       Icons.star,
                              //       size: 22,
                              //       color: primary,
                              //     ),
                              //     onTap: () => {},
                              //   ),
                              // ),
                            ],
                          )
                        : CustomCircularProgressIndicator()))));
  }
}

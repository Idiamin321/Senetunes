import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/config/AppRoutes.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/providers/AuthProvider.dart';
import 'package:flutter_rekord_app/providers/CartProvider.dart';
import 'package:flutter_rekord_app/providers/ThemeProvider.dart';
import 'package:flutter_rekord_app/widgtes/Common/CustomCircularProgressIndicator.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

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
    return new Scaffold(
      appBar: new AppBar(
        leading: BaseAppBar(
          isHome: false,
          // darkMode: context.watch<ThemeProvider>().darkMode,
        ).leadingIcon(
          isCart: false,
          isHome: false,
          brightness: MediaQuery.of(context).platformBrightness,
          cartLength: context.watch<CartProvider>().cart.length,
          context: context,
        ),
        title: Text(
          $t(context, 'account'),
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
      ),
      body: provider.isLoaded
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: provider.user != null
                        ? ListTile(
                            title: Text(
                                provider.user.firstName != null ? provider.user.firstName : ""),
                            subtitle: Text(provider.user.email != null ? provider.user.email : ""),
                            // trailing: Icon(Icons.edit),
                            // onTap: () => Navigator.of(context).pushNamed(
                            //   AppRoutes.profileEditRoute,
                            //   arguments: provider.user.id, //user.id
                            // ),
                          )
                        : Column(
                            children: <Widget>[
                              ListTile(
                                title: Text($t(context, 'sign_in')),
                                leading: Icon(
                                  Icons.verified_user,
                                  size: 22,
                                ),
                                onTap: () => Navigator.pushNamed(context, AppRoutes.loginRoute),
                              ),
                              Divider(height: 0),
                              ListTile(
                                title: Text($t(
                                  context,
                                  'create_new_Account',
                                )),
                                leading: Icon(
                                  Icons.account_circle,
                                  size: 22,
                                ),
                                onTap: () => Navigator.pushNamed(context, AppRoutes.registerRoute),
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
                  //             size: 22,
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
                  //             size: 22,
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
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text($t(context, 'download')),
                          leading: Icon(
                            Icons.download_sharp,
                            size: 22,
                          ),
                          onTap: () =>
                              {Navigator.pushNamed(context, AppRoutes.downloadScreenRoute)},
                        ),
                        ListTile(
                          title: Text($t(context, 'help')),
                          leading: Icon(
                            Icons.help,
                            size: 22,
                          ),
                          onTap: () => {Navigator.pushNamed(context, AppRoutes.contactUs)},
                        ),
                        Divider(height: 0),
                        ListTile(
                          title: Text($t(context, 'rate')),
                          leading: Icon(
                            Icons.star,
                            size: 22,
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
                          title: Text($t(
                            context,
                            'who_is_senetunes',
                          )),
                          leading: Icon(
                            Icons.info,
                            size: 22,
                          ),
                          onTap: () => {Navigator.pushNamed(context, AppRoutes.aboutUs)},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  if (provider.isLoggedIn)
                    Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              $t(
                                context,
                                'sign_out',
                              ),
                            ),
                            leading: Icon(
                              Icons.account_circle,
                              size: 22,
                            ),
                            onTap: () => provider.logout(),
                          ),
                        ],
                      ),
                    ),
                  Card(
                    margin: EdgeInsets.all(0),
                    child: ListTile(
                      title: Text($t(
                        context,
                        'mode_String',
                      )),
                      trailing: Switch(
                          value: !themeProvider.darkMode,
                          onChanged: (val) {
                            themeProvider.toggleChangeTheme();
                          }),
                      leading: Icon(
                        Icons.star,
                        size: 22,
                      ),
                      onTap: () => {},
                    ),
                  ),
                ],
              ),
            )
          : CustomCircularProgressIndicator(),
    );
  }
}

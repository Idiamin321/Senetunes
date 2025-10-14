import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).primaryColorDark,
    );
    final TextStyle normalStyle = TextStyle(
      fontSize: 18,
      decoration: TextDecoration.none,
      color: Theme.of(context).primaryColorDark,
    );

    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BaseScreenHeading(
          title: "Contactez nous",
          isBack: true,
          centerTitle: false,
        ),
      ),
      body: Theme(
        data: Theme.of(context),
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              Card(
                color: background,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(text: 'Contactez nous\n', style: titleStyle),
                      TextSpan(
                        text:
                        'HENTECH , DAKAR, CITE MIXTA, ROUTE DE L\'AEROPORT, B27B22\n\n',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

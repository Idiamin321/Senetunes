import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/widgtes/Common/BaseAppBar.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).primaryColorDark,
    );
    TextStyle normalStyle = TextStyle(fontSize: 18, decoration: TextDecoration.none, color: Theme.of(context).primaryColorDark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BaseAppBar(
          isHome: false,
        ),
      ),
      body: Theme(
        data: Theme.of(context),
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              Card(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Contactez nous\n',
                        style: titleStyle,
                      ),
                      TextSpan(text: 'HENTECH , DAKAR, CITE MIXTA, ROUTE DE L\'AEROPORT, B27B22\n\n'),
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

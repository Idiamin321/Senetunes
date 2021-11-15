import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/widgtes/Common/BaseAppBar.dart';
import 'package:senetunes/widgtes/Common/BaseScreenHeading.dart';

class AboutUs extends StatelessWidget with BaseMixins{
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).primaryColorDark,
    );
    TextStyle normalStyle = TextStyle(
        fontSize: 18, decoration: TextDecoration.none, color: Theme.of(context).primaryColorDark);
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child:BaseScreenHeading(
            title:$t(
              context,
              'who_is_senetunes',
            ),
          centerTitle: false,isBack: true,
        )
        // child: BaseAppBar(
        //   isHome: false,
        // ),
      ),
      body: Theme(
        data: Theme.of(context),
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              // Text(
              //   'A propos\n',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 35,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Card(
                color: background,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Contexte\n',
                        style: titleStyle,
                      ),
                      TextSpan(
                          text:
                              'Avec l’avènement des nouvelles technologies, la vente de CD est devenue obsolète car c’est très rare de nos jours de voir un mélomane avec des appareils tel qu’un lecteur CD. Aujourd’hui la musique est devenu mobile, et le mode de commercialisation le plus répandu est le téléchargement légal.\n\n'),
                      TextSpan(
                          text:
                              'Face à cette mutation technologique, la musique Sénégalaise se devait d’apporter des éléments de réponses afin de permettre aux artistes Sénégalais de continuer à vendre le fruit de leur travail à savoir leur musique. C’est ainsi qu’est née SENETUNES pour apporter une innovation dans la commercialisation de la musique Sénégalaise.\n\n'),
                    ],
                  ),
                ),
              ),
              Card(
                color: background,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Objectif\n',
                        style: titleStyle,
                      ),
                      TextSpan(
                          text:
                              'SENETUNES a aujourd’hui pour vocation de regrouper tous les acteurs de la musique Sénégalaise (auteurs, compositeurs, producteurs, interprètes) autour de sa plateforme de téléchargement légal et leur offrir un soutien technologique leur permettant de vendre leurs musiques au-delà des frontières du Sénégal et de L’Afrique.\n\n'),
                      TextSpan(
                          text:
                              'De plus en appliquant une stratégie commerciale bien étudiée, SENETUNES pourra fidéliser tous les clients de la plateforme, et ainsi apporter une réponse à un frein au développement de la musique Sénégalaise à savoir le piratage.\n\n'),
                    ],
                  ),
                ),
              ),
              Card(
                color: background,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Fonctionnalités Offertes\n',
                        style: titleStyle,
                      ),
                      TextSpan(
                          text:
                              'SENETUNES est une application WEB toute simple qui permet à n’importe quel internaute disposant d’une connexion internet de se connecter à la plateforme en tapant l’adresse www.senetunes.com . Ainsi les clients pourront créer un compte, et avoir la possibilité d’acheter autant de contenus musicaux qu’ils le désirent.  De plus avec un système d’alerte bien élaboré, toutes les personnes inscrites sur le site pourront recevoir des mails leur informant de la disponibilité de nouveaux albums téléchargeables sur la plateforme.\n\n'),
                      TextSpan(
                          text:
                              'Les modes de paiements sur la plateforme sont très simples et prennent en compte le faible taux de bancarisation au Sénégal, ainsi les internautes pourront payer avec Paypal ou par Carte Bancaire ou par Passcourses (Senegal Mali ou Cote d\'Ivoire).\n\n'),
                    ],
                  ),
                ),
              ),
              Card(
                color: background,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Contenu Musical\n',
                        style: titleStyle,
                      ),
                      TextSpan(
                          text:
                              'SENETUNES proposera un répertoire varié et diversifié de la musique Sénégalaise : Du Mbalakh au Rap Galsen en passant par l’acoustique, la salsa, le reggae et le Ngueros.\n\n'),
                      TextSpan(
                          text:
                              'Avec les partenariats qui sont prévus avec les artistes et maisons de production Sénégalaise, SENETUNES revisitera le répertoire des morceaux qui ont marqué l’histoire de la musique Sénégalaise. Tous les internautes seront servis, du plus âgé au  plus jeunes.\n\n'),
                      TextSpan(
                          text:
                              'SENETUNES est ouvert à tous les artistes Sénégalais et cela sans exception.\n\n'),
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

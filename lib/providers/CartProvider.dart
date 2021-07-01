import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/Album.dart';
import 'AuthProvider.dart';
import 'BaseProvider.dart';

class CartProvider extends BaseProvider {
  List<Album> cart = [];
  String url;
  Map<String, dynamic> request;
  String completed;

  void addAlbum(Album album) {
    if (!cart.contains(album)) {
      cart.add(album);
      notifyListeners();
    }
  }

  void removeAlbum(Album album) {
    cart.remove(album);
    notifyListeners();
  }

  void clearCart() {
    cart = [];
    notifyListeners();
  }

  void getResponse(BuildContext context, String email) async {
    if (request != null) {
      var url =
          'https://app.paydunya.com/sandbox-api/v1/checkout-invoice/confirm/${request['token']}';
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'PAYDUNYA-MASTER-KEY': 'PbGPDHfX-nCK1-jXjH-2ifY-EDdkAgpWvL8W',
          'PAYDUNYA-PRIVATE-KEY': 'test_private_6HRGpqGOTDFSlOtz4YpBDg4Mf6F',
          'PAYDUNYA-TOKEN': 'eWBnLwkEX8f7XNmEQVo8'
        },
      );
      var body = jsonDecode(response.body);
      completed = body['status'];
      print(completed);
      if (completed == 'completed') {
        await _boughtSuccessful(context, email);
      }
    }
  }

  albumBought(Album album, AlbumProvider albumProvider) {
    albumProvider.allAlbums[album.id].isBought = true;
  }

  Future<Map<String, dynamic>> postRequest() async {
    var url = 'https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create';
    String description = "";
    double totalAmount = 0.0;
    for (Album album in cart) {
      description = "$description\n${album.name}";
      totalAmount += album.price;
    }
    var body = json.encode(
      {
        "invoice": {
          "total_amount": (totalAmount * 655).toStringAsFixed(2),
          "description": description
        },
        "store": {"name": "Senetunes"},
        "actions": {"callback_url": "http://www.magasin-le-choco.com/callback_url.php"}
      },
    );

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'PAYDUNYA-MASTER-KEY': 'PbGPDHfX-nCK1-jXjH-2ifY-EDdkAgpWvL8W',
        'PAYDUNYA-PRIVATE-KEY': 'test_private_6HRGpqGOTDFSlOtz4YpBDg4Mf6F',
        'PAYDUNYA-TOKEN': 'eWBnLwkEX8f7XNmEQVo8'
      },
      body: body,
    );

    request = json.decode(response.body);
    notifyListeners();
    return request;
  }

  _boughtSuccessful(BuildContext context, String email) async {
    print("ASDAKLSDNASLDNALSDNASD");
    for (Album album in cart) {
      http.Response response;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'));
      String xml = """<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
<albums>
	<description><![CDATA[${album.description}]]></description>
	<totalPaid>${album.price}</totalPaid> 
	<payment>paydunya</payment> 
	<artistInfo notFilterable="true"><artistId><![CDATA[${album.artistId}]]></artistId></artistInfo>
	<songs><albumId>${album.id}</albumId><albumId>40</albumId></songs>
	<userEmail>$email</userEmail>
</albums>
</prestashop>""";
      response = await http.post(
        "http://ec2-15-237-94-117.eu-west-3.compute.amazonaws.com/senetunesproduction/api/order_supplier?schema=blank",
        headers: <String, String>{
          'authorization': basicAuth,
          'content-type': "text/xml;charset=utf-8"
        },
        body: xml,
      );
      print(response.body);
    }
    request = null;
    clearCart();
    await context.read<AuthProvider>().fetchBoughtAlbums(context.read<AuthProvider>().user.email);
    await context
        .read<AlbumProvider>()
        .updateBoughtAlbums(context.read<AuthProvider>().boughtAlbumsIds);
    notifyListeners();
  }
}

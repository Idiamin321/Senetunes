import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:http/http.dart' as http;

import '../models/Album.dart';
import 'BaseProvider.dart';

class CartProvider extends BaseProvider {
  List<Album> cart = [];
  String url;
  Map<String, dynamic> request;
  String completed;

  Set<Album> boughtAlbum = Set();
  Set<Track> boughtTracks = Set();

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

  void getResponse(BuildContext context) async {
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
      if (completed == 'completed') {}

      notifyListeners();
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
        "invoice": {"total_amount": totalAmount.toStringAsFixed(2), "description": description},
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

  boughtSuccessful() {
    boughtAlbum.addAll(cart);
    for (Album album in cart) {
      boughtTracks.addAll(album.tracks);
    }
    Dio dio = Dio();
    dio.post("http://ec2-15-237-94-117.eu-west-3.compute.amazonaws.com/senetunesproduction/api/order_supplier",data:"",options: Options(contentType: "text/xml",) )
    clearCart();
  }
}
